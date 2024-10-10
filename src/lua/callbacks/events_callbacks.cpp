/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/callbacks/events_callbacks.hpp"

#include "lua/callbacks/event_callback.hpp"
#include "game/game.hpp"
#include "lib/di/container.hpp"

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

bool EventsCallbacks::isCallbackRegistered(const std::shared_ptr<EventCallback> &callback) {
	if (g_game().getGameState() == GAME_STATE_STARTUP && !callback->skipDuplicationCheck() && m_callbacks.find(callback->getName()) != m_callbacks.end()) {
		return true;
	}

	return false;
}

void EventsCallbacks::addCallback(const std::shared_ptr<EventCallback> &callback) {
	if (m_callbacks.find(callback->getName()) != m_callbacks.end() && !callback->skipDuplicationCheck()) {
		g_logger().trace("Event callback already registered: {}", callback->getName());
		return;
	}

	g_logger().trace("Registering event callback: {}", callback->getName());

	m_callbacks[callback->getName()] = callback;
}

std::unordered_map<std::string, std::shared_ptr<EventCallback>> EventsCallbacks::getCallbacks() const {
	return m_callbacks;
}

std::unordered_map<std::string, std::shared_ptr<EventCallback>> EventsCallbacks::getCallbacksByType(EventCallback_t type) const {
	std::unordered_map<std::string, std::shared_ptr<EventCallback>> eventCallbacks;
	for (auto [name, callback] : getCallbacks()) {
		if (callback->getType() != type) {
			continue;
		}

		eventCallbacks[name] = callback;
	}

	return eventCallbacks;
}

void EventsCallbacks::clear() {
	m_callbacks.clear();
}
