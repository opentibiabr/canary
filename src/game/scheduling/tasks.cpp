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

void Dispatcher::threadMain() {
	io_service.run();
	g_database.disconnect();
}

void Dispatcher::addTask(std::function<void(void)> functor) {
	// Adds a task to the Dispatcher to be executed asynchronously.
	// functor The functor representing the task to be added.
	// Increments the Dispatcher's cycle counter
	// Adds the task to the io_service object to be executed asynchronously
	// Executes the functor
	// Handles the exception thrown by the functor or the io_service object
	try {
		++dispatcherCycle;
		asio::post(io_service, [f = std::move(functor)]() mutable {
			f();
		});
	} catch (const std::exception &ex) {
		SPDLOG_ERROR("Error adding task to Dispatcher: {}: {}", __FUNCTION__, ex.what());
	}
}

uint64_t Dispatcher::addEvent(uint32_t delay, std::function<void(void)> functor) {
	// Adds an event to the Dispatcher to be executed asynchronously after a specified delay.
	// delay The delay in milliseconds before the event should be executed.
	// functor The functor representing the event to be added.
	// The ID of the added event. Returns 0 if the Dispatcher is in the TERMINATED state.
	// Execute the functor
	try {
		if (getState() == THREAD_STATE_TERMINATED) {
			return 0;
		}

		++lastEventId;
		uint64_t eventId = lastEventId;
		auto [iter, success] = eventIds.emplace(std::piecewise_construct, std::forward_as_tuple(eventId), std::forward_as_tuple(io_service));

		if (success) {
			asio::high_resolution_timer &timer = iter->second;
			timer.expires_from_now(std::chrono::milliseconds(delay));
			timer.async_wait([this, eventId, f = std::move(functor)](const std::error_code &error) {
				eventIds.erase(eventId);

				if (error == asio::error::operation_aborted || getState() == THREAD_STATE_TERMINATED) {
					return;
				}

				++dispatcherCycle;
				f();
			});
		}
		return eventId;
	} catch (const std::exception &ex) {
		SPDLOG_ERROR("Error adding event to Dispatcher:{}: {}", __FUNCTION__, ex.what());
		return 0;
	}
}

void Dispatcher::stopEvent(uint64_t eventId) {
	// Stops an event with the specified ID from being executed.
	// Find the event in the eventIds map
	// Cancel the event
	if (auto it = eventIds.find(eventId); it != eventIds.end()) {
		it->second.cancel();
	}
}

void Dispatcher::shutdown() {
	// Shut down the Dispatcher and cancel all pending events.
	// std::system_error If an error occurs while canceling the events or resetting the work object.
	// Set the state to terminated and cancel all pending events
	// Cancel all pending events
	// Reset the work object
	setState(THREAD_STATE_TERMINATED);
	asio::post(io_service, [this]() {
		for (auto &[eventId, timer] : eventIds) {
			try {
				timer.cancel();
			} catch (const std::system_error &ex) {
				SPDLOG_ERROR("Error canceling event: {}: {}", __FUNCTION__, ex.what());
			}
		}

		try {
			work.reset();
		} catch (const std::system_error &ex) {
			SPDLOG_ERROR("Error resetting work object: {}: {}", __FUNCTION__, ex.what());
		}
	});
}
