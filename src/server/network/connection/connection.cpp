/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/connection/connection.hpp"

#include "config/configmanager.hpp"
#include "lib/di/container.hpp"
#include "server/network/message/outputmessage.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "server/network/message/networkmessage.hpp"
#include "server/server.hpp"
#include "utils/tools.hpp"

ConnectionManager &ConnectionManager::getInstance() {
	return inject<ConnectionManager>();
}

Connection_ptr ConnectionManager::createConnection(asio::io_service &io_service, const ConstServicePort_ptr &servicePort) {
	auto connection = std::make_shared<Connection>(io_service, servicePort);
	connections.emplace(connection);
	return connection;
}

void ConnectionManager::releaseConnection(const Connection_ptr &connection) {
	connections.erase(connection);
}

void ConnectionManager::closeAll() {
	connections.for_each([&](const Connection_ptr &connection) {
		if (connection && connection->socket.is_open()) {
			try {
				std::error_code error;
				connection->socket.shutdown(asio::ip::tcp::socket::shutdown_both, error);
				if (error && error != asio::error::not_connected) {
					g_logger().error("[ConnectionManager::closeAll] - Failed to shutdown connection: {}", error.message());
				}

				connection->socket.close(error);
				if (error && error != asio::error::not_connected) {
					g_logger().error("[ConnectionManager::closeAll] - Failed to close connection: {}", error.message());
				}
			} catch (const std::system_error &systemError) {
				g_logger().error("[ConnectionManager::closeAll] - Exception caught: {}", systemError.what());
			} catch (const std::exception &e) {
				g_logger().error("[ConnectionManager::closeAll] - Unexpected exception caught: {}", e.what());
			} catch (...) {
				g_logger().error("[ConnectionManager::closeAll] - Unknown error occurred while closing connection");
			}
		}
	});

	connections.clear();
}

Connection::Connection(asio::io_context &initIoService, ConstServicePort_ptr initservicePort) :
	readTimer(initIoService),
	writeTimer(initIoService),
	service_port(std::move(initservicePort)),
	socket(initIoService), m_msg() {
}

void Connection::close(const bool force) {
	const auto self = shared_from_this();
	ConnectionManager::getInstance().releaseConnection(self);
	ip = 0;

	if (connectionState.exchange(CONNECTION_STATE_CLOSED) == CONNECTION_STATE_CLOSED) {
		return;
	}

	if (protocol) {
		auto weakProtocol = std::weak_ptr(protocol);
		g_dispatcher().addEvent([weakProtocol] {
			if (const auto protocol = weakProtocol.lock()) {
				protocol->release();
			}
		},
		                        __FUNCTION__, std::chrono::milliseconds(CONNECTION_WRITE_TIMEOUT * 1000).count());
	}

	if (messageQueue.was_empty() || force) {
		closeSocket();
	}
}

void Connection::closeSocket() {
	if (!socket.is_open()) {
		return;
	}

	try {
		std::error_code timerError;
		readTimer.cancel(timerError);
		if (timerError && timerError != asio::error::operation_aborted) {
			g_logger().warn("[Connection::closeSocket] - Failed to cancel read timer: {}", timerError.message());
		}

		writeTimer.cancel(timerError);
		if (timerError && timerError != asio::error::operation_aborted) {
			g_logger().warn("[Connection::closeSocket] - Failed to cancel write timer: {}", timerError.message());
		}

		socket.cancel(timerError);
		if (timerError && timerError != asio::error::operation_aborted) {
			g_logger().warn("[Connection::closeSocket] - Failed to cancel socket operations: {}", timerError.message());
		}

		std::error_code error;
		socket.shutdown(asio::ip::tcp::socket::shutdown_both, error);
		if (error && error != asio::error::not_connected) {
			g_logger().error("[Connection::closeSocket] - Failed to shutdown socket: {}", error.message());
		}

		socket.close(error);
		if (error && error != asio::error::not_connected) {
			g_logger().error("[Connection::closeSocket] - Failed to close socket: {}", error.message());
		}
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::closeSocket] - System error during socket close: {}", e.what());
	} catch (const std::exception &e) {
		g_logger().error("[Connection::closeSocket] - Unexpected error during socket close: {}", e.what());
	} catch (...) {
		g_logger().error("[Connection::closeSocket] - Unknown error occurred during socket close");
	}
}

