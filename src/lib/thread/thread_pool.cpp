/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lib/thread/thread_pool.hpp"

#include "game/game.hpp"
#include "utils/tools.hpp"
#include "lib/di/container.hpp"

#include <csignal>

/**
 * Regardless of how many cores your computer have, we want at least
 * 4 threads because, even though they won't improve processing they
 * will make processing non-blocking in some way and that would allow
 * single core computers to process things concurrently, but not in parallel.
 */

#ifndef DEFAULT_NUMBER_OF_THREADS
	#define DEFAULT_NUMBER_OF_THREADS 4
#endif

ThreadPool &ThreadPool::getInstance() {
	return inject<ThreadPool>();
}

ThreadPool::ThreadPool(Logger &logger, uint32_t threadCount) :
	logger(logger),
	pool { std::make_unique<BS::thread_pool<BS::tp::none>>(
		threadCount > 0 ? threadCount : std::max<int>(getNumberOfCores(), DEFAULT_NUMBER_OF_THREADS)
	) } {
	start();
}

void ThreadPool::start() const {
	logger.info("Running with {} threads.", get_thread_count());
}

void ThreadPool::shutdown() {
	if (stopped) {
		return;
	}

	stopped = true;

	logger.info("Shutting down thread pool...");
	pool.reset();

	std::signal(SIGINT, SIG_DFL);
	std::signal(SIGTERM, SIG_DFL);

	logger.info("Thread pool shutdown complete.");
}
