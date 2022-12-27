/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/scheduling/scheduler.h"

void Scheduler::threadMain()
{
	io_service.run();
}

uint64_t Scheduler::addEvent(SchedulerTask* task)
{
	if (task->getEventId() == 0) {
		task->setEventId(++lastEventId);
	}

	asio::post(io_service, [this, task]() {
		auto res = eventIds.emplace(task->getEventId(), io_service);

		asio::high_resolution_timer& timer = res.first->second;
		timer.expires_from_now(std::chrono::milliseconds(task->getDelay()));
		timer.async_wait([this, task](const std::error_code& error) {
			eventIds.erase(task->getEventId());

			if (error == asio::error::operation_aborted || getState() == THREAD_STATE_TERMINATED) {
				delete task;
				return;
			}

			g_dispatcher().addTask(task);
		});
	});

	return task->getEventId();
}

void Scheduler::stopEvent(uint64_t eventId)
{
	asio::post(io_service, [this, eventId]() {
		auto it = eventIds.find(eventId);
		if (it != eventIds.end()) {
			it->second.cancel();
		}
	});
}

void Scheduler::shutdown() {
	setState(THREAD_STATE_TERMINATED);
	asio::post(io_service, [this]() {
		for (auto& it : eventIds) {
			it.second.cancel();
		}

	io_service.stop();
	});
}

SchedulerTask* createSchedulerTask(uint32_t delay, std::function<void(void)> f) {
	return new SchedulerTask(delay, std::move(f));
}
