/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
// #include <queue>
#include "task.hpp"

class Task;

const int DISPATCHER_TASK_EXPIRATION = 2000;

/**
 * Dispatcher allow you to dispatch a task async to be executed
 * in the dispatching thread. You can dispatch with an expiration
 * time, after which the task will be ignored.
 */
class Dispatcher {
public:
	Dispatcher() {
		tasks.reserve(1000);
		taskQueue.list.reserve(1000);
	};

	// Ensures that we don't accidentally copy it
	Dispatcher(const Dispatcher &) = delete;
	Dispatcher operator=(const Dispatcher &) = delete;

	static Dispatcher &getInstance();

	void init();
	void shutdown() {
		thread.get_stop_source().request_stop();
	}

	void addEvent(std::function<void(void)> f, const std::string &context);
	void addEvent(std::function<void(void)> f, const std::string &context, uint32_t expiresAfterMs) {
		addEvent(f, context);
	}

	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> f, std::string context) {
		return scheduleEvent(delay, f, context, false);
	}
	uint64_t cycleEvent(uint32_t delay, std::function<void(void)> f, std::string context) {
		return scheduleEvent(delay, f, context, true);
	}

	[[nodiscard]] uint64_t getDispatcherCycle() const {
		return dispatcherCycle;
	}

	void stopEvent(uint64_t eventId);

private:
	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> f, std::string context, bool cycle);

	enum TaskState : uint8_t {
		EMPTY,
		BUSY,
		HAS_VALUE
	};

	uint64_t dispatcherCycle = 0;
	std::atomic_uint64_t lastEventId { 0 };

	std::jthread thread;
	std::vector<std::unique_ptr<Task>> tasks;

	struct {
		std::atomic_uint8_t state = TaskState::EMPTY;
		std::recursive_mutex mutex;
		std::vector<std::unique_ptr<Task>> list;
	} taskQueue;

	struct {
		std::recursive_mutex mutex;
		std::priority_queue<std::shared_ptr<Task>, std::deque<std::shared_ptr<Task>>, Task::Compare> list;
		phmap::flat_hash_map<uint64_t, std::shared_ptr<Task>> map;
	} scheduledTaskQueue;
};

constexpr auto g_dispatcher = Dispatcher::getInstance;
