/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
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
	static int luaConfigManagerGetFloat(lua_State* L);
	static int luaConfigManagerGetBoolean(lua_State* L);
	static int luaConfigManagerGetNumber(lua_State* L);
	static int luaConfigManagerGetString(lua_State* L);
};
