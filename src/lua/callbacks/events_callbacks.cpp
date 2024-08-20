/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
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
	return inject<EventsCallbacks>();
}

void EventsCallbacks::addCallback(const std::shared_ptr<EventCallback> callback) {
	const auto &it = m_callbacks.find(callback->getType());
	(it == m_callbacks.end() ? m_callbacks.emplace(callback->getType(), std::vector<std::shared_ptr<EventCallback>>()).first : it)->second.emplace_back(callback);
}

void EventsCallbacks::clear() {
	m_callbacks.clear();
}
