/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "game/movement/teleport.h"
#include "items/item.h"
#include "lua/functions/map/teleport_functions.hpp"

// Teleport
int TeleportFunctions::luaTeleportCreate(lua_State* L) {
	// Teleport(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item && item->getTeleport()) {
		pushUserdata(L, item);
		setMetatable(L, -1, "Teleport");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TeleportFunctions::luaTeleportGetDestination(lua_State* L) {
	// teleport:getDestination()
	Teleport* teleport = getUserdata<Teleport>(L, 1);
	if (teleport) {
		pushPosition(L, teleport->getDestPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TeleportFunctions::luaTeleportSetDestination(lua_State* L) {
	// teleport:setDestination(position)
	Teleport* teleport = getUserdata<Teleport>(L, 1);
	if (teleport) {
		teleport->setDestPos(getPosition(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
