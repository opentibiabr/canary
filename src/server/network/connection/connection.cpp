/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
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
#include "server/network/protocol/transport_codec.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "server/network/message/networkmessage.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "server/server.hpp"
#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <atomic>
	#include <limits>
	#include <magic_enum/magic_enum.hpp>
	#include <optional>
	#include <utility>
#endif

namespace {
	constexpr auto PROTOCOL_RELEASE_RETRY_DELAY = std::chrono::milliseconds(50);
	constexpr auto PROTOCOL_RELEASE_WARNING_INTERVAL = std::chrono::seconds(5);
	constexpr auto WRITE_ERROR_WARNING_INTERVAL = std::chrono::seconds(5);
	std::atomic<uint64_t> nextConnectionId { 1 };

	std::optional<uint64_t> takeWriteErrorWarning() {
		static std::mutex warningLock;
		static auto nextWarningAt = std::chrono::steady_clock::time_point {};
		static uint64_t suppressed = 0;

		std::scoped_lock lock(warningLock);
		const auto now = std::chrono::steady_clock::now();
		if (now < nextWarningAt) {
			if (suppressed < std::numeric_limits<uint64_t>::max()) {
				++suppressed;
			}
			return std::nullopt;
		}
		nextWarningAt = now + WRITE_ERROR_WARNING_INTERVAL;
		return std::exchange(suppressed, 0);
	}

	bool shouldLogProtocolReleaseRetry() {
		static std::mutex warningLock;
		static auto nextWarningAt = std::chrono::steady_clock::time_point {};

		std::scoped_lock lock(warningLock);
		const auto now = std::chrono::steady_clock::now();
		if (now < nextWarningAt) {
			return false;
		}
		nextWarningAt = now + PROTOCOL_RELEASE_WARNING_INTERVAL;
		return true;
	}
}

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
		if (connection->socket.is_open()) {
			try {
				std::error_code error;
				connection->socket.shutdown(asio::ip::tcp::socket::shutdown_both, error);
				if (error) {
					g_logger().error("[ConnectionManager::closeAll] - Failed to close connection, system error code {}", error.message());
				}
			} catch (const std::system_error &systemError) {
				g_logger().error("[ConnectionManager::closeAll] - Exception caught: {}", systemError.what());
			}
		}
	});

	connections.clear();
}

Connection::Connection(asio::io_service &initIoService, ConstServicePort_ptr initservicePort) :
	readTimer(initIoService),
	writeTimer(initIoService),
	protocolReleaseRetryTimer(initIoService),
	service_port(std::move(initservicePort)),
	transportCodec(&TransportCodecs::rawClientFirst()),
	socket(initIoService), m_msg(),
	connectionId(nextConnectionId.fetch_add(1, std::memory_order_relaxed)) {
}

void Connection::close(bool force, const std::source_location &source) {
	ConnectionManager::getInstance().releaseConnection(shared_from_this());

	std::scoped_lock lock(connectionLock);
	ip = 0;

	if (connectionState == CONNECTION_STATE_CLOSED) {
		if (force && socket.is_open()) {
			closeSource = source;
			forcedClose = true;
			closeSocket();
		}
		return;
	}
	connectionState = CONNECTION_STATE_CLOSED;
	closeSource = source;
	forcedClose = force;

	if (protocol) {
		dispatchProtocolRelease();
	}

	if (messageQueue.empty() || force) {
		closeSocket();
	}
}

void Connection::dispatchProtocolRelease() {
	std::scoped_lock lock(connectionLock);
	if (!protocol) {
		return;
	}

	std::function<void()> releaseTask = [protocolToRelease = protocol] {
		protocolToRelease->release();
	};
	const auto producerToken = reinterpret_cast<uintptr_t>(protocol.get());
	const bool accepted = DispatcherPolicy::scheduleWithFallbackLane(
		[&releaseTask, producerToken](DispatcherLane lane) {
			return g_dispatcher().addEvent(std::move(releaseTask), "Connection::dispatchProtocolRelease", 0, lane, producerToken);
		},
		DispatcherLane::ProtocolInput,
		DispatcherLane::WorldCommit
	);
	const auto admissionResult = DispatcherPolicy::classifyAdmission(accepted, g_dispatcher().isShuttingDown());
	if (admissionResult != DispatcherAdmissionResult::Saturated) {
		protocolReleaseRetryAttempts = 0;
		return;
	}

	++protocolReleaseRetryAttempts;
	if (shouldLogProtocolReleaseRetry()) {
		g_logger().warn(
			"[Connection::dispatchProtocolRelease] Dispatcher saturated; retrying protocol cleanup (attempt {}).",
			protocolReleaseRetryAttempts
		);
	}

	protocolReleaseRetryTimer.expires_from_now(PROTOCOL_RELEASE_RETRY_DELAY);
	protocolReleaseRetryTimer.async_wait([self = shared_from_this()](const std::error_code &error) {
		if (error != asio::error::operation_aborted) {
			self->dispatchProtocolRelease();
		}
	});
}

