/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/game.hpp"
#include "lua/functions/map/town_functions.hpp"
#include "map/town.hpp"

int TownFunctions::luaTownCreate(lua_State* L) {
	// Town(id or name)
	std::shared_ptr<Town> town;
	if (isNumber(L, 2)) {
		town = g_game().map.towns.getTown(getNumber<uint32_t>(L, 2));
	} else if (isString(L, 2)) {
		town = g_game().map.towns.getTown(getString(L, 2));
	} else {
		town = nullptr;
	}

	if (town) {
		pushUserdata<Town>(L, town);
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TownFunctions::luaTownGetId(lua_State* L) {
	// town:getId()
	if (const auto &town = getUserdataShared<Town>(L, 1)) {
		lua_pushnumber(L, town->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TownFunctions::luaTownGetName(lua_State* L) {
	// town:getName()
	if (const auto &town = getUserdataShared<Town>(L, 1)) {
		pushString(L, town->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TownFunctions::luaTownGetTemplePosition(lua_State* L) {
	// town:getTemplePosition()
	if (const auto &town = getUserdataShared<Town>(L, 1)) {
		pushPosition(L, town->getTemplePosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}
