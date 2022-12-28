/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.h"
#include "game/scheduling/tasks.h"

void Dispatcher::threadMain()
{
	io_service.run();
	g_database.disconnect();
}

void Dispatcher::addTask(std::function<void (void)> functor)
{
	asio::post(io_service, [this, functor]() {
		++dispatcherCycle;

		// execute it
		(functor)();
	});
}

uint64_t Dispatcher::addEvent(uint32_t delay, std::function<void (void)> functor)
{
	if (getState() == THREAD_STATE_TERMINATED) {
		return 0;
	}

	uint64_t eventId = ++lastEventId;
	auto res = eventIds.emplace(std::piecewise_construct, std::forward_as_tuple(eventId), std::forward_as_tuple(io_service));

	asio::high_resolution_timer& timer = res.first->second;
	timer.expires_from_now(std::chrono::milliseconds(delay));
	#ifdef __cpp_generic_lambdas
	timer.async_wait([this, eventId, f = std::move(functor)](const std::error_code& error) {
	#else
	timer.async_wait([this, eventId, functor](const const std::error_code& error) {
	#endif
		eventIds.erase(eventId);

		if (error == asio::error::operation_aborted || getState() == THREAD_STATE_TERMINATED) {
			return;
		}

		// execute it
		++dispatcherCycle;
		#ifdef __cpp_generic_lambdas
		(f)();
		#else
		(functor)();
		#endif
	});

	return eventId;
}

void Dispatcher::stopEvent(uint64_t eventId)
{
	auto it = eventIds.find(eventId);
	if (it != eventIds.end()) {
		it->second.cancel();
	}
}

void Dispatcher::shutdown()
{
	setState(THREAD_STATE_TERMINATED);
	asio::post(io_service, [this]() {
		for (auto& it : eventIds) {
			it.second.cancel();
		}

		work.reset();
	});
}
