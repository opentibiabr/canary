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
#include "game/scheduling/scheduler.h"
#include "game/scheduling/task.hpp"

Scheduler &Scheduler::getInstance() {
	return inject<Scheduler>();
}

uint64_t Scheduler::addEvent(uint32_t delay, std::function<void(void)> f) {
	return addEvent(std::make_shared<Task>(std::move(f), delay));
}

uint64_t Scheduler::addEvent(const std::shared_ptr<Task> &task) {
	if (task->getEventId() == 0) {
		task->setEventId(++lastEventId);
	}

	addLoad([this, task]() {
		auto res = eventIds.emplace(task->getEventId(), asio::steady_timer(io_service));

		asio::steady_timer &timer = res.first->second;
		timer.expires_from_now(std::chrono::milliseconds(task->getDelay()));

		timer.async_wait([this, task](const asio::error_code &error) {
			eventIds.erase(task->getEventId());

			if (error == asio::error::operation_aborted || io_service.stopped()) {
				return;
			}

			g_dispatcher().addTask(task);
		});
	});

	return task->getEventId();
}

void Scheduler::stopEvent(uint64_t eventId) {
	addLoad([this, eventId]() {
		auto it = eventIds.find(eventId);

		if (it != eventIds.end()) {
			it->second.cancel();
		}
	});
}
