/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/websocket/websocket_service.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/management/ban.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/di/container.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "server/network/websocket/websocket_utils.hpp"
#include "server/server.hpp"
#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <functional>
	#include <string>
#endif

WebSocketServicePort::WebSocketServicePort(asio::io_service &initIoService) :
	io_service(initIoService) {
}

WebSocketServicePort::~WebSocketServicePort() {
	close();
}

void WebSocketServicePort::openAcceptor(const std::weak_ptr<WebSocketServicePort> &weakService, uint16_t port) {
	if (const auto service = weakService.lock()) {
		service->open(port);
	}
}

void WebSocketServicePort::open(uint16_t port) {
	close();

	serverPort = port;
	pendingStart = false;

	try {
		if (g_configManager().getBoolean(BIND_ONLY_GLOBAL_ADDRESS)) {
			acceptor = std::make_unique<asio::ip::tcp::acceptor>(
				io_service,
				asio::ip::tcp::endpoint(asio::ip::address(asio::ip::address_v4::from_string(g_configManager().getString(IP))), serverPort)
			);
		} else {
			acceptor = std::make_unique<asio::ip::tcp::acceptor>(
				io_service,
				asio::ip::tcp::endpoint(asio::ip::address(asio::ip::address_v4(INADDR_ANY)), serverPort)
			);
		}

		acceptor->set_option(asio::ip::tcp::no_delay(true));
		g_logger().info("WebSocket game protocol listening on port {}", serverPort);
		accept();
	} catch (const std::system_error &e) {
		g_logger().warn("[WebSocketServicePort::open] - Error code: {}", e.what());
		pendingStart = true;
		g_dispatcher().scheduleEvent(
			15000,
			[self = shared_from_this(), port] { WebSocketServicePort::openAcceptor(std::weak_ptr<WebSocketServicePort>(self), port); },
			"WebSocketServicePort::openAcceptor",
			DispatcherLane::Maintenance
		);
	}
}

void WebSocketServicePort::close() const {
	if (acceptor && acceptor->is_open()) {
		std::error_code error;
		acceptor->close(error);
	}
}

void WebSocketServicePort::onStopServer() const {
	close();
}

void WebSocketServicePort::accept() {
	if (!acceptor) {
		return;
	}

	auto connection = ConnectionManager::getInstance().createConnection(io_service, nullptr);
	acceptor->async_accept(connection->getSocket(), [self = shared_from_this(), connection](const std::error_code &error) {
		self->onAccept(connection, error);
	});
}

void WebSocketServicePort::onAccept(const Connection_ptr &connection, const std::error_code &error) {
	if (!error) {
		const auto remoteIp = connection->getIP();
		if (remoteIp != 0 && inject<Ban>().acceptConnection(remoteIp)) {
			readHandshake(connection);
		} else {
			connection->close(FORCE_CLOSE);
		}
		accept();
	} else if (error != asio::error::operation_aborted) {
		if (!pendingStart) {
			close();
			pendingStart = true;
			g_dispatcher().scheduleEvent(
				15000,
				[self = shared_from_this(), serverPort = serverPort] {
					WebSocketServicePort::openAcceptor(std::weak_ptr<WebSocketServicePort>(self), serverPort);
				},
				"WebSocketServicePort::openAcceptor",
				DispatcherLane::Maintenance
			);
		}
	}
}

void WebSocketServicePort::readHandshake(const Connection_ptr &connection) {
	auto buffer = std::make_shared<std::vector<uint8_t>>(4096);
	auto accumulated = std::make_shared<std::string>();

	auto reader = std::make_shared<std::function<void()>>();
	*reader = [self = shared_from_this(), connection, buffer, accumulated, reader]() {
		connection->getSocket().async_read_some(
			asio::buffer(*buffer),
			[self, connection, buffer, accumulated, reader](const std::error_code &error, size_t bytesTransferred) {
				if (error || bytesTransferred == 0) {
					connection->close(FORCE_CLOSE);
					return;
				}

				accumulated->append(reinterpret_cast<const char*>(buffer->data()), bytesTransferred);
				if (accumulated->size() > 8192) {
					g_logger().warn("[WebSocketServicePort] handshake too large from {}", convertIPToString(connection->getIP()));
					connection->close(FORCE_CLOSE);
					return;
				}

				if (accumulated->find("\r\n\r\n") == std::string::npos) {
					(*reader)();
					return;
				}

				std::string clientKey;
				std::string path;
				if (!websocket_utils::parseUpgradeRequest(*accumulated, clientKey, path) || path != "/") {
					g_logger().debug("[WebSocketServicePort] rejected handshake path='{}' from {}", path, convertIPToString(connection->getIP()));
					const auto response = std::make_shared<std::string>(
						"HTTP/1.1 400 Bad Request\r\nConnection: close\r\nContent-Length: 0\r\n\r\n"
					);
					asio::async_write(
						connection->getSocket(),
						asio::buffer(*response),
						[connection, response](const std::error_code &, size_t) { connection->close(FORCE_CLOSE); }
					);
					return;
				}

				const auto acceptKey = websocket_utils::computeAcceptKey(clientKey);
				const auto response = std::make_shared<std::string>(websocket_utils::buildUpgradeResponse(acceptKey));
				asio::async_write(
					connection->getSocket(),
					asio::buffer(*response),
					[connection, response](const std::error_code &writeError, size_t) {
						if (writeError) {
							connection->close(FORCE_CLOSE);
							return;
						}
						connection->acceptWebSocket(std::make_shared<ProtocolGame>(connection));
					}
				);
			}
		);
	};

	(*reader)();
}
