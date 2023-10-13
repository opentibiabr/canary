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
thread_local DispatcherContext Dispatcher::dispacherContext;
static std::mutex dummyMutex; // This is only used for signaling the condition variable and not as an actual lock.

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	updateClock();

	threadPool.addLoad([this] {
		std::unique_lock asyncLock(dummyMutex);

		while (!threadPool.getIoContext().stopped()) {
			updateClock();

			for (uint_fast8_t i = 0; i < static_cast<uint8_t>(TaskGroup::Last); ++i) {
				executeEvents(i, asyncLock);
			}

			executeScheduledEvents();
			mergeEvents();

			if (!hasPendingTasks) {
				auto waitDuration = timeUntilNextScheduledTask();
				signalSchedule.wait_for(asyncLock, waitDuration);
			}
		}
	});
}

void Dispatcher::addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	auto &thread = threads[getThreadId()];
	std::scoped_lock lock(thread->mutex);
	bool notify = !hasPendingTasks;
	thread->tasks[static_cast<uint8_t>(TaskGroup::Serial)].emplace_back(expiresAfterMs, std::move(f), context);
	if (notify && !hasPendingTasks) {
		hasPendingTasks = true;
		signalSchedule.notify_one();
	}
}

void Dispatcher::asyncEvent(std::function<void(void)> &&f, TaskGroup group) {
	auto &thread = threads[getThreadId()];
	std::scoped_lock lock(thread->mutex);
	bool notify = !hasPendingTasks;
	thread->tasks[static_cast<uint8_t>(group)].emplace_back(0, std::move(f), "Dispatcher::asyncEvent");
	if (notify && !hasPendingTasks) {
		hasPendingTasks = true;
		signalSchedule.notify_one();
	}
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	auto &thread = threads[getThreadId()];
	std::scoped_lock lock(thread->mutex);
	thread->scheduledTasks.emplace_back(task);
	bool notify = !hasPendingTasks;
	signalSchedule.notify_one();
	auto eventId = scheduledTasksRef.emplace(task->generateId(), task).first->first;
	if (notify && !hasPendingTasks) {
		hasPendingTasks = true;
		signalSchedule.notify_one();
	}
	return eventId;
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

void Dispatcher::executeSerialEvents(std::vector<Task> &tasks) {
	dispacherContext.groupId = TaskGroup::Serial;
	dispacherContext.type = DispatcherType::Event;

	for (const auto &task : tasks) {
		dispacherContext.taskName = task.getContext();
		if (task.execute()) {
			++dispatcherCycle;
		}
	}
	tasks.clear();

	dispacherContext.reset();
}

void Dispatcher::executeParallelEvents(std::vector<Task> &tasks, const uint8_t groupId, std::unique_lock<std::mutex> &asyncLock) {
	std::atomic_uint_fast64_t executedTasks = 0;

	for (const auto &task : tasks) {
		threadPool.addLoad([this, &task, &executedTasks, groupId, totalTaskSize = tasks.size()] {
			dispacherContext.type = DispatcherType::AsyncEvent;
			dispacherContext.groupId = static_cast<TaskGroup>(groupId);
			dispacherContext.taskName = task.getContext();

			task.execute();

			dispacherContext.reset();

			executedTasks.fetch_add(1);
			if (executedTasks.load() == totalTaskSize) {
				signalAsync.notify_one();
			}
		});
	}

	if (signalAsync.wait_for(asyncLock, ASYNC_TIME_OUT) == std::cv_status::timeout) {
		g_logger().warn("A timeout occurred when executing the async dispatch in the context({}).", groupId);
	}
	tasks.clear();
}

void Dispatcher::executeEvents(const uint8_t groupId, std::unique_lock<std::mutex> &asyncLock) {
	auto &tasks = m_tasks[groupId];
	if (tasks.empty()) {
		return;
	}

	if (groupId == static_cast<uint8_t>(TaskGroup::Serial)) {
		executeSerialEvents(tasks);
	} else {
		executeParallelEvents(tasks, groupId, asyncLock);
	}
}

void Dispatcher::executeScheduledEvents() {
	for (uint_fast64_t i = 0, max = scheduledTasks.size(); i < max && !scheduledTasks.empty(); ++i) {
		const auto &task = scheduledTasks.top();
		if (task->getTime() > Task::TIME_NOW) {
			break;
		}

		dispacherContext.type = task->isCycle() ? DispatcherType::CycleEvent : DispatcherType::ScheduledEvent;
		dispacherContext.groupId = TaskGroup::Serial;
		dispacherContext.taskName = task->getContext();

		if (task->execute() && task->isCycle()) {
			task->updateTime();
			scheduledTasks.emplace(task);
		} else {
			scheduledTasksRef.erase(task->getEventId());
		}

		scheduledTasks.pop();
	}

	dispacherContext.reset();
}

// Merge thread events with main dispatch events
void Dispatcher::mergeEvents() {
	for (auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		if (!thread->tasks.empty()) {
			for (uint_fast8_t i = 0; i < static_cast<uint8_t>(TaskGroup::Last); ++i) {
				m_tasks[i].insert(m_tasks[i].end(), make_move_iterator(thread->tasks[i].begin()), make_move_iterator(thread->tasks[i].end()));
				thread->tasks[i].clear();
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

	checkPedingTasks();
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
