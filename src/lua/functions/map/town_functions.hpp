/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_MAP_TOWN_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_MAP_TOWN_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class TownFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Town", "", TownFunctions::luaTownCreate);
			registerMetaMethod(L, "Town", "__eq", TownFunctions::luaUserdataCompare);

			registerMethod(L, "Town", "getId", TownFunctions::luaTownGetId);
			registerMethod(L, "Town", "getName", TownFunctions::luaTownGetName);
			registerMethod(L, "Town", "getTemplePosition", TownFunctions::luaTownGetTemplePosition);
		}

	private:
		static int luaTownCreate(lua_State* L);

		static int luaTownGetId(lua_State* L);
		static int luaTownGetName(lua_State* L);
		static int luaTownGetTemplePosition(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_MAP_TOWN_FUNCTIONS_HPP_
