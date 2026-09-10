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

#include <csignal>

#ifdef _WIN32
	#include <Windows.h>
#endif

#ifdef __linux__
	#include <pthread.h>
#endif

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <charconv>
	#include <system_error>
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

namespace {
	constexpr std::size_t ThreadNameCapacity = 16;
}

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
	std::array<char, ThreadNameCapacity> threadName {};
	const auto length = std::min<std::size_t>(name.size(), threadName.size() - 1);
	std::copy_n(name.begin(), length, threadName.begin());
#endif

#ifdef __linux__
	(void)pthread_setname_np(pthread_self(), threadName.data());
#elif defined(_WIN32)
	using SetThreadDescriptionFunction = HRESULT(WINAPI*)(HANDLE, PCWSTR);
	static const auto setThreadDescription = []() noexcept {
		// Runtime lookup also supports Windows 10 1607 and Windows Server 2016.
		const auto kernelBase = GetModuleHandleW(L"KernelBase.dll");
		const auto function = kernelBase ? GetProcAddress(kernelBase, "SetThreadDescription") : nullptr;
		return function ? reinterpret_cast<SetThreadDescriptionFunction>(function) : nullptr; // NOSONAR: The Win32 API requires converting FARPROC to the typed function pointer.
	}();
	if (!setThreadDescription) {
		return;
	}

	std::array<wchar_t, ThreadNameCapacity> wideName {};
	if (MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, threadName.data(), -1, wideName.data(), static_cast<int>(wideName.size())) > 0) {
		(void)setThreadDescription(GetCurrentThread(), wideName.data());
	}
#else
	(void)name;
#endif
}

void ThreadPool::setWorkerThreadName(const std::size_t index) noexcept {
	constexpr std::string_view workerPrefix = "canary-wrk-";
	std::array<char, ThreadNameCapacity> threadName {};
	std::copy_n(workerPrefix.begin(), workerPrefix.size(), threadName.begin());

	const auto [nameEnd, error] = std::to_chars(threadName.data() + workerPrefix.size(), threadName.data() + threadName.size() - 1, index);
	if (error != std::errc {}) {
		setCurrentThreadName("canary-wrk");
		return;
	}

	setCurrentThreadName({ threadName.data(), static_cast<std::size_t>(nameEnd - threadName.data()) });
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
