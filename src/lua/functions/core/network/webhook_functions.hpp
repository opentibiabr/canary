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

class WebhookFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerTable(L, "Webhook");
		registerMethod(L, "Webhook", "sendMessage", WebhookFunctions::luaWebhookSendMessage);
	}

private:
	static int luaWebhookSendMessage(lua_State* L);
};
