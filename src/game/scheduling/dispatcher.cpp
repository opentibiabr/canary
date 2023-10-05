/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"
#include <thread>

#include "lib/di/container.hpp"
#include "lib/thread/thread_pool.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/task.hpp"

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	thread = std::jthread([&](std::stop_token stoken) {
		while (!stoken.stop_requested()) {
			if (taskQueue.state == TaskState::HAS_VALUE) {
				{
					std::scoped_lock l(taskQueue.mutex);
					tasks.insert(tasks.end(), make_move_iterator(taskQueue.list.begin()), make_move_iterator(taskQueue.list.end()));
					taskQueue.list.clear();
					taskQueue.state = TaskState::EMPTY;
				}

				for (const auto &task : tasks) {
					if (task->hasTraceableContext()) {
						g_logger().trace("Executing task {}.", task->getContext());
					} else {
						g_logger().debug("Executing task {}.", task->getContext());
					}

					++dispatcherCycle;

					task->execute();
				}
				tasks.clear();
			}

			std::scoped_lock l(scheduledTaskQueue.mutex);
			const auto currentTime = OTSYS_TIME();
			for (uint_fast64_t i = 0, max = scheduledTaskQueue.list.size(); i < max && !scheduledTaskQueue.list.empty(); ++i) {
				const auto &task = scheduledTaskQueue.list.top();
				if (task->getTime() > currentTime) {
					break;
				}

				task->execute();
				if (task->isCycle()) {
					scheduledTaskQueue.list.emplace(task);
				} else {
					scheduledTaskQueue.map.erase(task->getEventId());
				}

				scheduledTaskQueue.list.pop();
			}

			std::this_thread::sleep_for(std::chrono::milliseconds(50));
		}
	});
}

void Dispatcher::addEvent(std::function<void(void)> f, const std::string &context) {
	std::scoped_lock l(taskQueue.mutex);

	taskQueue.state = TaskState::BUSY;

	taskQueue.list.emplace_back(std::make_unique<Task>(std::move(f), context));

	taskQueue.state = TaskState::HAS_VALUE;
}

uint64_t Dispatcher::scheduleEvent(uint32_t delay, std::function<void(void)> f, std::string context, bool cycle) {
	std::scoped_lock l(scheduledTaskQueue.mutex);

	const auto &task = std::make_shared<Task>(std::move(f), std::move(context), delay, cycle);
	task->setEventId(++lastEventId);

	scheduledTaskQueue.list.emplace(task);
	scheduledTaskQueue.map.emplace(task->getEventId(), task);

	return task->getEventId();
}

void Dispatcher::stopEvent(uint64_t eventId) {
	std::scoped_lock l(scheduledTaskQueue.mutex);

	auto it = scheduledTaskQueue.map.find(eventId);
	if (it == scheduledTaskQueue.map.end()) {
		return;
	}

	it->second->cancel();
	scheduledTaskQueue.map.erase(it);
}
