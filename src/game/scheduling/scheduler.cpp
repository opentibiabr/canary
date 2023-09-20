/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lib/di/container.hpp"
#include "lib/thread/thread_pool.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/scheduler.hpp"
#include "game/scheduling/task.hpp"

Scheduler::Scheduler(ThreadPool &threadPool) :
	threadPool(threadPool) { }

Scheduler &Scheduler::getInstance() {
	return inject<Scheduler>();
}

uint64_t Scheduler::addEvent(uint32_t delay, std::function<void(void)> f, std::string context) {
	return addEvent(std::make_shared<Task>(std::move(f), std::move(context), delay));
}

uint64_t Scheduler::addEvent(const std::shared_ptr<Task> task) {
	if (task->getEventId() == 0) {
		task->setEventId(++lastEventId);
	}

	threadPool.addLoad([this, task]() {
		std::lock_guard lockAdd(threadSafetyMutex);
		auto [item, wasAdded] = eventIds.try_emplace(task->getEventId(), threadPool.getIoContext());

		asio::steady_timer &timer = item->second;
		timer.expires_from_now(std::chrono::milliseconds(task->getDelay()));

		timer.async_wait([this, task](const asio::error_code &error) {
			std::lock_guard lockAsyncCallback(threadSafetyMutex);
			eventIds.erase(task->getEventId());

			if (error == asio::error::operation_aborted || threadPool.getIoContext().stopped()) {
				return;
			}

			if (task->hasTraceableContext()) {
				g_logger().trace("Dispatching scheduled task {}.", task->getContext());
			} else {
				g_logger().debug("Dispatching scheduled task {}.", task->getContext());
			}

			g_dispatcher().addTask(task);
		});
	});

	return task->getEventId();
}

void Scheduler::stopEvent(uint64_t eventId) {
	threadPool.addLoad([this, eventId]() {
		std::lock_guard lockClass(threadSafetyMutex);
		auto it = eventIds.find(eventId);

		if (it != eventIds.end()) {
			it->second.cancel();
		}
	});
}
