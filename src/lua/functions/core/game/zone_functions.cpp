/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/zone_functions.hpp"

#include "game/zones/zone.hpp"
#include "game/game.hpp"

// Zone
int ZoneFunctions::luaZoneCreate(lua_State* L) {
	// Zone(name)
	const auto name = getString(L, 2);
	auto zone = Zone::getZone(name);
	if (!zone) {
		zone = Zone::addZone(name);
	}
	pushUserdata<Zone>(L, zone);
	setMetatable(L, -1, "Zone");
	return 1;
}

int ZoneFunctions::luaZoneCompare(lua_State* L) {
	const auto &zone1 = getUserdataShared<Zone>(L, 1);
	const auto &zone2 = getUserdataShared<Zone>(L, 2);
	if (!zone1) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	if (!zone2) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, zone1->getName() == zone2->getName());
	return 1;
}

int ZoneFunctions::luaZoneGetName(lua_State* L) {
	// Zone:getName()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	pushString(L, zone->getName());
	return 1;
}

int ZoneFunctions::luaZoneAddArea(lua_State* L) {
	// Zone:addArea(fromPos, toPos)
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto fromPos = getPosition(L, 2);
	const auto toPos = getPosition(L, 3);
	const auto area = Area(fromPos, toPos);
	zone->addArea(area);
	pushBoolean(L, true);
	return 1;
}

int ZoneFunctions::luaZoneSubtractArea(lua_State* L) {
	// Zone:subtractArea(fromPos, toPos)
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto fromPos = getPosition(L, 2);
	const auto toPos = getPosition(L, 3);
	const auto area = Area(fromPos, toPos);
	zone->subtractArea(area);
	pushBoolean(L, true);
	return 1;
}

int ZoneFunctions::luaZoneGetRemoveDestination(lua_State* L) {
	// Zone:getRemoveDestination()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		return 1;
	}
	pushPosition(L, zone->getRemoveDestination());
	return 1;
}

int ZoneFunctions::luaZoneSetRemoveDestination(lua_State* L) {
	// Zone:setRemoveDestination(pos)
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		return 1;
	}
	const auto pos = getPosition(L, 2);
	zone->setRemoveDestination(pos);
	return 1;
}

int ZoneFunctions::luaZoneGetPositions(lua_State* L) {
	// Zone:getPositions()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto positions = zone->getPositions();
	lua_createtable(L, static_cast<int>(positions.size()), 0);

	int index = 0;
	for (auto pos : positions) {
		index++;
		pushPosition(L, pos);
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetCreatures(lua_State* L) {
	// Zone:getCreatures()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto &creatures = zone->getCreatures();
	lua_createtable(L, static_cast<int>(creatures.size()), 0);

	int index = 0;
	for (const auto &creature : creatures) {
		index++;
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetPlayers(lua_State* L) {
	// Zone:getPlayers()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto &players = zone->getPlayers();
	lua_createtable(L, static_cast<int>(players.size()), 0);

	int index = 0;
	for (const auto &player : players) {
		index++;
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetMonsters(lua_State* L) {
	// Zone:getMonsters()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto &monsters = zone->getMonsters();
	lua_createtable(L, static_cast<int>(monsters.size()), 0);

	int index = 0;
	for (const auto &monster : monsters) {
		index++;
		pushUserdata<Monster>(L, monster);
		setMetatable(L, -1, "Monster");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetNpcs(lua_State* L) {
	// Zone:getNpcs()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto &npcs = zone->getNpcs();
	lua_createtable(L, static_cast<int>(npcs.size()), 0);

	int index = 0;
	for (const auto &npc : npcs) {
		index++;
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetItems(lua_State* L) {
	// Zone:getItems()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto &items = zone->getItems();
	lua_createtable(L, static_cast<int>(items.size()), 0);

	int index = 0;
	for (const auto &item : items) {
		index++;
		pushUserdata<Item>(L, item);
		setMetatable(L, -1, "Item");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneRemovePlayers(lua_State* L) {
	// Zone:removePlayers()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	zone->removePlayers();
	return 1;
}

int ZoneFunctions::luaZoneRemoveMonsters(lua_State* L) {
	// Zone:removeMonsters()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	zone->removeMonsters();
	return 1;
}

int ZoneFunctions::luaZoneRemoveNpcs(lua_State* L) {
	// Zone:removeNpcs()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	zone->removeNpcs();
	return 1;
}

int ZoneFunctions::luaZoneSetMonsterVariant(lua_State* L) {
	// Zone:setMonsterVariant(variant)
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	const auto variant = getString(L, 2);
	if (variant.empty()) {
		pushBoolean(L, false);
		return 1;
	}
	zone->setMonsterVariant(variant);
	pushBoolean(L, true);
	return 1;
}

int ZoneFunctions::luaZoneGetByName(lua_State* L) {
	// Zone.getByName(name)
	const auto name = getString(L, 1);
	const auto &zone = Zone::getZone(name);
	if (!zone) {
		lua_pushnil(L);
		return 1;
	}
	pushUserdata<Zone>(L, zone);
	setMetatable(L, -1, "Zone");
	return 1;
}

int ZoneFunctions::luaZoneGetByPosition(lua_State* L) {
	// Zone.getByPosition(pos)
	const auto pos = getPosition(L, 1);
	const auto &tile = g_game().map.getTile(pos);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}
	int index = 0;
	const auto &zones = tile->getZones();
	lua_createtable(L, static_cast<int>(zones.size()), 0);
	for (const auto &zone : zones) {
		index++;
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetAll(lua_State* L) {
	// Zone.getAll()
	const auto &zones = Zone::getZones();
	lua_createtable(L, static_cast<int>(zones.size()), 0);
	int index = 0;
	for (const auto &zone : zones) {
		index++;
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneRefresh(lua_State* L) {
	// Zone:refresh()
	const auto &zone = getUserdataShared<Zone>(L, 1);
	if (!zone) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		return 1;
	}
	zone->refresh();
	return 1;
}
