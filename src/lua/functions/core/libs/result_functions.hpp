/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CORE_LIBS_RESULT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_LIBS_RESULT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class ResultFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerTable(L, "result");
			registerMethod(L, "result", "getNumber", ResultFunctions::luaResultGetNumber);
			registerMethod(L, "result", "getString", ResultFunctions::luaResultGetString);
			registerMethod(L, "result", "getStream", ResultFunctions::luaResultGetStream);
			registerMethod(L, "result", "next", ResultFunctions::luaResultNext);
			registerMethod(L, "result", "free", ResultFunctions::luaResultFree);
		}

	private:
		static int luaResultFree(lua_State* L);
		static int luaResultGetNumber(lua_State* L);
		static int luaResultGetStream(lua_State* L);
		static int luaResultGetString(lua_State* L);
		static int luaResultNext(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_LIBS_RESULT_FUNCTIONS_HPP_
