/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lib/thread/thread_pool.hpp"

#include "game/game.hpp"
#include "utils/tools.hpp"
#include "lib/di/container.hpp"

#include <cstdio>
#include <csignal>

#ifdef __linux__
	#include <pthread.h>
#endif

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <iterator>

	#ifdef _WIN32
		#include <windows.h>
	#endif
#endif

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
		threadCount > 0 ? threadCount : std::max<int>(getNumberOfCores(), DEFAULT_NUMBER_OF_THREADS),
		[](const std::size_t index) noexcept {
			ThreadPool::setWorkerThreadName(index);
		}
	) } {
	start();
}

void ThreadPool::setCurrentThreadName(std::string_view name) noexcept {
#if defined(__linux__) || defined(_WIN32)
	char threadName[16] = {};
	const auto length = std::min<std::size_t>(name.size(), sizeof(threadName) - 1);
	for (std::size_t i = 0; i < length; ++i) {
		threadName[i] = name[i];
	}
#endif

#ifdef __linux__
	(void)pthread_setname_np(pthread_self(), threadName);
#elif defined(_WIN32)
	using SetThreadDescriptionFunction = HRESULT(WINAPI*)(HANDLE, PCWSTR);
	static const auto setThreadDescription = []() noexcept -> SetThreadDescriptionFunction {
		// Runtime lookup also supports Windows 10 1607 and Windows Server 2016.
		const auto kernelBase = GetModuleHandleW(L"KernelBase.dll");
		return kernelBase ? reinterpret_cast<SetThreadDescriptionFunction>(GetProcAddress(kernelBase, "SetThreadDescription")) : nullptr;
	}();
	if (!setThreadDescription) {
		return;
	}

	wchar_t wideName[16] = {};
	if (MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, threadName, -1, wideName, static_cast<int>(std::size(wideName))) > 0) {
		(void)setThreadDescription(GetCurrentThread(), wideName);
	}
#else
	(void)name;
#endif
}

void ThreadPool::setWorkerThreadName(const std::size_t index) noexcept {
	char threadName[16] = {};
	(void)std::snprintf(threadName, sizeof(threadName), "canary-wrk-%zu", index);
	setCurrentThreadName(threadName);
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

	// Trigger graceful shutdown
	g_game().setGameState(GAME_STATE_SHUTDOWN);

	pool.reset();

	std::signal(SIGINT, SIG_DFL);
	std::signal(SIGTERM, SIG_DFL);

	logger.info("Thread pool shutdown complete.");
}
