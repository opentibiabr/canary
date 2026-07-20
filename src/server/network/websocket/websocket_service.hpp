/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/connection/connection.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <memory>
#endif

class WebSocketServicePort : public std::enable_shared_from_this<WebSocketServicePort> {
public:
	explicit WebSocketServicePort(asio::io_service &initIoService);
	~WebSocketServicePort();

	WebSocketServicePort(const WebSocketServicePort &) = delete;
	WebSocketServicePort &operator=(const WebSocketServicePort &) = delete;

	static void openAcceptor(const std::weak_ptr<WebSocketServicePort> &weakService, uint16_t port);
	void open(uint16_t port);
	void close() const;
	void onStopServer() const;

private:
	void accept();
	void onAccept(const Connection_ptr &connection, const std::error_code &error);
	void readHandshake(const Connection_ptr &connection);

	asio::io_service &io_service;
	std::unique_ptr<asio::ip::tcp::acceptor> acceptor;
	uint16_t serverPort = 0;
	bool pendingStart = false;
};

using WebSocketServicePort_ptr = std::shared_ptr<WebSocketServicePort>;
