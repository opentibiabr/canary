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
#include "server/network/webhook/webhook.h"

int WebhookFunctions::webhookSend(lua_State* L) {
	// Webhook.send(title, message, color, url)
	std::string title = getString(L, 1);
	std::string message = getString(L, 2);
	uint32_t color = getNumber<uint32_t>(L, 3, 0);

	WebHook::sendMessage(title, message, color);
	lua_pushnil(L);

	return 1;
}
