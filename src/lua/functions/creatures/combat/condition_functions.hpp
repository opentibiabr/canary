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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_COMBAT_CONDITION_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_COMBAT_CONDITION_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class ConditionFunctions final : LuaScriptInterface {
	public:
			static void init(lua_State* L) {
				registerClass(L, "Condition", "", ConditionFunctions::luaConditionCreate);
				registerMetaMethod(L, "Condition", "__eq", ConditionFunctions::luaUserdataCompare);
				registerMetaMethod(L, "Condition", "__gc", ConditionFunctions::luaConditionDelete);
				registerMethod(L, "Condition", "delete", ConditionFunctions::luaConditionDelete);

				registerMethod(L, "Condition", "getId", ConditionFunctions::luaConditionGetId);
				registerMethod(L, "Condition", "getSubId", ConditionFunctions::luaConditionGetSubId);
				registerMethod(L, "Condition", "getType", ConditionFunctions::luaConditionGetType);
				registerMethod(L, "Condition", "getIcons", ConditionFunctions::luaConditionGetIcons);
				registerMethod(L, "Condition", "getEndTime", ConditionFunctions::luaConditionGetEndTime);

				registerMethod(L, "Condition", "clone", ConditionFunctions::luaConditionClone);

				registerMethod(L, "Condition", "getTicks", ConditionFunctions::luaConditionGetTicks);
				registerMethod(L, "Condition", "setTicks", ConditionFunctions::luaConditionSetTicks);

				registerMethod(L, "Condition", "setParameter", ConditionFunctions::luaConditionSetParameter);
				registerMethod(L, "Condition", "setFormula", ConditionFunctions::luaConditionSetFormula);
				registerMethod(L, "Condition", "setOutfit", ConditionFunctions::luaConditionSetOutfit);

				registerMethod(L, "Condition", "addDamage", ConditionFunctions::luaConditionAddDamage);
		}

	private:
		static int luaConditionCreate(lua_State* L);
		static int luaConditionDelete(lua_State* L);

		static int luaConditionGetId(lua_State* L);
		static int luaConditionGetSubId(lua_State* L);
		static int luaConditionGetType(lua_State* L);
		static int luaConditionGetIcons(lua_State* L);
		static int luaConditionGetEndTime(lua_State* L);

		static int luaConditionClone(lua_State* L);

		static int luaConditionGetTicks(lua_State* L);
		static int luaConditionSetTicks(lua_State* L);

		static int luaConditionSetParameter(lua_State* L);
		static int luaConditionSetFormula(lua_State* L);
		static int luaConditionSetOutfit(lua_State* L);

		static int luaConditionAddDamage(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_COMBAT_CONDITION_FUNCTIONS_HPP_
