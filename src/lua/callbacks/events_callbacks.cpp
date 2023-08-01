/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/callbacks/events_callbacks.hpp"

#include "lua/callbacks/event_callback.hpp"

/**
 * @class EventsCallbacks
 * @brief Class managing all event callbacks.
 *
 * @note This class is a singleton that holds all registered event callbacks.
 * @details It provides functions to add new callbacks and retrieve callbacks by type.
 */
EventsCallbacks::EventsCallbacks() = default;

EventsCallbacks::~EventsCallbacks() = default;

EventsCallbacks &EventsCallbacks::getInstance() {
	// Guaranteed to be destroyed
	static EventsCallbacks instance;
	// Instantiated on first use
	return instance;
}

void EventsCallbacks::addCallback(EventCallback* callback) {
	m_callbacks.push_back(callback);
}

std::vector<EventCallback*> EventsCallbacks::getCallbacks() const {
	return m_callbacks;
}

std::vector<EventCallback*> EventsCallbacks::getCallbacksByType(EventCallback_t type) const {
	std::vector<EventCallback*> eventCallbacks;
	for (auto callback : getCallbacks()) {
		if (callback->getType() != type) {
			continue;
		}

		eventCallbacks.push_back(callback);
	}

	return eventCallbacks;
}

void EventsCallbacks::clear() {
	m_callbacks.clear();
}
