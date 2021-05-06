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

#ifndef SRC_LUA_FUNCTIONS_MAP_MAP_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_MAP_MAP_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/map/house_functions.hpp"
#include "lua/functions/map/position_functions.hpp"
#include "lua/functions/map/teleport_functions.hpp"
#include "lua/functions/map/tile_functions.hpp"
#include "lua/functions/map/town_functions.hpp"

class MapFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			HouseFunctions::init(L);
			PositionFunctions::init(L);
			TeleportFunctions::init(L);
			TileFunctions::init(L);
			TownFunctions::init(L);
		}

	private:
	};

#endif  // SRC_LUA_FUNCTIONS_MAP_MAP_FUNCTIONS_HPP_
