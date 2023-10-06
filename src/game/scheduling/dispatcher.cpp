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

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	threadPool.addLoad([this] {
		std::unique_lock lock(mutex);
		while (!threadPool.getIoContext().stopped()) {
			signal.wait_until(lock, waitTime);

			busy = true;
			{
				std::scoped_lock l(tasks.mutexList);
				for (const auto &task : tasks.list) {
					if (task->hasTraceableContext()) {
						g_logger().trace("Executing task {}.", task->getContext());
					} else {
						g_logger().debug("Executing task {}.", task->getContext());
					}

					++dispatcherCycle;

					task->execute();
				}
				tasks.list.clear();
			}
			busy = false;

			const auto currentTime = std::chrono::system_clock::now();
			if (currentTime >= waitTime) {
				std::scoped_lock l(scheduledtasks.mutex);
				for (uint_fast64_t i = 0, max = scheduledtasks.list.size(); i < max && !scheduledtasks.list.empty(); ++i) {
					const auto &task = scheduledtasks.list.top();
					if (task->getTime() > currentTime) {
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

			if (!tasks.waitingList.empty()) {
				// Transfer Waiting List data to List
				tasks.list.insert(tasks.list.end(), make_move_iterator(tasks.waitingList.begin()), make_move_iterator(tasks.waitingList.end()));
				tasks.waitingList.clear();

				signal.notify_one();
			}
		}
	});
}

void Dispatcher::addEvent(const std::shared_ptr<Task> &task) {
	if (busy) {
		std::scoped_lock l(tasks.mutexWaitingList);
		tasks.waitingList.emplace_back(task);
		return;
	}

	std::scoped_lock l(tasks.mutexList);

	const bool notify = tasks.list.empty();
	tasks.list.emplace_back(task);

	if (notify) {
		signal.notify_one();
	}
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	std::scoped_lock l(scheduledtasks.mutex);

	task->setEventId(++lastEventId);

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
