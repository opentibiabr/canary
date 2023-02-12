/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CORE_NETWORK_WEBHOOK_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_NETWORK_WEBHOOK_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class WebhookFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerTable(L, "Webhook");
			registerMethod(L, "Webhook", "send", WebhookFunctions::webhookSend);
		}

	private:
		static int webhookSend(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_NETWORK_WEBHOOK_FUNCTIONS_HPP_
