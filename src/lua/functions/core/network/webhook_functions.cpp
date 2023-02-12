/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "lua/functions/core/network/webhook_functions.hpp"
#include "server/network/webhook/webhook.h"

int WebhookFunctions::webhookSend(lua_State* L) {
	// Webhook.send(title, message, color, url)
	std::string title = getString(L, 1);
	std::string message = getString(L, 2);
	std::string url = getString(L, 4);
	uint32_t color = getNumber<uint32_t>(L, 3, 0);

	webhook_send_message(title, message, color, url);
	lua_pushnil(L);

	return 1;
}
