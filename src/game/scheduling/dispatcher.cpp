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

thread_local DispatcherContext Dispatcher::dispacherContext;

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	updateClock();

	threadPool.addLoad([this] {
		std::unique_lock asyncLock(dummyMutex);

		while (!threadPool.getIoContext().stopped()) {
			updateClock();

			executeEvents();
			executeScheduledEvents();
			mergeEvents();

			if (!hasPendingTasks) {
				signalSchedule.wait_for(asyncLock, timeUntilNextScheduledTask());
			}
		}
	});
}

void Dispatcher::executeSerialEvents(std::vector<Task> &tasks) {
	dispacherContext.group = TaskGroup::Serial;
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

void Dispatcher::executeParallelEvents(std::vector<Task> &tasks, const uint8_t groupId) {
	std::atomic_uint_fast64_t totalTaskSize = tasks.size();
	std::atomic_bool isTasksCompleted = false;

	for (const auto &task : tasks) {
		threadPool.addLoad([groupId, &task, &isTasksCompleted, &totalTaskSize] {
			dispacherContext.type = DispatcherType::AsyncEvent;
			dispacherContext.group = static_cast<TaskGroup>(groupId);
			dispacherContext.taskName = task.getContext();

			task.execute();

			dispacherContext.reset();

			totalTaskSize.fetch_sub(1);
			if (totalTaskSize.load() == 0) {
				isTasksCompleted.store(true);
				isTasksCompleted.notify_one();
			}
		});
	}

	isTasksCompleted.wait(false);

	tasks.clear();
}

void Dispatcher::executeEvents(const TaskGroup startGroup) {
	for (uint_fast8_t groupId = static_cast<uint8_t>(startGroup); groupId < static_cast<uint8_t>(TaskGroup::Last); ++groupId) {
		auto &tasks = m_tasks[groupId];
		if (tasks.empty()) {
			return;
		}

		if (groupId == static_cast<uint8_t>(TaskGroup::Serial)) {
			executeSerialEvents(tasks);
			mergeAsyncEvents();
		} else {
			executeParallelEvents(tasks, groupId);
		}
	}
}

void Dispatcher::executeScheduledEvents() {
	auto &threadScheduledTasks = getThreadTask()->scheduledTasks;

	auto it = scheduledTasks.begin();
	while (it != scheduledTasks.end()) {
		const auto &task = *it;
		if (task->getTime() > Task::TIME_NOW) {
			break;
		}

		dispacherContext.type = task->isCycle() ? DispatcherType::CycleEvent : DispatcherType::ScheduledEvent;
		dispacherContext.group = TaskGroup::Serial;
		dispacherContext.taskName = task->getContext();

		if (task->execute() && task->isCycle()) {
			task->updateTime();
			threadScheduledTasks.emplace_back(task);
		} else {
			scheduledTasksRef.erase(task->getId());
		}

		++it;
	}

	if (it != scheduledTasks.begin()) {
		scheduledTasks.erase(scheduledTasks.begin(), it);
	}

	dispacherContext.reset();

	mergeAsyncEvents(); // merge async events requested by scheduled events
	executeEvents(TaskGroup::GenericParallel); // execute async events requested by scheduled events
}

// Merge only async thread events with main dispatch events
void Dispatcher::mergeAsyncEvents() {
	constexpr uint8_t start = static_cast<uint8_t>(TaskGroup::GenericParallel);
	constexpr uint8_t end = static_cast<uint8_t>(TaskGroup::Last);

	for (const auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		for (uint_fast8_t i = start; i < end; ++i) {
			if (!thread->tasks[i].empty()) {
				m_tasks[i].insert(m_tasks[i].end(), make_move_iterator(thread->tasks[i].begin()), make_move_iterator(thread->tasks[i].end()));
				thread->tasks[i].clear();
			}
		}
	}
}

// Merge thread events with main dispatch events
void Dispatcher::mergeEvents() {
	constexpr uint8_t serial = static_cast<uint8_t>(TaskGroup::Serial);

	for (const auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		if (!thread->tasks[serial].empty()) {
			m_tasks[serial].insert(m_tasks[serial].end(), make_move_iterator(thread->tasks[serial].begin()), make_move_iterator(thread->tasks[serial].end()));
			thread->tasks[serial].clear();
		}

		if (!thread->scheduledTasks.empty()) {
			scheduledTasks.insert(make_move_iterator(thread->scheduledTasks.begin()), make_move_iterator(thread->scheduledTasks.end()));
			thread->scheduledTasks.clear();
		}
	}

	checkPendingTasks();
}

std::chrono::nanoseconds Dispatcher::timeUntilNextScheduledTask() const {
	static constexpr auto CHRONO_NANO_0 = std::chrono::nanoseconds(0);
	static constexpr auto CHRONO_MILI_MAX = std::chrono::milliseconds::max();

	if (scheduledTasks.empty()) {
		return CHRONO_MILI_MAX;
	}

	const auto &task = *scheduledTasks.begin();
	const auto timeRemaining = task->getTime() - Task::TIME_NOW;
	return std::max<std::chrono::nanoseconds>(timeRemaining, CHRONO_NANO_0);
}

void Dispatcher::addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	thread->tasks[static_cast<uint8_t>(TaskGroup::Serial)].emplace_back(expiresAfterMs, std::move(f), context);
	notify();
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);

	auto eventId = scheduledTasksRef
					   .emplace(task->getId(), thread->scheduledTasks.emplace_back(task))
					   .first->first;

	notify();
	return eventId;
}

void Dispatcher::asyncEvent(std::function<void(void)> &&f, TaskGroup group) {
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	thread->tasks[static_cast<uint8_t>(group)].emplace_back(0, std::move(f), dispacherContext.taskName);
	notify();
}

void Dispatcher::stopEvent(uint64_t eventId) {
	const auto &it = scheduledTasksRef.find(eventId);
	if (it != scheduledTasksRef.end()) {
		it->second->cancel();
		scheduledTasksRef.erase(it);
	}
}

void DispatcherContext::addEvent(std::function<void(void)> &&f) const {
	g_dispatcher().addEvent(std::move(f), taskName);
}

void DispatcherContext::tryAddEvent(std::function<void(void)> &&f) const {
	if (!f) {
		return;
	}

	if (isAsync()) {
		g_dispatcher().addEvent(std::move(f), taskName);
	} else {
		f();
	}
}
