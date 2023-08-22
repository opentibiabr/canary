/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class GroupFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerClass(L, "Group", "", GroupFunctions::luaGroupCreate);
		registerMetaMethod(L, "Group", "__eq", GroupFunctions::luaUserdataCompare);

		registerMethod(L, "Group", "getId", GroupFunctions::luaGroupGetId);
		registerMethod(L, "Group", "getName", GroupFunctions::luaGroupGetName);
		registerMethod(L, "Group", "getFlags", GroupFunctions::luaGroupGetFlags);
		registerMethod(L, "Group", "getAccess", GroupFunctions::luaGroupGetAccess);
		registerMethod(L, "Group", "getMaxDepotItems", GroupFunctions::luaGroupGetMaxDepotItems);
		registerMethod(L, "Group", "getMaxVipEntries", GroupFunctions::luaGroupGetMaxVipEntries);
		registerMethod(L, "Group", "hasFlag", GroupFunctions::luaGroupHasFlag);
	}

private:
	static int luaGroupCreate(lua_State* L);

	static int luaGroupGetId(lua_State* L);
	static int luaGroupGetName(lua_State* L);
	static int luaGroupGetFlags(lua_State* L);
	static int luaGroupGetAccess(lua_State* L);
	static int luaGroupGetMaxDepotItems(lua_State* L);
	static int luaGroupGetMaxVipEntries(lua_State* L);
	static int luaGroupHasFlag(lua_State* L);
};
