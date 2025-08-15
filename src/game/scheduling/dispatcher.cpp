/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher.hpp"

#include "lib/thread/thread_pool.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

thread_local DispatcherContext Dispatcher::dispacherContext;

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	UPDATE_OTSYS_TIME();

	auto dispatcherStarted = std::make_shared<std::promise<void>>();
	auto futureStarted = dispatcherStarted->get_future();

	threadPool.detach_task([this, dispatcherStarted]() mutable {
		std::unique_lock asyncLock(dummyMutex);

		dispatcherStarted->set_value();

		while (!threadPool.isStopped()) {
			UPDATE_OTSYS_TIME();

			executeEvents();
			executeScheduledEvents();
			mergeEvents();

			if (!hasPendingTasks) {
				signalSchedule.wait_for(asyncLock, timeUntilNextScheduledTask());
			}
		}
	});

	if (futureStarted.wait_for(std::chrono::seconds(5)) != std::future_status::ready) {
		throw std::logic_error("Failed to initialize dispatcher: timeout waiting for thread start");
	}
}

void Dispatcher::executeSerialEvents(const uint8_t groupId) {
	auto &tasks = m_tasks[groupId];
	if (tasks.empty()) {
		return;
	}

	dispacherContext.group = static_cast<TaskGroup>(groupId);
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

void Dispatcher::executeParallelEvents(const uint8_t groupId) {
	auto &tasks = m_tasks[groupId];
	if (tasks.empty()) {
		return;
	}

	asyncWait(tasks.size(), [groupId, &tasks](size_t i) {
		dispacherContext.type = DispatcherType::AsyncEvent;
		dispacherContext.group = static_cast<TaskGroup>(groupId);
		tasks[i].execute();

		dispacherContext.reset();
	});

	tasks.clear();
}

void Dispatcher::asyncWait(size_t requestSize, std::function<void(size_t i)> &&f) {
	if (requestSize == 0) {
		return;
	}

	// This prevents an async call from running inside another async call.
	if (asyncWaitDisabled) {
		for (uint_fast64_t i = 0; i < requestSize; ++i) {
			f(i);
		}
		return;
	}

	const auto &partitions = generatePartition(requestSize);
	const auto pSize = partitions.size();

	BS::multi_future<void> retFuture;

	if (pSize > 1) {
		asyncWaitDisabled = true;
		const auto min = partitions[1].first;
		const auto max = partitions[partitions.size() - 1].second;
		retFuture = threadPool.submit_loop(min, max, [&f](const unsigned int i) { f(i); });
	}

	const auto &[min, max] = partitions[0];
	for (uint_fast64_t i = min; i < max; ++i) {
		f(i);
	}

	if (pSize > 1) {
		retFuture.wait();
		asyncWaitDisabled = false;
	}
}

void Dispatcher::executeEvents(const TaskGroup startGroup) {
	for (uint_fast8_t groupId = static_cast<uint8_t>(startGroup); groupId < static_cast<uint8_t>(TaskGroup::Last); ++groupId) {
		const auto isWalk = groupId == static_cast<uint8_t>(TaskGroup::Walk);

		if (groupId == static_cast<uint8_t>(TaskGroup::Serial) || isWalk) {
			mergeEvents();
			executeSerialEvents(groupId);
			mergeAsyncEvents();
		} else {
			executeParallelEvents(groupId);
		}
	}
}

void Dispatcher::executeScheduledEvents() {
	auto &threadScheduledTasks = getThreadTask()->scheduledTasks;

	auto it = scheduledTasks.begin();
	while (it != scheduledTasks.end()) {
		const auto &task = *it;
		if (task->getTime() > OTSYS_TIME()) {
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

void Dispatcher::__mergeEvents(const std::array<uint8_t, 2> &groups, const bool mergeScheduledEvents) {
	for (const auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		for (const auto group : groups) {
			auto &threadTasks = thread->tasks[group];
			auto &tasks = m_tasks[group];

			if (threadTasks.size() > tasks.size()) {
				tasks.swap(threadTasks);
			}

			if (!threadTasks.empty()) {
				tasks.insert(tasks.end(), make_move_iterator(threadTasks.begin()), make_move_iterator(threadTasks.end()));
				threadTasks.clear();
			}
		}

		if (mergeScheduledEvents && !thread->scheduledTasks.empty()) {
			scheduledTasks.insert(make_move_iterator(thread->scheduledTasks.begin()), make_move_iterator(thread->scheduledTasks.end()));
			thread->scheduledTasks.clear();
		}
	}
}

// Merge only async thread events with main dispatch events
void Dispatcher::mergeAsyncEvents() {
	static constexpr auto groups = std::to_array({ static_cast<uint8_t>(TaskGroup::WalkParallel), static_cast<uint8_t>(TaskGroup::GenericParallel) });
	__mergeEvents(groups, false);
}

// Merge thread events with main dispatch events
void Dispatcher::mergeEvents() {
	static constexpr auto groups = std::to_array({ static_cast<uint8_t>(TaskGroup::Walk), static_cast<uint8_t>(TaskGroup::Serial) });
	__mergeEvents(groups, true);
	checkPendingTasks();
}

std::chrono::milliseconds Dispatcher::timeUntilNextScheduledTask() const {
	constexpr auto CHRONO_0 = std::chrono::milliseconds(0);
	constexpr auto CHRONO_MILI_MAX = std::chrono::milliseconds::max();

	if (scheduledTasks.empty()) {
		return CHRONO_MILI_MAX;
	}

	const auto &task = *scheduledTasks.begin();
	const auto timeRemaining = std::chrono::milliseconds(task->getTime() - OTSYS_TIME());
	return std::max<std::chrono::milliseconds>(timeRemaining, CHRONO_0);
}

void Dispatcher::addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	thread->tasks[static_cast<uint8_t>(TaskGroup::Serial)].emplace_back(expiresAfterMs, std::move(f), context);
	notify();
}

void Dispatcher::addWalkEvent(std::function<void(void)> &&f, uint32_t expiresAfterMs) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	thread->tasks[static_cast<uint8_t>(TaskGroup::Walk)].emplace_back(expiresAfterMs, std::move(f), this->context().taskName);
	notify();
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	if (shuttingDown) {
		return 0;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);

	auto eventId = scheduledTasksRef
					   .emplace(task->getId(), thread->scheduledTasks.emplace_back(task))
					   .first->first;

	notify();
	return eventId;
}

void Dispatcher::asyncEvent(std::function<void(void)> &&f, TaskGroup group) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	thread->tasks[static_cast<uint8_t>(group)].emplace_back(0, std::move(f), dispacherContext.taskName);
	notify();
}

void Dispatcher::stopEvent(uint64_t eventId) {
	auto it = scheduledTasksRef.find(eventId);
	if (it != scheduledTasksRef.end()) {
		it->second->cancel();
		scheduledTasksRef.erase(it);
	}
}

void Dispatcher::safeCall(std::function<void(void)> &&f) {
	if (dispacherContext.isAsync()) {
		addEvent(std::move(f), dispacherContext.taskName);
	} else {
		f();
	}
}

bool DispatcherContext::isOn() {
	return OTSYS_TIME() != 0;
}
