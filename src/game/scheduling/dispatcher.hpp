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
	FIRST,
	LAST
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
		threads.resize(std::thread::hardware_concurrency() + 1);
	};

	// Ensures that we don't accidentally copy it
	Dispatcher(const Dispatcher &) = delete;
	Dispatcher operator=(const Dispatcher &) = delete;

	static Dispatcher &getInstance();

	void init();
	void shutdown() {
		task_async_signal.notify_all();
	}

	void addEvent(std::function<void(void)> &&f, std::string &&context, uint32_t expiresAfterMs = 0);
	void addEvent_async(std::function<void(void)> &&f, AsyncEventContext context = AsyncEventContext::FIRST);

	uint64_t scheduleEvent(const std::shared_ptr<Task> &task);
	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string &&context) {
		return scheduleEvent(delay, std::move(f), std::move(context), false);
	}
	uint64_t cycleEvent(uint32_t delay, std::function<void(void)> &&f, std::string &&context) {
		return scheduleEvent(delay, std::move(f), std::move(context), true);
	}

	[[nodiscard]] uint64_t getDispatcherCycle() const {
		return dispatcherCycle;
	}

	void stopEvent(uint64_t eventId);

private:
	static int16_t getThreadId() {
		static std::atomic_int16_t last_id = -1;
		thread_local static int16_t id = -1;
		return id > -1 ? id : (id = ++last_id);
	};

	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string &&context, bool cycle);

	inline void merge_events();
	inline void execute_events();
	inline void execute_async_events(const std::vector<Task> &taskList);
	inline void execute_scheduled_events();

	uint_fast64_t dispatcherCycle = 0;

	ThreadPool &threadPool;
	std::mutex mutex;
	std::condition_variable task_async_signal;

	// Thread Events
	struct ThreadTask {
		ThreadTask() {
			tasks.reserve(2000);
			scheduledtasks.reserve(2000);
		}

		std::vector<Task> tasks;
		std::array<std::vector<Task>, static_cast<uint8_t>(AsyncEventContext::LAST)> asyncTasks;
		std::vector<std::shared_ptr<Task>> scheduledtasks;
	};
	std::vector<ThreadTask> threads;

	// Main Events
	std::vector<Task> eventTasks;
	std::array<std::vector<Task>, static_cast<uint8_t>(AsyncEventContext::LAST)> asyncEventTasks;
	std::priority_queue<std::shared_ptr<Task>, std::deque<std::shared_ptr<Task>>, Task::Compare> scheduledtasks;
	phmap::parallel_flat_hash_map_m<uint64_t, std::shared_ptr<Task>> scheduledtasksRef;
};

constexpr auto g_dispatcher = Dispatcher::getInstance;
