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

#include "otpch.h"

#include "config/configmanager.h"
#include "server/network/connection/connection.h"
#include "server/network/message/outputmessage.h"
#include "server/network/protocol/protocol.h"
#include "server/network/protocol/protocolgame.h"
#include "game/scheduling/scheduler.h"
#include "server/server.h"

extern ConfigManager g_config;

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

void Connection::close(bool force)
{
	//any thread
	ConnectionManager::getInstance().releaseConnection(shared_from_this());

	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	connectionState = CONNECTION_STATE_DISCONNECTED;

	if (protocol) {
		g_dispatcher.addTask(
			createTask(std::bind(&Protocol::release, protocol)));
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
		} catch (boost::system::system_error& e) {
			SPDLOG_ERROR("[Connection::closeSocket] - {}", e.what());
		}
	}
}

Connection::~Connection()
{
	closeSocket();
}

void Connection::accept(Protocol_ptr conProtocol)
{
	this->protocol = conProtocol;
	g_dispatcher.addTask(createTask(std::bind(&Protocol::onConnect, protocol)));
	connectionState = CONNECTION_STATE_CONNECTING_STAGE2;

	accept();
}

void Connection::accept()
{
	if (connectionState == CONNECTION_STATE_PENDING) {
		connectionState = CONNECTION_STATE_CONNECTING_STAGE1;
	}
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	try {
		readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		if (!receivedLastChar && receivedName && connectionState == CONNECTION_STATE_CONNECTING_STAGE2) {
			// Read size of the first packet
			boost::asio::async_read(socket,
				boost::asio::buffer(msg.getBuffer(), 1),
				std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
		} else {
			// Read size of the first packet
			boost::asio::async_read(socket,
				boost::asio::buffer(msg.getBuffer(), NetworkMessage::HEADER_LENGTH),
				std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
		}
	} catch (boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::accept] - {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parseHeader(const boost::system::error_code& error)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	readTimer.cancel();

	if (error) {
		close(FORCE_CLOSE);
		return;
	} else if (connectionState == CONNECTION_STATE_DISCONNECTED) {
		return;
	}

	uint32_t timePassed = std::max<uint32_t>(1, (time(nullptr) - timeConnected) + 1);
	if ((++packetsSent / timePassed) > static_cast<uint32_t>(g_config.getNumber(ConfigManager::MAX_PACKETS_PER_SECOND))) {
			SPDLOG_INFO("{} disconnected for exceeding packet per second limit", convertIPToString(getIP()));
			close();
			return;
	}

	if (!receivedLastChar && connectionState == CONNECTION_STATE_CONNECTING_STAGE2) {
		uint8_t* msgBuffer = msg.getBuffer();

		if (!receivedName && msgBuffer[1] == 0x00) {
			receivedLastChar = true;
		} else {
			std::string serverName = g_config.getString(ConfigManager::SERVER_NAME) + "\n";

			if (!receivedName) {
				if (static_cast<char>(msgBuffer[0]) == serverName[0]
						&& static_cast<char>(msgBuffer[1]) == serverName[1]) {
					receivedName = true;
					serverNameTime = 1;

					accept();
					return;
				} else {
					SPDLOG_ERROR("Connection::parseHeader] "
                                 "Invalid Client Login! Server Name mismatch!");
					close(FORCE_CLOSE);
					return;
				}
			}
			++serverNameTime;

			if (static_cast<char>(msgBuffer[0]) == serverName[serverNameTime]) {
				if (msgBuffer[0] == 0x0A) {
					receivedLastChar = true;
				}

				accept();
				return;
			} else {
				SPDLOG_ERROR("Connection::parseHeader] "
                             "Invalid Client Login! Server Name mismatch!");
				close(FORCE_CLOSE);
				return;
			}
		}
	}

	if (receivedLastChar && connectionState == CONNECTION_STATE_CONNECTING_STAGE2) {
		connectionState = CONNECTION_STATE_GAME;
	}

	if (timePassed > 2) {
		timeConnected = time(nullptr);
		packetsSent = 0;
	}

	uint16_t size = msg.getLengthHeader();
	if (size == 0 || size >= NETWORKMESSAGE_MAXSIZE - 16) {
		close(FORCE_CLOSE);
		return;
	}

	try {
		readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()),
		                                    std::placeholders::_1));

		// Read packet content
		msg.setLength(size + NetworkMessage::HEADER_LENGTH);
		boost::asio::async_read(socket, boost::asio::buffer(msg.getBodyBuffer(), size),
		                        std::bind(&Connection::parsePacket, shared_from_this(), std::placeholders::_1));
	} catch (boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::parseHeader] - {}", e.what());
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
	} else if (connectionState == CONNECTION_STATE_DISCONNECTED) {
		return;
	}

	//Check packet
	uint32_t recvPacket = msg.get<uint32_t>();
	if ((recvPacket & 1 << 31) != 0) {
		//SPDLOG_INFO("CCompress");
	}

	if (!receivedFirst) {
		// First message received
		receivedFirst = true;

		if (!protocol) {
			// As of 11.11+ update, we need to check if it's a outdated client or a status client server with this ugly check
			if (msg.getLength() < 280) {
				msg.skipBytes(-NetworkMessage::CHECKSUM_LENGTH); //those 32bits read up there
			}

			// Game protocol has already been created at this point
			protocol = service_port->make_protocol(true, msg, shared_from_this());
			if (!protocol) {
				close(FORCE_CLOSE);
				return;
			}
		} else {
			msg.skipBytes(1); // Skip protocol ID
		}

		protocol->onRecvFirstMessage(msg);
	} else {
		protocol->onRecvMessage(msg); // Send the packet to the current protocol
	}

	try {
		readTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()),
		                                    std::placeholders::_1));

		// Wait to the next packet
		boost::asio::async_read(socket,
		                        boost::asio::buffer(msg.getBuffer(), NetworkMessage::HEADER_LENGTH),
		                        std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
	} catch (boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::parsePacket] - {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::send(const OutputMessage_ptr& conMsg)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	if (connectionState == CONNECTION_STATE_DISCONNECTED) {
		return;
	}

	bool noPendingWrite = messageQueue.empty();
	messageQueue.emplace_back(conMsg);
	if (noPendingWrite) {
		internalSend(conMsg);
	}
}

void Connection::internalSend(const OutputMessage_ptr& conMsg)
{
	protocol->onSendMessage(conMsg);
	try {
		writeTimer.expires_from_now(boost::posix_time::seconds(CONNECTION_WRITE_TIMEOUT));
		writeTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()),
		                                     std::placeholders::_1));

		boost::asio::async_write(socket,
		                         boost::asio::buffer(conMsg->getOutputBuffer(), conMsg->getLength()),
		                         std::bind(&Connection::onWriteOperation, shared_from_this(), std::placeholders::_1));
	} catch (boost::system::system_error& e) {
		SPDLOG_ERROR("[Connection::internalSend] - {}", e.what());
		close(FORCE_CLOSE);
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

void Connection::onWriteOperation(const boost::system::error_code& error)
{
	std::lock_guard<std::recursive_mutex> lockClass(connectionLock);
	writeTimer.cancel();
	messageQueue.pop_front();

	if (error) {
		messageQueue.clear();
		close(FORCE_CLOSE);
		return;
	}

	if (!messageQueue.empty()) {
		internalSend(messageQueue.front());
	} else if (connectionState == CONNECTION_STATE_DISCONNECTED) {
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
