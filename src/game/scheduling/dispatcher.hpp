/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "task.hpp"
#include "lib/thread/thread_pool.hpp"

static constexpr uint16_t DISPATCHER_TASK_EXPIRATION = 2000;
static constexpr uint16_t SCHEDULER_MINTICKS = 50;

enum class AsyncEventContext : uint8_t {
	First,
	Last
};

/**
 * Dispatcher allow you to dispatch a task async to be executed
 * in the dispatching thread. You can dispatch with an expiration
 * time, after which the task will be ignored.
 */
class Dispatcher {
public:
	explicit Dispatcher(ThreadPool &threadPool) :
		threadPool(threadPool) {
		threads.reserve(std::thread::hardware_concurrency() + 1);
		for (uint_fast16_t i = 0; i < std::thread::hardware_concurrency() + 1; ++i) {
			threads.emplace_back(std::make_unique<ThreadTask>());
		}
	};

	// Ensures that we don't accidentally copy it
	Dispatcher(const Dispatcher &) = delete;
	Dispatcher operator=(const Dispatcher &) = delete;

	static Dispatcher &getInstance();

	void init();
	void shutdown() {
		asyncTasks_cv.notify_all();
	}

	void addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs = 0);
	void addEvent_async(std::function<void(void)> &&f, AsyncEventContext context = AsyncEventContext::First);

	uint64_t scheduleEvent(const std::shared_ptr<Task> &task);
	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context) {
		return scheduleEvent(delay, std::move(f), context, false);
	}
	uint64_t cycleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context) {
		return scheduleEvent(delay, std::move(f), context, true);
	}

	[[nodiscard]] uint64_t getDispatcherCycle() const {
		return dispatcherCycle;
	}

	void stopEvent(uint64_t eventId);

private:
	// Update Time Cache
	static void updateClock() {
		Task::TIME_NOW = std::chrono::system_clock::now();
	}

	static int16_t getThreadId() {
		static std::atomic_int16_t lastId = -1;
		thread_local static int16_t id = -1;

		if (id == -1) {
			lastId.fetch_add(1);
			id = lastId.load();
		}

		return id;
	};

	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context, bool cycle);

	inline void mergeEvents();
	inline void executeEvents();
	inline void executeAsyncEvents(const uint8_t contextId, std::unique_lock<std::mutex> &asyncLock);
	inline void executeScheduledEvents();
	inline std::chrono::nanoseconds timeUntilNextScheduledTask();

	uint_fast64_t dispatcherCycle = 0;

	ThreadPool &threadPool;
	std::mutex mutex;
	std::condition_variable asyncTasks_cv;
	std::condition_variable cv;
	bool hasPendingTasks = false;

	// Thread Events
	struct ThreadTask {
		ThreadTask() {
			tasks.reserve(2000);
			scheduledTasks.reserve(2000);
		}

		std::vector<Task> tasks;
		std::array<std::vector<Task>, static_cast<uint8_t>(AsyncEventContext::Last)> asyncTasks;
		std::vector<std::shared_ptr<Task>> scheduledTasks;
		std::mutex mutex;
	};
	std::vector<std::unique_ptr<ThreadTask>> threads;

	// Main Events
	std::vector<Task> eventTasks;
	std::array<std::vector<Task>, static_cast<uint8_t>(AsyncEventContext::Last)> asyncEventTasks;
	std::priority_queue<std::shared_ptr<Task>, std::deque<std::shared_ptr<Task>>, Task::Compare> scheduledTasks;
	phmap::parallel_flat_hash_map_m<uint64_t, std::shared_ptr<Task>> scheduledTasksRef;
};

constexpr auto g_dispatcher = Dispatcher::getInstance;