void Connection::accept(Protocol_ptr protocolPtr) {
	connectionState.store(CONNECTION_STATE_IDENTIFYING);

	protocol = std::move(protocolPtr);
	auto weakProtocol = std::weak_ptr(protocol);

	g_dispatcher().addEvent([weakProtocol] {
		if (const auto protocol = weakProtocol.lock()) {
			protocol->onConnect();
		}
	},
	                        __FUNCTION__, std::chrono::milliseconds(CONNECTION_WRITE_TIMEOUT * 1000).count());

	acceptInternal(false);
}

void Connection::acceptInternal(bool toggleParseHeader) {
	readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));

	auto weakSelf = std::weak_ptr(shared_from_this());

	readTimer.async_wait([weakSelf](const std::error_code &error) {
		if (const auto self = weakSelf.lock()) {
			handleTimeout(self, error);
		}
	});

	executeWithCatch([&]() {
		async_read(socket, asio::buffer(m_msg.getBuffer(), HEADER_LENGTH), [weakSelf, toggleParseHeader](const std::error_code &error, std::size_t) {
			if (const auto self = weakSelf.lock()) {
				if (toggleParseHeader) {
					self->parseHeader(error);
				} else {
					self->parseProxyIdentification(error);
				}
			} else {
				g_logger().warn("[Connection::acceptInternal] - Connection no longer exists during async_read");
			}
		});
	},
	                 "Connection::acceptInternal");
}

void Connection::parseProxyIdentification(const std::error_code &error) {
	std::error_code timerError;
	readTimer.cancel(timerError);
	if (timerError && timerError != asio::error::operation_aborted) {
		g_logger().warn("[Connection::parseProxyIdentification] - Failed to cancel read timer: {}", timerError.message());
	}

	if (error || connectionState.load() == CONNECTION_STATE_CLOSED) {
		if (error != asio::error::operation_aborted && error != asio::error::eof && error != asio::error::connection_reset) {
			g_logger().error("[Connection::parseProxyIdentification] - Read error: {}", error.message());
		}
		close(true);
		return;
	}

	uint8_t* msgBuffer = m_msg.getBuffer();
	const auto charData = static_cast<char*>(static_cast<void*>(msgBuffer));
	const std::string serverName = g_configManager().getString(SERVER_NAME) + "\n";

	if (connectionState.load() == CONNECTION_STATE_IDENTIFYING) {
		if (msgBuffer[1] == 0x00 || strncasecmp(charData, serverName.c_str(), 2) != 0) {
			connectionState.store(CONNECTION_STATE_OPEN);
			parseHeader(error);
			return;
		} else {
			const size_t remainder = serverName.length() - 2;
			if (remainder > 0) {
				connectionState.store(CONNECTION_STATE_READINGS);
				executeWithCatch([&]() {
					readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
					auto weakSelf = std::weak_ptr<Connection>(shared_from_this());

					readTimer.async_wait([weakSelf](const std::error_code &error) {
						if (const auto self = weakSelf.lock()) {
							handleTimeout(self, error);
						}
					});

					async_read(socket, asio::buffer(m_msg.getBuffer(), remainder), [weakSelf](const std::error_code &error, std::size_t) {
						if (const auto self = weakSelf.lock()) {
							self->parseProxyIdentification(error);
						} else {
							g_logger().warn("[Connection::parseProxyIdentification] - Connection no longer exists during async_read");
						}
					});
				},
				                 "Connection::parseProxyIdentification");
				return;
			} else {
				connectionState.store(CONNECTION_STATE_OPEN);
			}
		}
	} else if (connectionState.load() == CONNECTION_STATE_READINGS) {
		size_t remainder = serverName.length() - 2;
		if (strncasecmp(charData, &serverName[2], remainder) == 0) {
			connectionState.store(CONNECTION_STATE_OPEN);
		} else {
			g_logger().error("[Connection::parseProxyIdentification] - Invalid Client Login! Server Name mismatch!");
			close(true);
			return;
		}
	}

	acceptInternal(true);
}

