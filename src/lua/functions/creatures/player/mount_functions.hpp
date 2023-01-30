/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CREATURES_PLAYER_MOUNT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_PLAYER_MOUNT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class MountFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Mount", "", MountFunctions::luaCreateMount);
			registerMetaMethod(L, "Mount", "__eq", MountFunctions::luaUserdataCompare);

			registerMethod(L, "Mount", "getName", MountFunctions::luaMountGetName);
			registerMethod(L, "Mount", "getId", MountFunctions::luaMountGetId);
			registerMethod(L, "Mount", "getClientId", MountFunctions::luaMountGetClientId);
			registerMethod(L, "Mount", "getSpeed", MountFunctions::luaMountGetSpeed);
		}

	private:
		static int luaCreateMount(lua_State* L);
		static int luaMountGetName(lua_State* L);
		static int luaMountGetId(lua_State* L);
		static int luaMountGetClientId(lua_State* L);
		static int luaMountGetSpeed(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_PLAYER_MOUNT_FUNCTIONS_HPP_
