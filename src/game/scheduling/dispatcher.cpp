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

std::chrono::system_clock::time_point Task::TIME_NOW = SYSTEM_TIME_ZERO;

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	Task::TIME_NOW = std::chrono::system_clock::now();

	threadPool.addLoad([this] {
		std::unique_lock lock(mutex);
		while (!threadPool.getIoContext().stopped()) {
			signal.wait_until(lock, waitTime);

			Task::TIME_NOW = std::chrono::system_clock::now();

			busy = true;
			{
				std::scoped_lock l(tasks.mutexList);
				for (const auto &task : tasks.list) {
					if (task.hasTraceableContext()) {
						g_logger().trace("Executing task {}.", task.getContext());
					} else {
						g_logger().debug("Executing task {}.", task.getContext());
					}

					if (!task.hasExpired()) {
						++dispatcherCycle;
						task.execute();
					}
				}
				tasks.list.clear();
			}
			busy = false;

			if (Task::TIME_NOW >= waitTime) {
				std::scoped_lock l(scheduledtasks.mutex);
				for (uint_fast64_t i = 0, max = scheduledtasks.list.size(); i < max && !scheduledtasks.list.empty(); ++i) {
					const auto &task = scheduledtasks.list.top();
					if (task->getTime() > Task::TIME_NOW) {
						waitFor(task);
						break;
					}

					if (task->hasTraceableContext()) {
						g_logger().trace("Executing task {}.", task->getContext());
					} else {
						g_logger().debug("Executing task {}.", task->getContext());
					}

					task->execute();

					if (!task->isCanceled() && task->isCycle()) {
						scheduledtasks.list.emplace(task);
					} else {
						scheduledtasks.map.erase(task->getEventId());
					}

					scheduledtasks.list.pop();
				}
			}

			{
				std::scoped_lock l(tasks.mutexList, tasks.mutexWaitingList);
				if (!tasks.waitingList.empty()) {
					// Transfer Waiting List data to List
					tasks.list.insert(tasks.list.end(), make_move_iterator(tasks.waitingList.begin()), make_move_iterator(tasks.waitingList.end()));
					tasks.waitingList.clear();

					signal.notify_one();
				}
			}
		}
	});
}

void Dispatcher::addEvent(std::function<void(void)> &&f, std::string &&context, uint32_t expiresAfterMs) {
	if (busy) {
		std::scoped_lock l(tasks.mutexWaitingList);
		tasks.waitingList.emplace_back(expiresAfterMs, f, context);
		return;
	}

	std::scoped_lock l(tasks.mutexList);

	const bool notify = tasks.list.empty();

	tasks.list.emplace_back(expiresAfterMs, f, context);

	if (notify) {
		signal.notify_one();
	}
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	std::scoped_lock l(scheduledtasks.mutex);

	if (task->getEventId() == 0) {
		if (++lastEventId == 0) {
			lastEventId = 1;
		}

		task->setEventId(lastEventId);
	}

	scheduledtasks.list.emplace(task);
	scheduledtasks.map.emplace(task->getEventId(), task);

	waitFor(scheduledtasks.list.top());

	return task->getEventId();
}

uint64_t Dispatcher::scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string &&context, bool cycle) {
	const auto &task = std::make_shared<Task>(std::move(f), std::move(context), delay, cycle);
	return scheduleEvent(task);
}

void Dispatcher::stopEvent(uint64_t eventId) {
	std::scoped_lock l(scheduledtasks.mutex);

	auto it = scheduledtasks.map.find(eventId);
	if (it == scheduledtasks.map.end()) {
		return;
	}

	it->second->cancel();
	scheduledtasks.map.erase(it);
}
