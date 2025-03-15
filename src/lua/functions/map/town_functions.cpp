/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/map/town_functions.hpp"

#include "game/game.hpp"
#include "map/town.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void TownFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Town", "", TownFunctions::luaTownCreate);
	Lua::registerMetaMethod(L, "Town", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Town", "getId", TownFunctions::luaTownGetId);
	Lua::registerMethod(L, "Town", "getName", TownFunctions::luaTownGetName);
	Lua::registerMethod(L, "Town", "getTemplePosition", TownFunctions::luaTownGetTemplePosition);
}

int TownFunctions::luaTownCreate(lua_State* L) {
	// Town(id or name)
	std::shared_ptr<Town> town;
	if (Lua::isNumber(L, 2)) {
		town = g_game().map.towns.getTown(Lua::getNumber<uint32_t>(L, 2));
	} else if (Lua::isString(L, 2)) {
		town = g_game().map.towns.getTown(Lua::getString(L, 2));
	} else {
		town = nullptr;
	}

	if (town) {
		Lua::pushUserdata<Town>(L, town);
		Lua::setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TownFunctions::luaTownGetId(lua_State* L) {
	// town:getId()
	if (const auto &town = Lua::getUserdataShared<Town>(L, 1, "Town")) {
		lua_pushnumber(L, town->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TownFunctions::luaTownGetName(lua_State* L) {
	// town:getName()
	if (const auto &town = Lua::getUserdataShared<Town>(L, 1, "Town")) {
		Lua::pushString(L, town->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TownFunctions::luaTownGetTemplePosition(lua_State* L) {
	// town:getTemplePosition()
	if (const auto &town = Lua::getUserdataShared<Town>(L, 1, "Town")) {
		Lua::pushPosition(L, town->getTemplePosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}