void Connection::parseHeader(const std::error_code &error) {
	std::error_code timerError;
	readTimer.cancel(timerError);
	if (timerError && timerError != asio::error::operation_aborted) {
		g_logger().warn("[Connection::parseHeader] - Failed to cancel read timer: {}", timerError.message());
	}

	if (error) {
		if (error != asio::error::operation_aborted && error != asio::error::eof && error != asio::error::connection_reset) {
			g_logger().debug("[Connection::parseHeader] - Read error: {}", error.message());
		}
		close(true);
		return;
	} else if (connectionState.load() == CONNECTION_STATE_CLOSED) {
		return;
	}

	const uint32_t timePassed = std::max<uint32_t>(1, (time(nullptr) - timeConnected) + 1);
	if ((++packetsSent / timePassed) > static_cast<uint32_t>(g_configManager().getNumber(MAX_PACKETS_PER_SECOND))) {
		g_logger().warn("[Connection::parseHeader] - {} disconnected for exceeding packet per second limit.", convertIPToString(getIP()));
		close();
		return;
	}

	if (timePassed > 2) {
		timeConnected = time(nullptr);
		packetsSent = 0;
	}

	const uint16_t size = m_msg.getLengthHeader();
	if (size == 0 || size > INPUTMESSAGE_MAXSIZE) {
		close(true);
		return;
	}

	executeWithCatch([&]() {
		readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		auto weakSelf = std::weak_ptr<Connection>(shared_from_this());

		readTimer.async_wait([weakSelf](const std::error_code &error) {
			if (const auto self = weakSelf.lock()) {
				handleTimeout(self, error);
			}
		});

		m_msg.setLength(size + HEADER_LENGTH);

		async_read(socket, asio::buffer(m_msg.getBodyBuffer(), size), [weakSelf](const std::error_code &error, std::size_t) {
			if (const auto self = weakSelf.lock()) {
				self->parsePacket(error);
			} else {
				g_logger().warn("[Connection::parseHeader] - Connection no longer exists during async_read");
			}
		});
	},
	                 "Connection::parseHeader");
}

void Connection::parsePacket(const std::error_code &error) {
	std::error_code timerError;
	readTimer.cancel(timerError);
	if (timerError && timerError != asio::error::operation_aborted) {
		g_logger().warn("[Connection::parsePacket] - Failed to cancel read timer: {}", timerError.message());
	}

	if (error || connectionState.load() == CONNECTION_STATE_CLOSED) {
		if (error) {
			g_logger().error("[Connection::parsePacket] - Read error: {}", error.message());
		}
		close(true);
		return;
	}

	bool skipReadingNextPacket = false;
	if (!receivedFirst) {
		receivedFirst = true;

		if (!protocol) {
			uint32_t checksum;
			if (const int32_t len = m_msg.getLength() - m_msg.getBufferPosition() - CHECKSUM_LENGTH; len > 0) {
				checksum = adlerChecksum(m_msg.getBuffer() + m_msg.getBufferPosition() + CHECKSUM_LENGTH, len);
			} else {
				checksum = 0;
			}

			const uint32_t recvChecksum = m_msg.get<uint32_t>();
			if (recvChecksum != checksum) {
				m_msg.skipBytes(-CHECKSUM_LENGTH);
			}

			protocol = service_port->make_protocol(recvChecksum == checksum, m_msg, shared_from_this());
			if (!protocol) {
				close(true);
				return;
			}
		} else {
			m_msg.get<uint32_t>();
			m_msg.skipBytes(1);
		}

		protocol->onRecvFirstMessage(m_msg);
	} else {
		skipReadingNextPacket = protocol->onRecvMessage(m_msg);
	}

	executeWithCatch([&]() {
		readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		auto weakSelf = std::weak_ptr<Connection>(shared_from_this());

		readTimer.async_wait([weakSelf](const std::error_code &error) {
			if (const auto self = weakSelf.lock()) {
				handleTimeout(self, error);
			}
		});

		if (!skipReadingNextPacket) {
			async_read(socket, asio::buffer(m_msg.getBuffer(), HEADER_LENGTH), [weakSelf](const std::error_code &error, std::size_t) {
				if (const auto self = weakSelf.lock()) {
					self->parseHeader(error);
				} else {
					g_logger().warn("[Connection::parsePacket] - Connection no longer exists during async_read");
				}
			});
		}
	},
	                 "Connection::parsePacket");
}

void Connection::resumeWork() {
	executeWithCatch([&]() {
		readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		auto weakSelf = std::weak_ptr<Connection>(shared_from_this());

		readTimer.async_wait([weakSelf](const std::error_code &error) {
			if (const auto self = weakSelf.lock()) {
				handleTimeout(self, error);
			}
		});
		async_read(socket, asio::buffer(m_msg.getBuffer(), HEADER_LENGTH), [weakSelf](const std::error_code &error, std::size_t bytesTransferred) {
			if (const auto self = weakSelf.lock()) {
				self->parseHeader(error);
			} else {
				g_logger().warn("[Connection::resumeWork] - Connection no longer exists during async_read");
			}
		});
	},
	                 "Connection::resumeWork");
}

