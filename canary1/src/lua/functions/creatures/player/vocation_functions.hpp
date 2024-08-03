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

class VocationFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Vocation", "", VocationFunctions::luaVocationCreate);
		registerMetaMethod(L, "Vocation", "__eq", VocationFunctions::luaUserdataCompare);

		registerMethod(L, "Vocation", "getId", VocationFunctions::luaVocationGetId);
		registerMethod(L, "Vocation", "getClientId", VocationFunctions::luaVocationGetClientId);
		registerMethod(L, "Vocation", "getBaseId", VocationFunctions::luaVocationGetBaseId);
		registerMethod(L, "Vocation", "getName", VocationFunctions::luaVocationGetName);
		registerMethod(L, "Vocation", "getDescription", VocationFunctions::luaVocationGetDescription);

		registerMethod(L, "Vocation", "getRequiredSkillTries", VocationFunctions::luaVocationGetRequiredSkillTries);
		registerMethod(L, "Vocation", "getRequiredManaSpent", VocationFunctions::luaVocationGetRequiredManaSpent);

		registerMethod(L, "Vocation", "getCapacityGain", VocationFunctions::luaVocationGetCapacityGain);

		registerMethod(L, "Vocation", "getHealthGain", VocationFunctions::luaVocationGetHealthGain);
		registerMethod(L, "Vocation", "getHealthGainTicks", VocationFunctions::luaVocationGetHealthGainTicks);
		registerMethod(L, "Vocation", "getHealthGainAmount", VocationFunctions::luaVocationGetHealthGainAmount);

		registerMethod(L, "Vocation", "getManaGain", VocationFunctions::luaVocationGetManaGain);
		registerMethod(L, "Vocation", "getManaGainTicks", VocationFunctions::luaVocationGetManaGainTicks);
		registerMethod(L, "Vocation", "getManaGainAmount", VocationFunctions::luaVocationGetManaGainAmount);

		registerMethod(L, "Vocation", "getMaxSoul", VocationFunctions::luaVocationGetMaxSoul);
		registerMethod(L, "Vocation", "getSoulGainTicks", VocationFunctions::luaVocationGetSoulGainTicks);

		registerMethod(L, "Vocation", "getBaseAttackSpeed", VocationFunctions::luaVocationGetBaseAttackSpeed);
		registerMethod(L, "Vocation", "getAttackSpeed", VocationFunctions::luaVocationGetAttackSpeed);
		registerMethod(L, "Vocation", "getBaseSpeed", VocationFunctions::luaVocationGetBaseSpeed);

		registerMethod(L, "Vocation", "getDemotion", VocationFunctions::luaVocationGetDemotion);
		registerMethod(L, "Vocation", "getPromotion", VocationFunctions::luaVocationGetPromotion);
	}

private:
	static int luaVocationCreate(lua_State* L);

	static int luaVocationGetId(lua_State* L);
	static int luaVocationGetClientId(lua_State* L);
	static int luaVocationGetBaseId(lua_State* L);
	static int luaVocationGetName(lua_State* L);
	static int luaVocationGetDescription(lua_State* L);

	static int luaVocationGetRequiredSkillTries(lua_State* L);
	static int luaVocationGetRequiredManaSpent(lua_State* L);

	static int luaVocationGetCapacityGain(lua_State* L);

	static int luaVocationGetHealthGain(lua_State* L);
	static int luaVocationGetHealthGainTicks(lua_State* L);
	static int luaVocationGetHealthGainAmount(lua_State* L);

	static int luaVocationGetManaGain(lua_State* L);
	static int luaVocationGetManaGainTicks(lua_State* L);
	static int luaVocationGetManaGainAmount(lua_State* L);

	static int luaVocationGetMaxSoul(lua_State* L);
	static int luaVocationGetSoulGainTicks(lua_State* L);

	static int luaVocationGetBaseAttackSpeed(lua_State* L);
	static int luaVocationGetAttackSpeed(lua_State* L);
	static int luaVocationGetBaseSpeed(lua_State* L);

	static int luaVocationGetDemotion(lua_State* L);
	static int luaVocationGetPromotion(lua_State* L);
};
