/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/scheduling/dispatcher.hpp"
#include "lib/thread/thread_pool.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

constexpr static auto ASYNC_TIME_OUT = std::chrono::seconds(15);
constexpr static auto SLEEP_TIME_MS = 15;

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	updateClock();

	threadPool.addLoad([this] {
		std::unique_lock asyncLock(mutex);

		while (!threadPool.getIoContext().stopped()) {
			updateClock();

			// Execute all asynchronous events separately by context
			for (uint_fast8_t i = 0; i < static_cast<uint8_t>(AsyncEventContext::Last); ++i) {
				executeAsyncEvents(i, asyncLock);
			}

			// Merge all events that were created by async events
			mergeEvents();

			executeEvents();
			executeScheduledEvents();

			// Merge all events that were created by events and scheduled events
			mergeEvents();

			auto waitDuration = timeUntilNextScheduledTask();
			cv.wait_for(asyncLock, waitDuration);
		}
	});
}

void Dispatcher::addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	threads[getThreadId()].tasks.emplace_back(expiresAfterMs, std::move(f), context);
	cv.notify_one();
}

void Dispatcher::addEvent_async(std::function<void(void)> &&f, AsyncEventContext context) {
	threads[getThreadId()].asyncTasks[static_cast<uint8_t>(context)].emplace_back(0, std::move(f), "Dispatcher::addEvent_async");
	cv.notify_one();
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	threads[getThreadId()].scheduledtasks.emplace_back(task);
	return scheduledtasksRef.emplace(task->generateId(), task).first->first;
}

uint64_t Dispatcher::scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context, bool cycle) {
	const auto &task = std::make_shared<Task>(std::move(f), context, delay, cycle);
	return scheduleEvent(task);
}

void Dispatcher::stopEvent(uint64_t eventId) {
	auto it = scheduledtasksRef.find(eventId);
	if (it == scheduledtasksRef.end()) {
		return;
	}

	it->second->cancel();
	scheduledtasksRef.erase(it);
}

void Dispatcher::executeEvents() {
	for (const auto &task : eventTasks) {
		if (task.execute()) {
			++dispatcherCycle;
		}
	}
	eventTasks.clear();
}

void Dispatcher::executeAsyncEvents(const uint8_t contextId, std::unique_lock<std::mutex> &asyncLock) {
	auto &asyncTasks = asyncEventTasks[contextId];
	if (asyncTasks.empty()) {
		return;
	}

	std::atomic_uint_fast64_t executedTasks = 0;

	// Execute Async Task
	for (const auto &task : asyncTasks) {
		threadPool.addLoad([this, &task, &executedTasks, totalTaskSize = asyncTasks.size()] {
			task.execute();

			executedTasks.fetch_add(1);
			if (executedTasks.load() == totalTaskSize) {
				asyncTasks_cv.notify_one();
			}
		});
	}

	// Wait for all the tasks in the current context to be executed.
	if (asyncTasks_cv.wait_for(asyncLock, ASYNC_TIME_OUT) == std::cv_status::timeout) {
		g_logger().warn("A timeout occurred when executing the async dispatch in the context({}).", contextId);
	}

	// Clear all async tasks
	asyncTasks.clear();
}

void Dispatcher::executeScheduledEvents() {
	for (uint_fast64_t i = 0, max = scheduledtasks.size(); i < max && !scheduledtasks.empty(); ++i) {
		const auto &task = scheduledtasks.top();
		if (task->getTime() > Task::TIME_NOW) {
			break;
		}

		if (task->execute() && task->isCycle()) {
			task->updateTime();
			scheduledtasks.emplace(task);
		} else {
			scheduledtasksRef.erase(task->getEventId());
		}

		scheduledtasks.pop();
	}
}

// Merge thread events with main dispatch events
void Dispatcher::mergeEvents() {
	for (auto &thread : threads) {
		if (!thread.tasks.empty()) {
			eventTasks.insert(eventTasks.end(), make_move_iterator(thread.tasks.begin()), make_move_iterator(thread.tasks.end()));
			thread.tasks.clear();
		}

		for (uint_fast8_t i = 0; i < static_cast<uint8_t>(AsyncEventContext::Last); ++i) {
			auto &context = thread.asyncTasks[i];
			if (!context.empty()) {
				asyncEventTasks[i].insert(asyncEventTasks[i].end(), make_move_iterator(context.begin()), make_move_iterator(context.end()));
				context.clear();
			}
		}

		if (!thread.scheduledtasks.empty()) {
			for (auto &task : thread.scheduledtasks) {
				scheduledtasks.emplace(task);
				scheduledtasksRef.emplace(task->getEventId(), task);
			}
			thread.scheduledtasks.clear();
		}
	}
}

std::chrono::milliseconds Dispatcher::timeUntilNextScheduledTask() {
	if (scheduledtasks.empty()) {
		return std::chrono::milliseconds::max();
	}

	const auto &task = scheduledtasks.top();
	auto timeRemaining = task->getTime() - Task::TIME_NOW;
	if (timeRemaining < std::chrono::milliseconds(0)) {
		return std::chrono::milliseconds(0);
	}
	return std::chrono::duration_cast<std::chrono::milliseconds>(timeRemaining);
}