void Connection::closeSocket() {
	if (!socket.is_open()) {
		return;
	}

	try {
		readTimer.cancel();
		writeTimer.cancel();
		socket.cancel();

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
		g_logger().error("[Connection::closeSocket] - error closeSocket: {}", e.what());
	}
}

void Connection::accept(Protocol_ptr protocolPtr) {
	connectionState = CONNECTION_STATE_IDENTIFYING;
	protocol = std::move(protocolPtr);
	protocol->onConnectionAccepted();

	if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	acceptInternal(false);
}

void Connection::acceptInternal(bool toggleParseHeader) {
	readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
	readTimer.async_wait([self = std::weak_ptr<Connection>(shared_from_this())](const std::error_code &error) { Connection::handleTimeout(self, error); });

	try {
		asio::async_read(socket, asio::buffer(m_msg.getBuffer(), HEADER_LENGTH), [self = shared_from_this(), toggleParseHeader](const std::error_code &error, std::size_t N) {
			if (toggleParseHeader) {
				self->parseHeader(error);
			} else {
				self->parseProxyIdentification(error);
			}
		});
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::acceptInternal] - Exception in async_read: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parseProxyIdentification(const std::error_code &error) {
	std::scoped_lock lock(connectionLock);
	readTimer.cancel();

	if (error || connectionState == CONNECTION_STATE_CLOSED) {
		if (error && !firstReadError) {
			firstReadError = error;
		}
		if (error != asio::error::operation_aborted && error != asio::error::eof && error != asio::error::connection_reset) {
			g_logger().debug("[Connection::parseProxyIdentification] - Read error: {}", error.message());
		}
		close(FORCE_CLOSE);
		return;
	}

	uint8_t* msgBuffer = m_msg.getBuffer();
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
					readTimer.async_wait([self = std::weak_ptr<Connection>(shared_from_this())](const std::error_code &error) { Connection::handleTimeout(self, error); });

					// Read the remainder of proxy identification
					asio::async_read(socket, asio::buffer(m_msg.getBuffer(), remainder), [self = shared_from_this()](const std::error_code &error, std::size_t N) { self->parseProxyIdentification(error); });
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

	acceptInternal(true);
}

void Connection::parseHeader(const std::error_code &error) {
	std::scoped_lock lock(connectionLock);
	readTimer.cancel();

	if (error) {
		if (!firstReadError) {
			firstReadError = error;
		}
		if (error != asio::error::operation_aborted && error != asio::error::eof && error != asio::error::connection_reset) {
			g_logger().debug("[Connection::parseHeader] - Read error: {}", error.message());
		}
		close(FORCE_CLOSE);
		return;
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	uint32_t timePassed = std::max<uint32_t>(1, (time(nullptr) - timeConnected) + 1);
	if ((++packetsSent / timePassed) > static_cast<uint32_t>(g_configManager().getNumber(MAX_PACKETS_PER_SECOND))) {
		g_logger().warn("[Connection::parseHeader] - {} disconnected for exceeding packet per second limit.", convertIPToString(getIP()));
		close();
		return;
	}

	if (timePassed > 2) {
		timeConnected = time(nullptr);
		packetsSent = 0;
	}

	const auto size = getTransportCodec().decodeBodySize(m_msg.getLengthHeader());

	if (!size || *size > INPUTMESSAGE_MAXSIZE) {
		close(FORCE_CLOSE);
		return;
	}

	try {
		readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait([self = std::weak_ptr<Connection>(shared_from_this())](const std::error_code &error) { Connection::handleTimeout(self, error); });

		// Read packet content
		m_msg.setLength(*size + HEADER_LENGTH);
		// Read the remainder of proxy identification
		asio::async_read(socket, asio::buffer(m_msg.getBodyBuffer(), *size), [self = shared_from_this()](const std::error_code &error, std::size_t N) { self->parsePacket(error); });
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::parseHeader] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parsePacket(const std::error_code &error) {
	std::scoped_lock lock(connectionLock);
	readTimer.cancel();

	if (error || connectionState == CONNECTION_STATE_CLOSED) {
		if (error) {
			if (!firstReadError) {
				firstReadError = error;
			}
			g_logger().debug("[Connection::parsePacket] - Read error: {}", error.message());
		}
		close(FORCE_CLOSE);
		return;
	}

	bool skipReadingNextPacket = false;
	if (!receivedFirst) {
		// First message received
		receivedFirst = true;

		if (!protocol) {
			// Check packet checksum
			uint32_t checksum;
			if (int32_t len = m_msg.getLength() - m_msg.getBufferPosition() - CHECKSUM_LENGTH;
			    len > 0) {
				checksum = adlerChecksum(m_msg.getBuffer() + m_msg.getBufferPosition() + CHECKSUM_LENGTH, len);
			} else {
				checksum = 0;
			}

			uint32_t recvChecksum = m_msg.get<uint32_t>();
			if (recvChecksum != checksum) {
				// it might not have been the checksum, step back
				m_msg.skipBytes(-CHECKSUM_LENGTH);
			}

			// Game protocol has already been created at this point
			protocol = service_port->make_protocol(recvChecksum == checksum, m_msg, shared_from_this());
			if (!protocol) {
				close(FORCE_CLOSE);
				return;
			}
		} else {
			m_msg.skipBytes(getTransportCodec().getProfile().serverFirstPacketHeaderBytes);
		}

		protocol->onRecvFirstMessage(m_msg);
	} else {
		// Send the packet to the current protocol
		skipReadingNextPacket = protocol->onRecvMessage(m_msg);
	}

	try {
		readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait([self = std::weak_ptr<Connection>(shared_from_this())](const std::error_code &error) { Connection::handleTimeout(self, error); });

		if (!skipReadingNextPacket) {
			// Wait to the next packet
			asio::async_read(socket, asio::buffer(m_msg.getBuffer(), HEADER_LENGTH), [self = shared_from_this()](const std::error_code &error, std::size_t N) { self->parseHeader(error); });
		}
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::parsePacket] - error: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::resumeWork() {
	readTimer.expires_from_now(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
	readTimer.async_wait([self = std::weak_ptr<Connection>(shared_from_this())](const std::error_code &error) { Connection::handleTimeout(self, error); });

	try {
		asio::async_read(socket, asio::buffer(m_msg.getBuffer(), HEADER_LENGTH), [self = shared_from_this()](const std::error_code &error, std::size_t N) { self->parseHeader(error); });
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::resumeWork] - Exception in async_read: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::send(const OutputMessage_ptr &outputMessage) {
	std::scoped_lock lock(connectionLock);
	if (connectionState == CONNECTION_STATE_CLOSED) {
		return;
	}

	bool noPendingWrite = messageQueue.empty();
	messageQueue.emplace_back(outputMessage);

	if (noPendingWrite) {
		if (socket.is_open()) {
			try {
				asio::post(socket.get_executor(), [self = shared_from_this()] { self->internalWorker(); });
			} catch (const std::system_error &e) {
				g_logger().error("[Connection::send] - Exception in posting write operation: {}", e.what());
				close(FORCE_CLOSE);
			}
		} else {
			g_logger().error("[Connection::send] - Socket is not open for writing.");
			close(FORCE_CLOSE);
		}
	}
}

void Connection::internalWorker() {
	std::unique_lock lock(connectionLock);
	if (!socket.is_open()) {
		messageQueue.clear();
		return;
	}

	if (messageQueue.empty()) {
		if (connectionState == CONNECTION_STATE_CLOSED) {
			closeSocket();
		}
		return;
	}

	const auto outputMessage = messageQueue.front();
	lock.unlock();
	protocol->onSendMessage(outputMessage);
	lock.lock();

	internalSend(outputMessage);
}

uint32_t Connection::getIP() {
	std::scoped_lock lock(connectionLock);

	if (ip == 1) {
		std::error_code error;
		asio::ip::tcp::endpoint endpoint = socket.remote_endpoint(error);
		if (error) {
			g_logger().error("[Connection::getIP] - Failed to get remote endpoint: {}", error.message());
			ip = 0;
		} else {
			ip = htonl(endpoint.address().to_v4().to_uint());
			acceptedAt = std::chrono::steady_clock::now();
			remoteAddress = endpoint.address().to_string(error);
			remotePort = endpoint.port();
			const auto localEndpoint = socket.local_endpoint(error);
			if (!error) {
				localPort = localEndpoint.port();
			}
		}
	}
	return ip;
}

void Connection::setTransportCodec(const TransportCodec &codec, InitialTransportState state) {
	std::scoped_lock lock(connectionLock);
	transportCodec = &codec;
	initialTransportState = state;
}

void Connection::setInitialTransportState(InitialTransportState state) {
	std::scoped_lock lock(connectionLock);
	initialTransportState = state;
}

const TransportCodec &Connection::getTransportCodec() const {
	return transportCodec ? *transportCodec : TransportCodecs::rawClientFirst();
}

InitialTransportState Connection::getInitialTransportState() const {
	return initialTransportState;
}

void Connection::internalSend(const OutputMessage_ptr &outputMessage) {
	// A forced close can occur while protocol preparation releases the connection lock.
	if (!socket.is_open()) {
		messageQueue.clear();
		return;
	}

	writeTimer.expires_from_now(std::chrono::seconds(CONNECTION_WRITE_TIMEOUT));
	writeTimer.async_wait([self = std::weak_ptr<Connection>(shared_from_this())](const std::error_code &error) { Connection::handleTimeout(self, error); });

	try {
		const auto requestedBytes = outputMessage->getLength();
		const auto socketOpenAtStart = socket.is_open();
		asio::async_write(socket, asio::buffer(outputMessage->getOutputBuffer(), requestedBytes), [self = shared_from_this(), requestedBytes, socketOpenAtStart](const std::error_code &error, size_t bytesTransferred) {
			self->onWriteOperation(error, bytesTransferred, requestedBytes, socketOpenAtStart);
		});
	} catch (const std::system_error &e) {
		g_logger().error("[Connection::internalSend] - Exception in async_write: {}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::logWriteError(const std::error_code &error, size_t bytesTransferred, size_t requestedBytes, bool socketOpenAtStart) {
	const auto warning = error == asio::error::operation_aborted ? std::nullopt : takeWriteErrorWarning();
#ifndef DEBUG_LOG
	if (!warning) {
		return;
	}
#endif
	const auto ageMs = acceptedAt == std::chrono::steady_clock::time_point {} ? -1 : std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now() - acceptedAt).count();
	const auto message = fmt::format(
		"[Connection::onWriteOperation] - Write error: {} (code={}, category={}); connection_id={}, remote={}:{}, local_port={}, age_ms={}, "
		"state={}, received_first={}, socket_open_at_write={}, socket_open_now={}, bytes_written={}/{}, queued_messages={}, "
		"close_requested_by={}, close_line={}, forced_close={}, first_read_error={}:{}",
		error.message(), error.value(), error.category().name(), connectionId, remoteAddress, remotePort, localPort, ageMs,
		magic_enum::enum_name(static_cast<ConnectionState_t>(connectionState)), receivedFirst, socketOpenAtStart, socket.is_open(), bytesTransferred, requestedBytes, messageQueue.size(),
		closeSource.line() ? closeSource.function_name() : "none", closeSource.line(), forcedClose, firstReadError.category().name(), firstReadError.value()
	);
	if (warning) {
		g_logger().warn("{}; suppressed_since_last_warning={}", message, *warning);
	} else {
		g_logger().debug(message);
	}
}

void Connection::onWriteOperation(const std::error_code &error, size_t bytesTransferred, size_t requestedBytes, bool socketOpenAtStart) {
	std::unique_lock lock(connectionLock);
	writeTimer.cancel();

	if (error) {
		logWriteError(error, bytesTransferred, requestedBytes, socketOpenAtStart);
		messageQueue.clear();
		close(FORCE_CLOSE);
		return;
	}

	if (!socket.is_open()) {
		messageQueue.clear();
		return;
	}

	messageQueue.pop_front();

	if (!messageQueue.empty()) {
		const auto outputMessage = messageQueue.front();
		lock.unlock();
		protocol->onSendMessage(outputMessage);
		lock.lock();
		internalSend(outputMessage);
	} else if (connectionState == CONNECTION_STATE_CLOSED) {
		closeSocket();
	}
}

void Connection::handleTimeout(ConnectionWeak_ptr connectionWeak, const std::error_code &error) {
	if (error == asio::error::operation_aborted) {
		return;
	}

	if (auto connection = connectionWeak.lock()) {
		if (!error) {
			g_logger().debug("Connection Timeout, IP: {}", convertIPToString(connection->getIP()));
		} else {
			g_logger().debug("Connection Timeout or error: {}, IP: {}", error.message(), convertIPToString(connection->getIP()));
		}
		connection->close(FORCE_CLOSE);
	}
}
