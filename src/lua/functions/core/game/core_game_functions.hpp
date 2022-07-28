/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CORE_GAME_CORE_GAME_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_GAME_CORE_GAME_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/core/game/config_functions.hpp"
#include "lua/functions/core/game/game_functions.hpp"
#include "lua/functions/core/game/global_functions.hpp"
#include "lua/functions/core/game/lua_enums.hpp"
#include "lua/functions/core/game/modal_window_functions.hpp"

class CoreGameFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			ConfigFunctions::init(L);
			GameFunctions::init(L);
			GlobalFunctions::init(L);
			LuaEnums::init(L);
			ModalWindowFunctions::init(L);
		}

	private:
	};

#endif  // SRC_LUA_FUNCTIONS_CORE_GAME_CORE_GAME_FUNCTIONS_HPP_
