/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lua/scripts/luascript.hpp"

class ConfigFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L);

private:
	/**
	 * @brief Pushes a potentially rounded floating-point configuration value to Lua.
	 * 
	 * This function retrieves a configuration value based on the specified key,
	 * optionally rounds it to two decimal places to address floating-point precision issues,
	 * and then pushes this value to the Lua stack depending on the rounding flag provided.
	 * 
	 * @param L Pointer to the Lua state.
	 * @param roundFlag A boolean value to determine if rounding should be applied.
	 * @return Returns 1, the number of values pushed onto the Lua stack.
	 * 
	 * @note If roundFlag is true, the function rounds the float to two decimal places,
	 * reducing typical floating-point representation errors.
	 */
	static int luaConfigManagerGetFloat(lua_State* L);
	static int luaConfigManagerGetBoolean(lua_State* L);
	static int luaConfigManagerGetNumber(lua_State* L);
	static int luaConfigManagerGetString(lua_State* L);
};
