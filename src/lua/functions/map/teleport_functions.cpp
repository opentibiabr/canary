/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/map/teleport_functions.hpp"

#include "game/movement/teleport.hpp"
#include "items/item.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void TeleportFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Teleport", "Item", TeleportFunctions::luaTeleportCreate);
	Lua::registerMetaMethod(L, "Teleport", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Teleport", "getDestination", TeleportFunctions::luaTeleportGetDestination);
	Lua::registerMethod(L, "Teleport", "setDestination", TeleportFunctions::luaTeleportSetDestination);
}

// Teleport
int TeleportFunctions::luaTeleportCreate(lua_State* L) {
	// Teleport(uid)
	const uint32_t id = Lua::getNumber<uint32_t>(L, 2);

	const auto &item = Lua::getScriptEnv()->getItemByUID(id);
	if (item && item->getTeleport()) {
		Lua::pushUserdata(L, item);
		Lua::setMetatable(L, -1, "Teleport");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TeleportFunctions::luaTeleportGetDestination(lua_State* L) {
	// teleport:getDestination()
	const auto &teleport = Lua::getUserdataShared<Teleport>(L, 1, "Teleport");
	if (teleport) {
		Lua::pushPosition(L, teleport->getDestPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TeleportFunctions::luaTeleportSetDestination(lua_State* L) {
	// teleport:setDestination(position)
	const auto &teleport = Lua::getUserdataShared<Teleport>(L, 1, "Teleport");
	if (teleport) {
		teleport->setDestPos(Lua::getPosition(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
