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

static constexpr uint16_t DISPATCHER_TASK_EXPIRATION = 2000;
static constexpr uint16_t SCHEDULER_MINTICKS = 50;

/**
 * Dispatcher allow you to dispatch a task async to be executed
 * in the dispatching thread. You can dispatch with an expiration
 * time, after which the task will be ignored.
 */
class Dispatcher {
public:
	Dispatcher() {
		tasks.list.reserve(1000);
		tasks.waitingList.reserve(1000);
	};

	// Ensures that we don't accidentally copy it
	Dispatcher(const Dispatcher &) = delete;
	Dispatcher operator=(const Dispatcher &) = delete;

	static Dispatcher &getInstance();

	void init();
	void shutdown() {
		tasks.thread.get_stop_source().request_stop();
		scheduledtasks.thread.get_stop_source().request_stop();
	}

	void addEvent(std::function<void(void)> f, const std::string &context);
	void addEvent(std::function<void(void)> f, const std::string &context, uint32_t expiresAfterMs) {
		addEvent(f, context);
	}

	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> f, std::string context) {
		return scheduleEvent(delay, f, context, false);
	}

	uint64_t scheduleEvent(const std::shared_ptr<Task> task);

	uint64_t cycleEvent(uint32_t delay, std::function<void(void)> f, std::string context) {
		return scheduleEvent(delay, f, context, true);
	}

	void addTask(const std::shared_ptr<Task> &task);
	void addTask(const std::shared_ptr<Task> &task, uint32_t expiresAfterMs) {
		addTask(task);
	}

	[[nodiscard]] uint64_t getDispatcherCycle() const {
		return dispatcherCycle;
	}

	void stopEvent(uint64_t eventId);

private:
	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> f, std::string context, bool cycle);
	void try_notify() {
		if (tasks.busy && !tasks.waitingList.empty()) {
			scheduleEvent(
				50, [&] { tasks.signal.notify_one(); }, "waitingList::notify"
			);
		}
	}

	enum TaskState : uint8_t {
		EMPTY,
		BUSY,
		HAS_VALUE
	};

	uint64_t dispatcherCycle = 0;
	std::atomic_uint64_t lastEventId { 0 };

	std::mutex mutex;
	struct {
		bool busy { false };

		std::jthread thread;
		std::condition_variable signal;

		std::mutex mutex;

		std::vector<std::shared_ptr<Task>> list;
		std::vector<std::shared_ptr<Task>> waitingList;
	} tasks;

	struct {
		void notify(uint16_t ms) {
			cycle = std::chrono::system_clock::now() + std::chrono::milliseconds(ms);
		}

		std::jthread thread;
		std::condition_variable signal;

		std::mutex mutex;
		std::priority_queue<std::shared_ptr<Task>, std::deque<std::shared_ptr<Task>>, Task::Compare> list;
		phmap::flat_hash_map<uint64_t, std::shared_ptr<Task>> map;

		std::chrono::system_clock::time_point cycle;
	} scheduledtasks;
};

constexpr auto g_dispatcher = Dispatcher::getInstance;
