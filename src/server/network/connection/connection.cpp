/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "server/network/connection/connection.h"
#include "server/network/message/outputmessage.h"
#include "server/network/protocol/protocol.h"
#include "server/network/protocol/protocolgame.h"
#include "game/scheduling/scheduler.h"
#include "server/server.h"

Connection_ptr ConnectionManager::createConnection(boost::asio::io_service& io_service, ConstServicePort_ptr servicePort)
{
	std::lock_guard<std::mutex> lockClass(connectionManagerLock);

	auto connection = std::make_shared<Connection>(io_service, servicePort);
	connections.insert(connection);
	return connection;
}

void ConnectionManager::releaseConnection(const Connection_ptr& connection)
{
	std::lock_guard<std::mutex> lockClass(connectionManagerLock);

	connections.erase(connection);
}

void ConnectionManager::closeAll()
{
	std::lock_guard<std::mutex> lockClass(connectionManagerLock);

	for (const auto& connection : connections) {
		try {
			boost::system::error_code error;
			connection->socket.shutdown(boost::asio::ip::tcp::socket::shutdown_both, error);
			connection->socket.close(error);
		} catch (boost::system::system_error&) {
		}
	}
	connections.clear();
}

// Connection
// Constructor
Connection::Connection(boost::asio::io_service& initIoService, ConstServicePort_ptr initservicePort) :
	readTimer(initIoService),
	writeTimer(initIoService),
	service_port(std::move(initservicePort)),
	socket(initIoService)
{
	timeConnected = time(nullptr);
}
// Constructor end

void Connection::close(bool force)
{
	//any thread
	ConnectionManager::getInstance().releaseConnection(shared_from_this());

	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}
	connectionState = CONNECTION_STATE_CLOSED;

	if (protocol) {
		g_dispatcher().addTask(
			createSchedulerTask(1000, std::bind(&Protocol::release, protocol)));
	}

	if (messageQueue.empty() || force) {
		closeSocket();
	} else {
		//will be closed by the destructor or onWriteOperation
	}
}

void Connection::closeSocket()
{
	if (socket.is_open()) {
		try {
			readTimer.cancel();
			writeTimer.cancel();
			boost::system::error_code error;
			socket.shutdown(boost::asio::ip::tcp::socket::shutdown_both, error);
			socket.close(error);
		} catch (const boost::system::system_error& e) {
			SPDLOG_ERROR("[Connection::closeSocket] - error: {}", e.what());
		}
	}
}

void Connection::accept(Protocol_ptr protocolPtr)
{
	this->connectionState = CONNECTION_STATE_IDENTIFYING;
	this->protocol = protocolPtr;
	g_dispatcher().addTask(createSchedulerTask(1000, std::bind(&Protocol::onConnect, protocolPtr)));

	// Call second accept for not duplicate code
	accept(false);
}

void Connection::accept(bool toggleParseHeader /* = true */)
{
	try {
		readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));
		
		// If toggleParseHeader is true, execute the parseHeader, if not, execute parseProxyIdentification
		if (toggleParseHeader) {
			// Read size of the first packet
			boost::asio::async_read(socket,
									boost::asio::buffer(msg.getBuffer(), HEADER_LENGTH),
									std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
		} else {
			// Read header bytes to identify if it is proxy identification
			boost::asio::async_read(socket,
									boost::asio::buffer(msg.getBuffer(), HEADER_LENGTH),
									std::bind(&Connection::parseProxyIdentification, shared_from_this(), std::placeholders::_1));
		}
	} catch (const boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::accept] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parseProxyIdentification(const boost::system::error_code& error)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	readTimer.cancel();

	if (error) {
		close(FORCE_CLOSE);
		return;
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	uint8_t* msgBuffer = msg.getBuffer();
	auto charData = static_cast<char*>(static_cast<void*>(msgBuffer));
	std::string serverName = g_configManager().getString(SERVER_NAME) + "\n";
	if (connectionState == CONNECTION_STATE_IDENTIFYING) {
		if (msgBuffer[1] == 0x00 || strncasecmp(charData, &serverName[0], 2) != 0) {
			//Probably not proxy identification so let's try standard parsing method
			connectionState = CONNECTION_STATE_OPEN;
			parseHeader(error);
			return;
		} else {
			size_t remainder = serverName.length()-2;
			if (remainder > 0) {
				connectionState = CONNECTION_STATE_READINGS;
				try {
					readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
					readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

					// Read the remainder of proxy identification
					boost::asio::async_read(socket,
											boost::asio::buffer(msg.getBuffer(), remainder),
											std::bind(&Connection::parseProxyIdentification, shared_from_this(), std::placeholders::_1));
				}
				catch (const boost::system::system_error& e) {
					SPDLOG_ERROR("Connection::parseProxyIdentification] - error: {}", e.what());
					close(FORCE_CLOSE);
				}
				return;
			} else {
				connectionState = CONNECTION_STATE_OPEN;
			}
		}
	} else if (connectionState == CONNECTION_STATE_READINGS) {
		size_t remainder = serverName.length() - 2;
		if (strncasecmp(charData, &serverName[2], remainder) == 0) {
			connectionState = CONNECTION_STATE_OPEN;
		} else {
			SPDLOG_ERROR("Connection::parseProxyIdentification] Invalid Client Login! Server Name mismatch!");
			close(FORCE_CLOSE);
			return;
		}
	}

	accept(true);
}

