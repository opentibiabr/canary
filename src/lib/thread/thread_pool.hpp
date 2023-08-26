/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "lib/logging/logger.hpp"

class ThreadPool {
public:
	explicit ThreadPool(Logger &logger);

	// Ensures that we don't accidentally copy it
	ThreadPool(const ThreadPool &) = delete;
	ThreadPool operator=(const ThreadPool &) = delete;

	void start();
	void shutdown();
	asio::io_context &getIoContext();
	void addLoad(const std::function<void(void)> &load);

private:
	Logger &logger;
	asio::io_context ioService;
	std::vector<std::jthread> threads;
	asio::io_context::work work { ioService };
};
