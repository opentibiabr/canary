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

class InstanceFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L);

private:
	static int luaCreatePlayerInstance(lua_State* L);
	static int luaTeleportToPlayerInstance(lua_State* L);
	static int luaTeleportFromPlayerInstance(lua_State* L);
	static int luaIsPlayerInInstance(lua_State* L);
	static int luaGetPlayerInstanceId(lua_State* L);
	static int luaRemovePlayerInstance(lua_State* L);
	static int luaCleanupPlayerInstances(lua_State* L);
	static int luaTeleportToPartyMemberInstance(lua_State* L);
	static int luaConsumePortal(lua_State* L);
	static int luaGetRemainingPortals(lua_State* L);
	static int luaAddPortalPosition(lua_State* L);
	static int luaGetInstanceById(lua_State* L);
};