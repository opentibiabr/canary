/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class ConditionFunctions {
public:
	static void init(lua_State* L);

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
