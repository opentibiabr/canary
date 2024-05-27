/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lib/thread/thread_pool.hpp"

#include "game/game.hpp"
#include "utils/tools.hpp"

#ifndef DEFAULT_NUMBER_OF_THREADS
	#define DEFAULT_NUMBER_OF_THREADS 4
#endif

ThreadPool::ThreadPool(Logger &logger) :
	logger(logger), BS::thread_pool(std::max<int>(getNumberOfCores(), DEFAULT_NUMBER_OF_THREADS)) {
	start();
}

void ThreadPool::start() {
	logger.info("Running with {} threads.", get_thread_count());
}

void ThreadPool::shutdown() {
	stopped = true;
	logger.info("Shutting down thread pool...");
}
