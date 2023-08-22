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
#include "lua/functions/core/game/config_functions.hpp"
#include "lua/functions/core/game/game_functions.hpp"
#include "lua/functions/core/game/bank_functions.hpp"
#include "lua/functions/core/game/global_functions.hpp"
#include "lua/functions/core/game/lua_enums.hpp"
#include "lua/functions/core/game/modal_window_functions.hpp"

class CoreGameFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		ConfigFunctions::init(L);
		GameFunctions::init(L);
		BankFunctions::init(L);
		GlobalFunctions::init(L);
		LuaEnums::init(L);
		ModalWindowFunctions::init(L);
	}

private:
};