void Connection::send(const OutputMessage_ptr &outputMessage) {
	if (connectionState.load() == CONNECTION_STATE_CLOSED) {
		return;
	}

	if (messageQueue.try_push(outputMessage)) {
		if (socket.is_open()) {
			auto weakSelf = std::weak_ptr(shared_from_this());

			executeWithCatch([&]() {
				post(socket.get_executor(), [weakSelf] {
					if (const auto self = weakSelf.lock()) {
						self->internalWorker();
					} else {
						g_logger().warn("[Connection::send] - Connection no longer exists during posting write operation");
					}
				});
			},
			                 "Connection::send");
		} else {
			g_logger().error("[Connection::send] - Socket is not open for writing.");
			close(true);
		}
	} else {
		g_logger().warn("[Connection::send] - Message queue is full. Discarding message.");
	}
}

void Connection::internalWorker() {
	OutputMessage_ptr outputMessage;

	if (messageQueue.try_pop(outputMessage)) {
		if (protocol) {
			protocol->onSendMessage(outputMessage);
			internalSend(outputMessage);
		} else {
			g_logger().error("[Connection::internalWorker] - Protocol is null. Unable to send message.");
		}
	} else if (connectionState.load() == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

uint32_t Connection::getIP() {
	if (ip.load() == 1) {
		std::error_code error;
		const asio::ip::tcp::endpoint endpoint = socket.remote_endpoint(error);
		if (error) {
			g_logger().error("[Connection::getIP] - Failed to get remote endpoint: {}", error.message());
			ip.store(0);
		} else {
			try {
				if (endpoint.address().is_v4()) {
					ip.store(htonl(endpoint.address().to_v4().to_uint()));
				} else {
					g_logger().error("[Connection::getIP] - Remote endpoint is not an IPv4 address");
					ip.store(0);
				}
			} catch (const std::exception &e) {
				g_logger().error("[Connection::getIP] - Exception caught while getting IP: {}", e.what());
				ip.store(0);
			} catch (...) {
				g_logger().error("[Connection::getIP] - Unknown error occurred while getting IP");
				ip.store(0);
			}
		}
	}
	return ip.load();
}

void Connection::internalSend(const OutputMessage_ptr &outputMessage) {
	writeTimer.expires_after(std::chrono::seconds(CONNECTION_WRITE_TIMEOUT));
	auto weakSelf = std::weak_ptr(shared_from_this());

	writeTimer.async_wait([weakSelf](const std::error_code &error) {
		if (const auto self = weakSelf.lock()) {
			handleTimeout(self, error);
		}
	});

	executeWithCatch([&]() {
		async_write(socket, asio::buffer(outputMessage->getOutputBuffer(), outputMessage->getLength()), [weakSelf](const std::error_code &error, std::size_t bytesTransferred) {
			if (const auto self = weakSelf.lock()) {
				self->onWriteOperation(error);
			} else {
				g_logger().warn("[Connection::internalSend] - Connection no longer exists during async_write");
			}
		});
	},
	                 "Connection::internalSend");
}

void Connection::onWriteOperation(const std::error_code &error) {
	std::error_code timerError;
	writeTimer.cancel(timerError);
	if (timerError && timerError != asio::error::operation_aborted) {
		g_logger().warn("[Connection::onWriteOperation] - Failed to cancel write timer: {}", timerError.message());
	}

	if (error) {
		g_logger().error("[Connection::onWriteOperation] - Write error: {}", error.message());
		OutputMessage_ptr outputMessage;
		while (messageQueue.try_pop(outputMessage)) {
			// Aqui, estamos apenas removendo todos os elementos da fila.
		}
		close(true);
		return;
	}

	OutputMessage_ptr outputMessage;
	if (messageQueue.try_pop(outputMessage)) {
		if (protocol) {
			protocol->onSendMessage(outputMessage);
			internalSend(outputMessage);
		} else {
			g_logger().error("[Connection::onWriteOperation] - Protocol is null. Unable to send message.");
			close(true);
		}
	} else if (connectionState.load() == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

void Connection::handleTimeout(const ConnectionWeak_ptr &connectionWeak, const std::error_code &error) {
	if (error == asio::error::operation_aborted) {
		return;
	}

	if (const auto connection = connectionWeak.lock()) {
		if (!error) {
			g_logger().debug("[Connection::handleTimeout] - Connection Timeout, IP: {}", convertIPToString(connection->getIP()));
		} else {
			g_logger().debug("[Connection::handleTimeout] - Timeout or error: {}, IP: {}", error.message(), convertIPToString(connection->getIP()));
		}

		connection->close(true);
	} else {
		g_logger().warn("[Connection::handleTimeout] - Connection no longer exists when handling timeout");
	}
}
