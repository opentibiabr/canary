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
#include "lua/functions/core/network/network_message_functions.hpp"
#include "lua/functions/core/network/webhook_functions.hpp"

class CoreNetworkFunctions final : LuaScriptInterface {
public:
	explicit CoreNetworkFunctions(lua_State* L) :
		LuaScriptInterface("CoreNetworkFunctions") {
		init(L);
	}
	~CoreNetworkFunctions() override = default;

	static void init(lua_State* L) {
		NetworkMessageFunctions::init(L);
		WebhookFunctions::init(L);
	}

private:
};
