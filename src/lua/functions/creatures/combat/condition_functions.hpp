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

class ConditionFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Condition", "", ConditionFunctions::luaConditionCreate);
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
