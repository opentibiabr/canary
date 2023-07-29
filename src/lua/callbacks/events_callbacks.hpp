/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_LUA_CALLBACKS_EVENTS_CALLBACKS_HPP_
#define SRC_LUA_CALLBACKS_EVENTS_CALLBACKS_HPP_

#include "lua/callbacks/callbacks_definitions.hpp"
#include "lua/scripts/luascript.h"

class EventCallback;

/**
 * @class EventsCallbacks
 * @brief Class managing all event callbacks.
 *
 * @note This class is a singleton that holds all registered event callbacks.
 * @details It provides functions to add new callbacks and retrieve callbacks by type.
 */

class EventsCallbacks {
	public:
		EventsCallbacks();
		~EventsCallbacks();

		EventsCallbacks(const EventsCallbacks &) = delete;
		EventsCallbacks &operator=(const EventsCallbacks &) = delete;

		static EventsCallbacks &getInstance();

		void addCallback(EventCallback* callback);

		std::vector<EventCallback*> getCallbacks();

		std::vector<EventCallback*> getCallbacksByType(EventCallback_t type);

		void clear();

		template <typename CallbackFunc, typename... Args>
		void executeCallback(EventCallback_t eventType, CallbackFunc callbackFunc, Args &&... args) {
			for (auto callback : getCallbacksByType(eventType)) {
				if (callback->isLoadedCallback()) {
					(callback->*callbackFunc)(std::forward<Args>(args)...);
				}
			}
		}
		template <typename CallbackFunc, typename... Args>
		bool checkCallback(EventCallback_t eventType, CallbackFunc callbackFunc, Args... args) {
			bool allCallbacksSucceeded = true;

			for (auto callback : getCallbacksByType(eventType)) {
				if (callback->isLoadedCallback()) {
					bool callbackResult = (callback->*callbackFunc)(std::forward<Args>(args)...);
					allCallbacksSucceeded = allCallbacksSucceeded && callbackResult;
				}
			}
			return allCallbacksSucceeded;
		}

	private:
		std::vector<EventCallback*> m_callbacks;
};

constexpr auto g_callbacks = &EventsCallbacks::getInstance;

#endif // SRC_LUA_CALLBACKS_EVENTS_CALLBACKS_HPP_