void Connection::parseHeader(const boost::system::error_code& error)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	readTimer.cancel();

	if (error) {
		close(FORCE_CLOSE);
		return;
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	uint32_t timePassed = std::max<uint32_t>(1, (time(nullptr) - timeConnected) + 1);
	if ((++packetsSent / timePassed) > static_cast<uint32_t>(g_configManager().getNumber(MAX_PACKETS_PER_SECOND))) {
		SPDLOG_WARN("{} disconnected for exceeding packet per second limit.", convertIPToString(getIP()));
		close();
		return;
	}

	if (timePassed > 2) {
		timeConnected = time(nullptr);
		packetsSent = 0;
	}

	uint16_t size = msg.getLengthHeader();
	if (size == 0 || size > INPUTMESSAGE_MAXSIZE) {
		close(FORCE_CLOSE);
		return;
	}

	try {
		readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		// Read packet content
		msg.setLength(size + HEADER_LENGTH);
		boost::asio::async_read(socket,
								boost::asio::buffer(msg.getBodyBuffer(), size),
		                        std::bind(&Connection::parsePacket, shared_from_this(), std::placeholders::_1));
	} catch (const boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::parseHeader] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parsePacket(const boost::system::error_code& error)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	readTimer.cancel();

	if (error) {
		close(FORCE_CLOSE);
		return;
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	bool skipReadingNextPacket = false;
	if (!receivedFirst) {
		// First message received
		receivedFirst = true;

		if (!protocol) {
			//Check packet checksum
			uint32_t checksum;
			if (int32_t len = msg.getLength() - msg.getBufferPosition() - CHECKSUM_LENGTH;
			len > 0)
			{
				checksum = adlerChecksum(msg.getBuffer() + msg.getBufferPosition() + CHECKSUM_LENGTH, len);
			} else {
				checksum = 0;
			}

			uint32_t recvChecksum = msg.get<uint32_t>();
			if (recvChecksum != checksum) {
				// it might not have been the checksum, step back
				msg.skipBytes(-CHECKSUM_LENGTH);
			}

			// Game protocol has already been created at this point
			protocol = service_port->make_protocol(recvChecksum == checksum, msg, shared_from_this());
			if (!protocol) {
				close(FORCE_CLOSE);
				return;
			}
		} else {
			// It is rather hard to detect if we have checksum or sequence method here so let's skip checksum check
			// it doesn't generate any problem because olders protocol don't use 'server sends first' feature
			msg.get<uint32_t>();
			// Skip protocol ID
			msg.skipBytes(1);
		}

		protocol->onRecvFirstMessage(msg);
	} else {
		// Send the packet to the current protocol
		skipReadingNextPacket = protocol->onRecvMessage(msg);
	}

	try {
		readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		if (!skipReadingNextPacket) {
			// Wait to the next packet
			boost::asio::async_read(socket, boost::asio::buffer(msg.getBuffer(), HEADER_LENGTH), std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
		}
	} catch (const boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::parsePacket] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::resumeWork()
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);

	try {
		// Wait to the next packet
		boost::asio::async_read(socket, boost::asio::buffer(msg.getBuffer(), HEADER_LENGTH), std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
	} catch (const boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::resumeWork] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::send(const OutputMessage_ptr& outputMessage)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	bool noPendingWrite = messageQueue.empty();
	messageQueue.emplace_back(outputMessage);
	if (noPendingWrite) {
		// Make asio thread handle xtea encryption instead of dispatcher
		try {
			#if BOOST_VERSION >= 106600
			boost::asio::post(socket.get_executor(), std::bind(&Connection::internalWorker, shared_from_this()));
			#else
			socket.get_io_service().post(std::bind(&Connection::internalWorker, shared_from_this()));
			#endif
		} catch (const boost::system::system_error& e) {
			SPDLOG_ERROR("[Connection::send] - error: {}", e.what());
			messageQueue.clear();
			close(FORCE_CLOSE);
		}
	}
}

void Connection::internalWorker()
{
	std::unique_lock<std::recursive_mutex> lockClass(connectionLock);
	if (!messageQueue.empty()) {
		const OutputMessage_ptr& outputMessage = messageQueue.front();
		lockClass.unlock();
		protocol->onSendMessage(outputMessage);
		lockClass.lock();
		internalSend(outputMessage);
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

uint32_t Connection::getIP()
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);

	// IP-address is expressed in network byte order
	boost::system::error_code error;
	const boost::asio::ip::tcp::endpoint endpoint = socket.remote_endpoint(error);
	if (error) {
		return 0;
	}

	return htonl(endpoint.address().to_v4().to_ulong());
}

void Connection::internalSend(const OutputMessage_ptr& outputMessage)
{
	try {
		writeTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_WRITE_TIMEOUT));
		writeTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		boost::asio::async_write(socket,
		                         boost::asio::buffer(outputMessage->getOutputBuffer(), outputMessage->getLength()),
		                         std::bind(&Connection::onWriteOperation, shared_from_this(), std::placeholders::_1));
	} catch (const boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::internalSend] - error: {}", e.what());
	}
}

void Connection::onWriteOperation(const boost::system::error_code& error)
{
	std::unique_lock<std::recursive_mutex> lockClass(connectionLock);
	writeTimer.cancel();
	messageQueue.pop_front();

	if (error) {
		messageQueue.clear();
		close(FORCE_CLOSE);
		return;
	}

	if (!messageQueue.empty()) {
		const OutputMessage_ptr& outputMessage = messageQueue.front();
		lockClass.unlock();
		protocol->onSendMessage(outputMessage);
		lockClass.lock();
		internalSend(outputMessage);
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

void Connection::handleTimeout(ConnectionWeak_ptr connectionWeak, const boost::system::error_code& error)
{
	if (error == boost::asio::error::operation_aborted) {
		//The timer has been manually cancelled
		return;
	}

	if (auto connection = connectionWeak.lock()) {
		connection->close(FORCE_CLOSE);
	}
}
