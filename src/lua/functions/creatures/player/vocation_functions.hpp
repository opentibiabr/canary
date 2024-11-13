/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class VocationFunctions {
public:
	static void init(lua_State* L);

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
