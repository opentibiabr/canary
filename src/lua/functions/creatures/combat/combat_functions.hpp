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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_COMBAT_COMBAT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_COMBAT_COMBAT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/creatures/combat/condition_functions.hpp"
#include "lua/functions/creatures/combat/spell_functions.hpp"
#include "lua/functions/creatures/combat/variant_functions.hpp"

class CombatFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Combat", "", CombatFunctions::luaCombatCreate);
			registerMetaMethod(L, "Combat", "__eq", CombatFunctions::luaUserdataCompare);

			registerMethod(L, "Combat", "setParameter", CombatFunctions::luaCombatSetParameter);
			registerMethod(L, "Combat", "setFormula", CombatFunctions::luaCombatSetFormula);

			registerMethod(L, "Combat", "setArea", CombatFunctions::luaCombatSetArea);
			registerMethod(L, "Combat", "addCondition", CombatFunctions::luaCombatSetCondition);
			registerMethod(L, "Combat", "setCallback", CombatFunctions::luaCombatSetCallback);
			registerMethod(L, "Combat", "setOrigin", CombatFunctions::luaCombatSetOrigin);

			registerMethod(L, "Combat", "execute", CombatFunctions::luaCombatExecute);

			ConditionFunctions::init(L);
			SpellFunctions::init(L);
			VariantFunctions::init(L);
		}

	private:
		static int luaCombatCreate(lua_State* L);

		static int luaCombatSetParameter(lua_State* L);
		static int luaCombatSetFormula(lua_State* L);

		static int luaCombatSetArea(lua_State* L);
		static int luaCombatSetCondition(lua_State* L);
		static int luaCombatSetCallback(lua_State* L);
		static int luaCombatSetOrigin(lua_State* L);

		static int luaCombatExecute(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_COMBAT_COMBAT_FUNCTIONS_HPP_
