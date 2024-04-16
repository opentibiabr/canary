/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"
#include "lua/functions/creatures/combat/condition_functions.hpp"
#include "lua/functions/creatures/combat/spell_functions.hpp"
#include "lua/functions/creatures/combat/variant_functions.hpp"

class CombatFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Combat", "", CombatFunctions::luaCombatCreate);
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
