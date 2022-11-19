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

#ifndef SRC_LUA_FUNCTIONS_CORE_GAME_CONFIG_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_GAME_CONFIG_FUNCTIONS_HPP_

#include "declarations.hpp"
#include "lua/scripts/luascript.h"

class ConfigFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L);

	private:
		static int luaConfigManagerGetFloat(lua_State* L);
		static int luaConfigManagerGetBoolean(lua_State* L);
		static int luaConfigManagerGetNumber(lua_State* L);
		static int luaConfigManagerGetString(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_GAME_CONFIG_FUNCTIONS_HPP_
