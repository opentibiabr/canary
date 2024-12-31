/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/callbacks/callbacks_definitions.hpp"
#include "lua/callbacks/event_callback.hpp"

class EventCallback;

/**
 * @class EventsCallbacks
 * @brief Manages event callbacks within the application.
 *
 * @details This class serves as a central manager for event callbacks, allowing registration,
 * retrieval, execution, and clearing of callbacks. It provides a way to bind specific
 * events with corresponding actions.
 */

class EventsCallbacks {
public:
	/**
	 * @brief Default constructor.
	 */
	EventsCallbacks();
	/**
	 * @brief Destructor.
	 */
	~EventsCallbacks();

	// Delete copy constructor and assignment operator
	EventsCallbacks(const EventsCallbacks &) = delete;
	EventsCallbacks &operator=(const EventsCallbacks &) = delete;

	/**
	 * @brief Retrieves the singleton instance of the EventsCallbacks class.
	 * @return Reference to the singleton instance.
	 */
	static EventsCallbacks &getInstance();

	/**
	 * @brief Checks if an event callback is already registered.
	 *
	 * @details Determines if the game state is at startup and if a callback with the same name already exists.
	 * @details If both conditions are met, logs an error and indicates the callback is already registered.
	 *
	 * @param callback Shared pointer to the event callback being checked.
	 * @return True if the callback already exists during the game startup state, otherwise false.
	 */
	bool isCallbackRegistered(const std::shared_ptr<EventCallback> &callback);

	/**
	 * @brief Adds a new event callback to the list.
	 * @param callback Pointer to the EventCallback object to add.
	 */
	void addCallback(const std::shared_ptr<EventCallback> &callback);

	/**
	 * @brief Clears all registered event callbacks.
	 */
	void clear();

	/**
	 * @brief Executes the specified event callback.
	 * @param eventType The type of event to trigger.
	 * @param callbackFunc Function pointer to the callback method.
	 * @param args Variadic arguments to pass to the callback function.
	 */
	template <typename CallbackFunc, typename... Args>
	void executeCallback(EventCallback_t eventType, CallbackFunc callbackFunc, Args &&... args) {
		auto it = m_callbacks.find(eventType);
		if (it == m_callbacks.end()) {
			return;
		}

		for (const auto &entry : it->second) {
			if (entry.callback && entry.callback->isLoadedScriptId()) {
				std::invoke(callbackFunc, *entry.callback, args...);
			}
		}
	}

	/**
	 * @brief Checks if all registered callbacks of the specified event type succeed.
	 * @param eventType The type of event to check.
	 * @param callbackFunc Function pointer to the callback method.
	 * @param args Variadic arguments to pass to the callback function.
	 * @return ReturnValue enum.
	 */
	template <typename CallbackFunc, typename... Args>
	ReturnValue checkCallbackWithReturnValue(EventCallback_t eventType, CallbackFunc callbackFunc, Args &&... args) {
		auto it = m_callbacks.find(eventType);
		if (it == m_callbacks.end()) {
			return RETURNVALUE_NOERROR;
		}

		for (const auto &entry : it->second) {
			if (entry.callback && entry.callback->isLoadedScriptId()) {
				ReturnValue callbackResult = std::invoke(callbackFunc, *entry.callback, args...);
				if (callbackResult != RETURNVALUE_NOERROR) {
					return callbackResult;
				}
			}
		}
		return RETURNVALUE_NOERROR;
	}

	/**
	 * @brief Checks if all registered callbacks of the specified event type succeed.
	 * @param eventType The type of event to check.
	 * @param callbackFunc Function pointer to the callback method.
	 * @param args Variadic arguments to pass to the callback function.
	 * @return True if all callbacks succeed, false otherwise.
	 */
	template <typename CallbackFunc, typename... Args>
	bool checkCallback(EventCallback_t eventType, CallbackFunc callbackFunc, Args &&... args) {
		bool allCallbacksSucceeded = true;
		auto it = m_callbacks.find(eventType);
		if (it == m_callbacks.end()) {
			return allCallbacksSucceeded;
		}

		for (const auto &entry : it->second) {
			if (entry.callback && entry.callback->isLoadedScriptId()) {
				bool callbackResult = std::invoke(callbackFunc, *entry.callback, args...);
				allCallbacksSucceeded &= callbackResult;
			}
		}
		return allCallbacksSucceeded;
	}

private:
	struct EventCallbackEntry {
		std::string name;
		std::shared_ptr<EventCallback> callback;
	};

	// Container for storing registered event callbacks.
	phmap::flat_hash_map<EventCallback_t, std::vector<EventCallbackEntry>> m_callbacks;
};

constexpr auto g_callbacks = EventsCallbacks::getInstance;
