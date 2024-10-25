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
	auto it = m_callbacks.find(callback->getType());

	if (it == m_callbacks.end()) {
		return false;
	}

	const auto &callbacks = it->second;

	auto isSameCallbackName = [&callback](const auto &pair) {
		return pair.name == callback->getName();
	};

	auto found = std::ranges::find_if(callbacks, isSameCallbackName);

	return (found != callbacks.end() && !callback->skipDuplicationCheck());
}

void EventsCallbacks::addCallback(const std::shared_ptr<EventCallback> &callback) {
	auto &callbackList = m_callbacks[callback->getType()];

	for (const auto &entry : callbackList) {
		if (entry.name == callback->getName() && !callback->skipDuplicationCheck()) {
			g_logger().trace("Event callback already registered: {}", callback->getName());
			return;
		}
	}

	g_logger().trace("Registering event callback: {}", callback->getName());
	callbackList.emplace_back(EventCallbackEntry { callback->getName(), callback });
}

void EventsCallbacks::clear() {
	m_callbacks.clear();
}
