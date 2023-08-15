/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"
#include "lib/thread/thread_pool.hpp"
#include "utils/tools.h"

ThreadPool::ThreadPool(Logger &logger) :
	logger(logger) {
	logger.info("Setting up thread pool");

	for (std::size_t i = 0; i < getNumberOfCores(); ++i) {
		threads.emplace_back([this] { ioService.run(); });
	}

	logger.info("Running with {} threads.", threads.size());
}

ThreadPool::~ThreadPool() {
	//	shutdown();
}

void ThreadPool::shutdown() {
	if (ioService.stopped()) {
		return;
	}

	ioService.stop();

	for (auto &thread : threads) {
		if (thread.joinable()) {
			thread.join();
		}
	}
}

asio::io_context &ThreadPool::getIoService() {
	return ioService;
}

void ThreadPool::addLoad(const std::function<void(void)> &load) {
	if (ioService.stopped()) {
		logger.error("Shutting down, cannot execute task.");
		return;
	}

	asio::post(ioService, [this, load]() {
		try {
			load();
		} catch (const std::exception &e) {
			logger.error("Exception while executing async load: {}", e.what());
		} catch (...) {
			logger.error("Unknown exception while executing async load.");
		}
	});
}