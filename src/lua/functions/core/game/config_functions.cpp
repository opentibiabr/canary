/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
