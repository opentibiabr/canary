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
#include "utils/tools.hpp"

#ifndef DEFAULT_NUMBER_OF_THREADS
	#define DEFAULT_NUMBER_OF_THREADS 4
#endif

ThreadPool::ThreadPool(Logger &logger) :
	logger(logger) {
	start();
}

void ThreadPool::start() {
	logger.info("Setting up thread pool");

	/**
	 * Regardless of how many cores your computer have, we want at least
	 * 4 threads because, even though they won't improve processing they
	 * will make processing non-blocking in some way and that would allow
	 * single core computers to process things concurrently, but not in parallel.
	 */
	nThreads = std::max<uint16_t>(static_cast<int>(getNumberOfCores()), DEFAULT_NUMBER_OF_THREADS);

	for (std::size_t i = 0; i < nThreads; ++i) {
		threads.emplace_back([this] { ioService.run(); });
	}

	logger.info("Running with {} threads.", threads.size());
}

void ThreadPool::shutdown() {
	if (ioService.stopped()) {
		return;
	}

	logger.info("Shutting down thread pool...");

	ioService.stop();

	for (std::size_t i = 0; i < threads.size(); i++) {
		logger.debug("Joining thread {}/{}.", i + 1, threads.size());

		if (threads[i].joinable()) {
			threads[i].join();
		}
	}
}

asio::io_context &ThreadPool::getIoContext() {
	return ioService;
}

void ThreadPool::addLoad(const std::function<void(void)> &load) {
	asio::post(ioService, [this, load]() {
		if (ioService.stopped()) {
			logger.error("Shutting down, cannot execute task.");
			return;
		}

		load();
	});
}
