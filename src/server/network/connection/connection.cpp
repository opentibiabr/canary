/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/connection/connection.hpp"
#include "server/network/message/outputmessage.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "server/server.hpp"

Connection_ptr ConnectionManager::createConnection(asio::io_service &io_service, ConstServicePort_ptr servicePort) {
	auto connection = std::make_shared<Connection>(io_service, servicePort);
	connections.emplace(connection);
	return connection;
}

void ConnectionManager::releaseConnection(const Connection_ptr &connection) {
	connections.erase(connection);
}

void ConnectionManager::closeAll() {
	connections.for_each([](const Connection_ptr &connection) {
		try {
			std::error_code error;
			connection->socket.shutdown(asio::ip::tcp::socket::shutdown_both, error);
		} catch (const std::system_error &systemError) {
			g_logger().error("[ConnectionManager::closeAll] - Failed to close connection, system error code {}", systemError.what());
		}
	});

	connections.clear();
}

// Connection
// Constructor
Connection::Connection(asio::io_service &initIoService, ConstServicePort_ptr initservicePort) :
	readTimer(initIoService),
	writeTimer(initIoService),
	service_port(std::move(initservicePort)),
	socket(initIoService) {
	timeConnected = time(nullptr);
}
// Constructor end

void Connection::close(bool force) {
	// any thread
	ConnectionManager::getInstance().releaseConnection(shared_from_this());

	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);
	ip = 0;
	if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}
	connectionState = CONNECTION_STATE_CLOSED;

	if (protocol) {
		g_dispatcher().addEvent(std::bind_front(&Protocol::release, protocol), "Protocol::release", 1000);
	}

	if (messageQueue.empty() || force) {
		closeSocket();
	} else {
		// will be closed by the destructor or onWriteOperation
	}
}

void Connection::closeSocket() {
	if (socket.is_open()) {
		try {
			readTimer.cancel();
			writeTimer.cancel();
			std::error_code error;
			socket.shutdown(asio::ip::tcp::socket::shutdown_both, error);
			socket.close(error);
		} catch (const std::system_error &e) {
			g_logger().error("[Connection::closeSocket] - error: {}", e.what());
		}
	}
}

void Connection::accept(Protocol_ptr protocolPtr) {
	this->connectionState = CONNECTION_STATE_IDENTIFYING;
	this->protocol = protocolPtr;
	g_dispatcher().addEvent(std::bind_front(&Protocol::onConnect, protocolPtr), "Protocol::onConnect", 1000);

	// Call second accept for not duplicate code
	accept(false);
}

