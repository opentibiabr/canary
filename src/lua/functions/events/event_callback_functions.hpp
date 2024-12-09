/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

/**
 * @class EventCallbackFunctions
 * @brief Provides a set of static functions for working with Event Callbacks in Lua.
 *
 * @details This class encapsulates the Lua binding functions related to event callbacks,
 * allowing for interaction between the C++ codebase and Lua scripts.
 */
class EventCallbackFunctions {
public:
	/**
	 * @brief Initializes the Lua state with the event callback functions.
	 *
	 * This function registers the event callback-related functions with the given Lua state,
	 * making them accessible to Lua scripts.
	 *
	 * @param luaState The Lua state to initialize.
	 */
	static void init(lua_State* luaState);

	/**
	 * @brief Send the load of callbacks to lua
	 * @param luaState The Lua state to initialize.
	 */
	static int luaEventCallbackLoad(lua_State* luaState);

private:
	/**
	 * @brief Creates a new EventCallback object in Lua.
	 *
	 * This function is called from Lua to create a new EventCallback object,
	 * which can then be used to register various event handlers.
	 *
	 * @param luaState The Lua state.
	 * @return Number of return values on the Lua stack.
	 */
	static int luaEventCallbackCreate(lua_State* luaState);

	/**
	 * @brief Sets or gets the type of an EventCallback object in Lua.
	 *
	 * This function is called from Lua to set or get the type of an EventCallback object.
	 *
	 * @param luaState The Lua state.
	 * @return Number of return values on the Lua stack.
	 */
	static int luaEventCallbackType(lua_State* luaState);

	/**
	 * @brief Registers an EventCallback object in Lua.
	 *
	 * This function is called from Lua to register an EventCallback object,
	 * allowing it to be triggered by specific events in the game.
	 *
	 * @param luaState The Lua state.
	 * @return Number of return values on the Lua stack.
	 */
	static int luaEventCallbackRegister(lua_State* luaState);

	/**
	 * @note here end the lua binder functions }
	 */
};
