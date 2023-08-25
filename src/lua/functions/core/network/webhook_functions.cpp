/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/network/webhook_functions.hpp"
#include "server/network/webhook/webhook.hpp"

int WebhookFunctions::luaWebhookSendMessage(lua_State* L) {
	// Webhook.sendMessage(title, message, color, url = "WEBHOOK_DISCORD_URL")
	std::string title = getString(L, 1);
	std::string message = getString(L, 2);
	uint32_t color = getNumber<uint32_t>(L, 3, 0);
	std::string url = getString(L, 4);

	g_webhook().sendMessage(title, message, color, url);
	lua_pushnil(L);

	return 1;
}
