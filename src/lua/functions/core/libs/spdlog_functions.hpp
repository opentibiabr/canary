/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CORE_LIBS_SPDLOG_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_LIBS_SPDLOG_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class SpdlogFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerTable(L, "Spdlog");
			registerMethod(L, "Spdlog", "info", SpdlogFunctions::luaSpdlogInfo);
			registerMethod(L, "Spdlog", "warn", SpdlogFunctions::luaSpdlogWarn);
			registerMethod(L, "Spdlog", "error", SpdlogFunctions::luaSpdlogError);
			registerMethod(L, "Spdlog", "debug", SpdlogFunctions::luaSpdlogDebug);
		}

	private:
		static int luaSpdlogDebug(lua_State* L);
		static int luaSpdlogError(lua_State* L);
		static int luaSpdlogInfo(lua_State* L);
		static int luaSpdlogWarn(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_LIBS_SPDLOG_FUNCTIONS_HPP_
