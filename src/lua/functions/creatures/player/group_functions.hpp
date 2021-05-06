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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_PLAYER_GROUP_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_PLAYER_GROUP_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class GroupFunctions final : LuaScriptInterface {
	public:
			static void init(lua_State* L) {
				registerClass(L, "Group", "", GroupFunctions::luaGroupCreate);
				registerMetaMethod(L, "Group", "__eq", GroupFunctions::luaUserdataCompare);

				registerMethod(L, "Group", "getId", GroupFunctions::luaGroupGetId);
				registerMethod(L, "Group", "getName", GroupFunctions::luaGroupGetName);
				registerMethod(L, "Group", "getFlags", GroupFunctions::luaGroupGetFlags);
				registerMethod(L, "Group", "getCustomFlags", GroupFunctions::luaGroupGetCustomFlags);
				registerMethod(L, "Group", "getAccess", GroupFunctions::luaGroupGetAccess);
				registerMethod(L, "Group", "getMaxDepotItems", GroupFunctions::luaGroupGetMaxDepotItems);
				registerMethod(L, "Group", "getMaxVipEntries", GroupFunctions::luaGroupGetMaxVipEntries);
				registerMethod(L, "Group", "hasFlag", GroupFunctions::luaGroupHasFlag);
				registerMethod(L, "Group", "hasCustomFlag", GroupFunctions::luaGroupHasCustomFlag);
		}

	private:
		static int luaGroupCreate(lua_State* L);

		static int luaGroupGetId(lua_State* L);
		static int luaGroupGetName(lua_State* L);
		static int luaGroupGetFlags(lua_State* L);
		static int luaGroupGetCustomFlags(lua_State* L);
		static int luaGroupGetAccess(lua_State* L);
		static int luaGroupGetMaxDepotItems(lua_State* L);
		static int luaGroupGetMaxVipEntries(lua_State* L);
		static int luaGroupHasFlag(lua_State* L);
		static int luaGroupHasCustomFlag(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_PLAYER_GROUP_FUNCTIONS_HPP_
