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
#include "lua/scripts/luascript.hpp"

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
	 * @brief Adds a new event callback to the list.
	 * @param callback Pointer to the EventCallback object to add.
	 */
	void addCallback(const std::shared_ptr<EventCallback> callback);

	/**
	 * @brief Gets all registered event callbacks.
	 * @return Vector of pointers to EventCallback objects.
	 */
	std::vector<std::shared_ptr<EventCallback>> getCallbacks() const;

	/**
	 * @brief Gets event callbacks by their type.
	 * @param type The type of callbacks to retrieve.
	 * @return Vector of pointers to EventCallback objects of the specified type.
	 */
	std::vector<std::shared_ptr<EventCallback>> getCallbacksByType(EventCallback_t type) const;

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
		for (const auto &callback : getCallbacksByType(eventType)) {
			auto argsCopy = std::make_tuple(args...);
			if (callback && callback->isLoadedCallback()) {
				std::apply(
					[&callback, &callbackFunc](auto &&... args) {
						((*callback).*callbackFunc)(std::forward<decltype(args)>(args)...);
					},
					argsCopy
				);
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
		ReturnValue res = RETURNVALUE_NOERROR;
		for (const auto &callback : getCallbacksByType(eventType)) {
			auto argsCopy = std::make_tuple(args...);
			if (callback && callback->isLoadedCallback()) {
				ReturnValue callbackResult = std::apply(
					[&callback, &callbackFunc](auto &&... args) {
						return ((*callback).*callbackFunc)(std::forward<decltype(args)>(args)...);
					},
					argsCopy
				);
				if (callbackResult != RETURNVALUE_NOERROR) {
					return callbackResult;
				}
			}
		}
		return res;
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

		for (const auto &callback : getCallbacksByType(eventType)) {
			auto argsCopy = std::make_tuple(args...);
			if (callback && callback->isLoadedCallback()) {
				bool callbackResult = std::apply(
					[&callback, &callbackFunc](auto &&... args) {
						return ((*callback).*callbackFunc)(std::forward<decltype(args)>(args)...);
					},
					argsCopy
				);
				allCallbacksSucceeded = allCallbacksSucceeded && callbackResult;
			}
		}
		return allCallbacksSucceeded;
	}

private:
	// Container for storing registered event callbacks.
	std::vector<std::shared_ptr<EventCallback>> m_callbacks;
};

constexpr auto g_callbacks = EventsCallbacks::getInstance;
