/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "BS_thread_pool.hpp"

class ThreadPool {
public:
	explicit ThreadPool(Logger &logger, const uint32_t threadCount = std::thread::hardware_concurrency());

	// Ensures that we don't accidentally copy it
	ThreadPool(const ThreadPool &) = delete;
	ThreadPool &operator=(const ThreadPool &) = delete;

	static ThreadPool &getInstance();

	template <typename F>
	void detach_task(F &&f) {
		pool->detach_task(std::forward<F>(f));
	}

	template <typename F>
	auto submit_loop(std::size_t first, std::size_t last, F &&f) {
		return pool->submit_loop(first, last, std::forward<F>(f));
	}

	auto get_thread_count() const noexcept {
		return pool->get_thread_count();
	}

	void start() const;
	void shutdown();

	static int16_t getThreadId() {
		static std::atomic_int16_t lastId = -1;
		thread_local static int16_t id = -1;

		if (id == -1) {
			lastId.fetch_add(1);
			id = lastId.load();
		}

		return id;
	}

	bool isStopped() const {
		return stopped;
	}

private:
	std::mutex mutex;
	std::condition_variable condition;

	Logger &logger;
	std::atomic<bool> stopped { false };

	std::unique_ptr<BS::thread_pool<BS::tp::none>> pool;
};

constexpr auto g_threadPool = ThreadPool::getInstance;
