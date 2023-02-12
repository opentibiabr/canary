/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CORE_LIBS_CORE_LIBS_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_LIBS_CORE_LIBS_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/core/libs/bit_functions.hpp"
#include "lua/functions/core/libs/db_functions.hpp"
#include "lua/functions/core/libs/result_functions.hpp"
#include "lua/functions/core/libs/spdlog_functions.hpp"

class CoreLibsFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			BitFunctions::init(L);
			DBFunctions::init(L);
			ResultFunctions::init(L);
			SpdlogFunctions::init(L);
		}

	private:
	};

#endif  // SRC_LUA_FUNCTIONS_CORE_LIBS_CORE_LIBS_FUNCTIONS_HPP_
