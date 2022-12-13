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

#ifndef SRC_LUA_FUNCTIONS_MAP_POSITION_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_MAP_POSITION_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class PositionFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Position", "", PositionFunctions::luaPositionCreate);
			registerMetaMethod(L, "Position", "__add", PositionFunctions::luaPositionAdd);
			registerMetaMethod(L, "Position", "__sub", PositionFunctions::luaPositionSub);
			registerMetaMethod(L, "Position", "__eq", PositionFunctions::luaPositionCompare);

			registerMethod(L, "Position", "getDistance", PositionFunctions::luaPositionGetDistance);
			registerMethod(L, "Position", "getPathTo", PositionFunctions::luaPositionGetPathTo);
			registerMethod(L, "Position", "isSightClear", PositionFunctions::luaPositionIsSightClear);

			registerMethod(L, "Position", "sendMagicEffect", PositionFunctions::luaPositionSendMagicEffect);
			registerMethod(L, "Position", "sendDistanceEffect", PositionFunctions::luaPositionSendDistanceEffect);

			registerMethod(L, "Position", "sendSingleSoundEffect", PositionFunctions::luaPositionSendSingleSoundEffect);
			registerMethod(L, "Position", "sendDoubleSoundEffect", PositionFunctions::luaPositionSendDoubleSoundEffect);
		}

	private:
		static int luaPositionCreate(lua_State* L);
		static int luaPositionAdd(lua_State* L);
		static int luaPositionSub(lua_State* L);
		static int luaPositionCompare(lua_State* L);

		static int luaPositionGetDistance(lua_State* L);
		static int luaPositionGetPathTo(lua_State* L);
		static int luaPositionIsSightClear(lua_State* L);

		static int luaPositionSendMagicEffect(lua_State* L);
		static int luaPositionSendDistanceEffect(lua_State* L);

		static int luaPositionSendSingleSoundEffect(lua_State* L);
		static int luaPositionSendDoubleSoundEffect(lua_State* L);
};

#endif