void Connection::accept(bool toggleParseHeader /* = true */) {
	try {
		readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		// If toggleParseHeader is true, execute the parseHeader, if not, execute parseProxyIdentification
		if (toggleParseHeader) {
			// Read size of the first packet
			asio::async_read(socket, asio::buffer(msg.getBuffer(), HEADER_LENGTH), std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
		} else {
			// Read header bytes to identify if it is proxy identification
			asio::async_read(socket, asio::buffer(msg.getBuffer(), HEADER_LENGTH), std::bind(&Connection::parseProxyIdentification, shared_from_this(), std::placeholders::_1));
		}
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::accept] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parseProxyIdentification(const std::error_code &error) {
	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);
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
			// Probably not proxy identification so let's try standard parsing method
			connectionState = CONNECTION_STATE_OPEN;
			parseHeader(error);
			return;
		} else {
			size_t remainder = serverName.length() - 2;
			if (remainder > 0) {
				connectionState = CONNECTION_STATE_READINGS;
				try {
					readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
					readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

					// Read the remainder of proxy identification
					asio::async_read(socket, asio::buffer(msg.getBuffer(), remainder), std::bind(&Connection::parseProxyIdentification, shared_from_this(), std::placeholders::_1));
				} catch (const std::system_error &e) {
					g_logger().error("Connection::parseProxyIdentification] - error: {}", e.what());
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
			g_logger().error("Connection::parseProxyIdentification] Invalid Client Login! Server Name mismatch!");
			close(FORCE_CLOSE);
			return;
		}
	}

	accept(true);
}

void Connection::parseHeader(const std::error_code &error) {
	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);
	readTimer.cancel();

	if (error) {
		close(FORCE_CLOSE);
		return;
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	uint32_t timePassed = std::max<uint32_t>(1, (time(nullptr) - timeConnected) + 1);
	if ((++packetsSent / timePassed) > static_cast<uint32_t>(g_configManager().getNumber(MAX_PACKETS_PER_SECOND))) {
		g_logger().warn("{} disconnected for exceeding packet per second limit.", convertIPToString(getIP()));
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
		readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		// Read packet content
		msg.setLength(size + HEADER_LENGTH);
		asio::async_read(socket, asio::buffer(msg.getBodyBuffer(), size), std::bind(&Connection::parsePacket, shared_from_this(), std::placeholders::_1));
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::parseHeader] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parsePacket(const std::error_code &error) {
	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);
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
			// Check packet checksum
			uint32_t checksum;
			if (int32_t len = msg.getLength() - msg.getBufferPosition() - CHECKSUM_LENGTH;
				len > 0) {
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
		readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		if (!skipReadingNextPacket) {
			// Wait to the next packet
			asio::async_read(socket, asio::buffer(msg.getBuffer(), HEADER_LENGTH), std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
		}
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::parsePacket] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::resumeWork() {
	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);

	try {
		// Wait to the next packet
		asio::async_read(socket, asio::buffer(msg.getBuffer(), HEADER_LENGTH), std::bind(&Connection::parseHeader, shared_from_this(), std::placeholders::_1));
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::resumeWork] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::send(const OutputMessage_ptr &outputMessage) {
	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);
	if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	bool noPendingWrite = messageQueue.empty();
	messageQueue.emplace_back(outputMessage);
	if (noPendingWrite) {
		// Make asio thread handle xtea encryption instead of dispatcher
		try {
			asio::post(socket.get_executor(), std::bind(&Connection::internalWorker, shared_from_this()));
		} catch (const std::system_error &e) {
			g_logger().error("[Connection::send] - error: {}", e.what());
			messageQueue.clear();
			close(FORCE_CLOSE);
		}
	}
}

void Connection::internalWorker() {
	std::unique_lock<std::recursive_mutex> lockClass(connectionLock);
	if (!messageQueue.empty()) {
		const OutputMessage_ptr &outputMessage = messageQueue.front();
		lockClass.unlock();
		protocol->onSendMessage(outputMessage);
		lockClass.lock();
		internalSend(outputMessage);
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

uint32_t Connection::getIP() {
	if (ip != 1) {
		return ip;
	}

	std::scoped_lock<std::recursive_mutex> lockClass(connectionLock);

	// IP-address is expressed in network byte order
	std::error_code error;
	const asio::ip::tcp::endpoint endpoint = socket.remote_endpoint(error);
	ip = error ? 0 : htonl(endpoint.address().to_v4().to_uint());
	return ip;
}

void Connection::internalSend(const OutputMessage_ptr &outputMessage) {
	try {
		writeTimer.expires_from_now(std::chrono::seconds(CONNECTION_WRITE_TIMEOUT));
		writeTimer.async_wait(std::bind(&Connection::handleTimeout, std::weak_ptr<Connection>(shared_from_this()), std::placeholders::_1));

		asio::async_write(socket, asio::buffer(outputMessage->getOutputBuffer(), outputMessage->getLength()), std::bind(&Connection::onWriteOperation, shared_from_this(), std::placeholders::_1));
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::internalSend] - error: {}", e.what());
	}
}

void Connection::onWriteOperation(const std::error_code &error) {
	std::unique_lock<std::recursive_mutex> lockClass(connectionLock);
	writeTimer.cancel();
	messageQueue.pop_front();

	if (error) {
		messageQueue.clear();
		close(FORCE_CLOSE);
		return;
	}

	if (!messageQueue.empty()) {
		const OutputMessage_ptr &outputMessage = messageQueue.front();
		lockClass.unlock();
		protocol->onSendMessage(outputMessage);
		lockClass.lock();
		internalSend(outputMessage);
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

void Connection::handleTimeout(ConnectionWeak_ptr connectionWeak, const std::error_code &error) {
	if (error == asio::error::operation_aborted) {
		// The timer has been manually cancelled
		return;
	}

	if (auto connection = connectionWeak.lock()) {
		connection->close(FORCE_CLOSE);
	}
}
