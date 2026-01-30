/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/callbacks/callbacks_definitions.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "items/items_definitions.hpp"

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

	template <typename... Args>
	[[nodiscard]] bool checkCallback(EventCallback_t eventType, Args &&... args) {
		auto it = m_callbacks.find(eventType);
		if (it == m_callbacks.end()) {
			return true;
		}

		for (const auto &entry : it->second) {
			if (entry.callback && entry.callback->canExecute()) {
				if (!entry.callback->execute(std::forward<Args>(args)...)) {
					return false;
				}
			}
		}
		return true;
	}

	template <typename... Args>
	void executeCallback(EventCallback_t eventType, Args &&... args) {
		auto it = m_callbacks.find(eventType);
		if (it == m_callbacks.end()) {
			return;
		}

		for (const auto &entry : it->second) {
			if (entry.callback && entry.callback->canExecute()) {
				(void)entry.callback->execute(std::forward<Args>(args)...);
			}
		}
	}

	template <typename... Args>
	ReturnValue dispatchReturnValue(EventCallback_t eventType, Args &&... args) {
		auto it = m_callbacks.find(eventType);
		if (it == m_callbacks.end()) {
			return RETURNVALUE_NOERROR;
		}

		for (const auto &entry : it->second) {
			if (entry.callback && entry.callback->canExecute()) {
				if (!entry.callback->execute(std::forward<Args>(args)...)) {
					return RETURNVALUE_NOTPOSSIBLE;
				}
			}
		}
		return RETURNVALUE_NOERROR;
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
