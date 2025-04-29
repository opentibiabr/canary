/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class GroupFunctions {
public:
	static void init(lua_State* L);

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
