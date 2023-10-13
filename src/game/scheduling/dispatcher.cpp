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
	auto &thread = threads[getThreadId()];
	std::scoped_lock lock(thread->mutex);
	thread->tasks.emplace_back(expiresAfterMs, std::move(f), context);
	cv.notify_one();
}

void Dispatcher::addEvent_async(std::function<void(void)> &&f, AsyncEventContext context) {
	auto &thread = threads[getThreadId()];
	std::scoped_lock lock(thread->mutex);
	thread->asyncTasks[static_cast<uint8_t>(context)].emplace_back(0, std::move(f), "Dispatcher::addEvent_async");
	cv.notify_one();
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	auto &thread = threads[getThreadId()];
	std::scoped_lock lock(thread->mutex);
	thread->scheduledTasks.emplace_back(task);
	cv.notify_one();
	return scheduledTasksRef.emplace(task->generateId(), task).first->first;
}

uint64_t Dispatcher::scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context, bool cycle) {
	const auto &task = std::make_shared<Task>(std::move(f), context, delay, cycle);
	return scheduleEvent(task);
}

void Dispatcher::stopEvent(uint64_t eventId) {
	auto it = scheduledTasksRef.find(eventId);
	if (it == scheduledTasksRef.end()) {
		return;
	}

	it->second->cancel();
	scheduledTasksRef.erase(it);
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

			if (executedTasks.fetch_add(1) == totalTaskSize) {
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
	for (uint_fast64_t i = 0, max = scheduledTasks.size(); i < max && !scheduledTasks.empty(); ++i) {
		const auto &task = scheduledTasks.top();
		if (task->getTime() > Task::TIME_NOW) {
			break;
		}

		if (task->execute() && task->isCycle()) {
			task->updateTime();
			scheduledTasks.emplace(task);
		} else {
			scheduledTasksRef.erase(task->getEventId());
		}

		scheduledTasks.pop();
	}
}

// Merge thread events with main dispatch events
void Dispatcher::mergeEvents() {
	for (auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		if (!thread->tasks.empty()) {
			eventTasks.insert(eventTasks.end(), make_move_iterator(thread->tasks.begin()), make_move_iterator(thread->tasks.end()));
			thread->tasks.clear();
		}

		for (uint_fast8_t i = 0; i < static_cast<uint8_t>(AsyncEventContext::Last); ++i) {
			auto &context = thread->asyncTasks[i];
			if (!context.empty()) {
				asyncEventTasks[i].insert(asyncEventTasks[i].end(), make_move_iterator(context.begin()), make_move_iterator(context.end()));
				context.clear();
			}
		}

		if (!thread->scheduledTasks.empty()) {
			for (auto &task : thread->scheduledTasks) {
				scheduledTasks.emplace(task);
				scheduledTasksRef.emplace(task->getEventId(), task);
			}
			thread->scheduledTasks.clear();
		}
	}
}

std::chrono::nanoseconds Dispatcher::timeUntilNextScheduledTask() {
	if (scheduledTasks.empty()) {
		return std::chrono::milliseconds::max();
	}

	const auto &task = scheduledTasks.top();
	auto timeRemaining = task->getTime() - Task::TIME_NOW;
	if (timeRemaining < std::chrono::nanoseconds(0)) {
		return std::chrono::nanoseconds(0);
	}
	return timeRemaining;
}
