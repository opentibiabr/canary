/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "lua/functions/core/game/config_functions.hpp"


int ConfigFunctions::luaConfigManagerGetString(lua_State* L) {
	pushString(L, g_configManager().getString(getNumber<stringConfig_t>(L, -1)));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetNumber(lua_State* L) {
	lua_pushnumber(L, g_configManager().getNumber(getNumber<integerConfig_t>(L, -1)));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetBoolean(lua_State* L) {
	pushBoolean(L, g_configManager().getBoolean(getNumber<booleanConfig_t>(L, -1)));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetFloat(lua_State* L) {
	lua_pushnumber(L, g_configManager().getFloat(getNumber<floatingConfig_t>(L, -1)));
	return 1;
}
