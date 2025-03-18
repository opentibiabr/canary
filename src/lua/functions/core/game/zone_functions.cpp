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
#include "lua/functions/lua_functions_loader.hpp"

void ZoneFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Zone", "", ZoneFunctions::luaZoneCreate);
	Lua::registerMetaMethod(L, "Zone", "__eq", ZoneFunctions::luaZoneCompare);

	Lua::registerMethod(L, "Zone", "getName", ZoneFunctions::luaZoneGetName);
	Lua::registerMethod(L, "Zone", "addArea", ZoneFunctions::luaZoneAddArea);
	Lua::registerMethod(L, "Zone", "subtractArea", ZoneFunctions::luaZoneSubtractArea);
	Lua::registerMethod(L, "Zone", "getRemoveDestination", ZoneFunctions::luaZoneGetRemoveDestination);
	Lua::registerMethod(L, "Zone", "setRemoveDestination", ZoneFunctions::luaZoneSetRemoveDestination);
	Lua::registerMethod(L, "Zone", "getPositions", ZoneFunctions::luaZoneGetPositions);
	Lua::registerMethod(L, "Zone", "getCreatures", ZoneFunctions::luaZoneGetCreatures);
	Lua::registerMethod(L, "Zone", "getPlayers", ZoneFunctions::luaZoneGetPlayers);
	Lua::registerMethod(L, "Zone", "getMonsters", ZoneFunctions::luaZoneGetMonsters);
	Lua::registerMethod(L, "Zone", "getNpcs", ZoneFunctions::luaZoneGetNpcs);
	Lua::registerMethod(L, "Zone", "getItems", ZoneFunctions::luaZoneGetItems);

	Lua::registerMethod(L, "Zone", "removePlayers", ZoneFunctions::luaZoneRemovePlayers);
	Lua::registerMethod(L, "Zone", "removeMonsters", ZoneFunctions::luaZoneRemoveMonsters);
	Lua::registerMethod(L, "Zone", "removeNpcs", ZoneFunctions::luaZoneRemoveNpcs);
	Lua::registerMethod(L, "Zone", "refresh", ZoneFunctions::luaZoneRefresh);

	Lua::registerMethod(L, "Zone", "setMonsterVariant", ZoneFunctions::luaZoneSetMonsterVariant);

	// static methods
	Lua::registerMethod(L, "Zone", "getByPosition", ZoneFunctions::luaZoneGetByPosition);
	Lua::registerMethod(L, "Zone", "getByName", ZoneFunctions::luaZoneGetByName);
	Lua::registerMethod(L, "Zone", "getAll", ZoneFunctions::luaZoneGetAll);
}

// Zone
int ZoneFunctions::luaZoneCreate(lua_State* L) {
	// Zone(name)
	const auto name = Lua::getString(L, 2);
	auto zone = Zone::getZone(name);
	if (!zone) {
		zone = Zone::addZone(name);
	}
	Lua::pushUserdata<Zone>(L, zone);
	Lua::setMetatable(L, -1, "Zone");
	return 1;
}

int ZoneFunctions::luaZoneCompare(lua_State* L) {
	const auto &zone1 = Lua::getUserdataShared<Zone>(L, 1);
	const auto &zone2 = Lua::getUserdataShared<Zone>(L, 2);
	if (!zone1) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	if (!zone2) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, zone1->getName() == zone2->getName());
	return 1;
}

int ZoneFunctions::luaZoneGetName(lua_State* L) {
	// Zone:getName()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	Lua::pushString(L, zone->getName());
	return 1;
}

int ZoneFunctions::luaZoneAddArea(lua_State* L) {
	// Zone:addArea(fromPos, toPos)
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto fromPos = Lua::getPosition(L, 2);
	const auto toPos = Lua::getPosition(L, 3);
	const auto area = Area(fromPos, toPos);
	zone->addArea(area);
	Lua::pushBoolean(L, true);
	return 1;
}

int ZoneFunctions::luaZoneSubtractArea(lua_State* L) {
	// Zone:subtractArea(fromPos, toPos)
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto fromPos = Lua::getPosition(L, 2);
	const auto toPos = Lua::getPosition(L, 3);
	const auto area = Area(fromPos, toPos);
	zone->subtractArea(area);
	Lua::pushBoolean(L, true);
	return 1;
}

int ZoneFunctions::luaZoneGetRemoveDestination(lua_State* L) {
	// Zone:getRemoveDestination()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		return 1;
	}
	Lua::pushPosition(L, zone->getRemoveDestination());
	return 1;
}

int ZoneFunctions::luaZoneSetRemoveDestination(lua_State* L) {
	// Zone:setRemoveDestination(pos)
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		return 1;
	}
	const auto pos = Lua::getPosition(L, 2);
	zone->setRemoveDestination(pos);
	return 1;
}

int ZoneFunctions::luaZoneGetPositions(lua_State* L) {
	// Zone:getPositions()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto positions = zone->getPositions();
	lua_createtable(L, static_cast<int>(positions.size()), 0);

	int index = 0;
	for (auto pos : positions) {
		index++;
		Lua::pushPosition(L, pos);
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetCreatures(lua_State* L) {
	// Zone:getCreatures()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto &creatures = zone->getCreatures();
	lua_createtable(L, static_cast<int>(creatures.size()), 0);

	int index = 0;
	for (const auto &creature : creatures) {
		index++;
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetPlayers(lua_State* L) {
	// Zone:getPlayers()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto &players = zone->getPlayers();
	lua_createtable(L, static_cast<int>(players.size()), 0);

	int index = 0;
	for (const auto &player : players) {
		index++;
		Lua::pushUserdata<Player>(L, player);
		Lua::setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetMonsters(lua_State* L) {
	// Zone:getMonsters()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto &monsters = zone->getMonsters();
	lua_createtable(L, static_cast<int>(monsters.size()), 0);

	int index = 0;
	for (const auto &monster : monsters) {
		index++;
		Lua::pushUserdata<Monster>(L, monster);
		Lua::setMetatable(L, -1, "Monster");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetNpcs(lua_State* L) {
	// Zone:getNpcs()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto &npcs = zone->getNpcs();
	lua_createtable(L, static_cast<int>(npcs.size()), 0);

	int index = 0;
	for (const auto &npc : npcs) {
		index++;
		Lua::pushUserdata<Npc>(L, npc);
		Lua::setMetatable(L, -1, "Npc");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneGetItems(lua_State* L) {
	// Zone:getItems()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto &items = zone->getItems();
	lua_createtable(L, static_cast<int>(items.size()), 0);

	int index = 0;
	for (const auto &item : items) {
		index++;
		Lua::pushUserdata<Item>(L, item);
		Lua::setMetatable(L, -1, "Item");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneRemovePlayers(lua_State* L) {
	// Zone:removePlayers()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	zone->removePlayers();
	return 1;
}

int ZoneFunctions::luaZoneRemoveMonsters(lua_State* L) {
	// Zone:removeMonsters()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	zone->removeMonsters();
	return 1;
}

int ZoneFunctions::luaZoneRemoveNpcs(lua_State* L) {
	// Zone:removeNpcs()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	zone->removeNpcs();
	return 1;
}

int ZoneFunctions::luaZoneSetMonsterVariant(lua_State* L) {
	// Zone:setMonsterVariant(variant)
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}
	const auto variant = Lua::getString(L, 2);
	if (variant.empty()) {
		Lua::pushBoolean(L, false);
		return 1;
	}
	zone->setMonsterVariant(variant);
	Lua::pushBoolean(L, true);
	return 1;
}

int ZoneFunctions::luaZoneGetByName(lua_State* L) {
	// Zone.getByName(name)
	const auto name = Lua::getString(L, 1);
	const auto &zone = Zone::getZone(name);
	if (!zone) {
		lua_pushnil(L);
		return 1;
	}
	Lua::pushUserdata<Zone>(L, zone);
	Lua::setMetatable(L, -1, "Zone");
	return 1;
}

int ZoneFunctions::luaZoneGetByPosition(lua_State* L) {
	// Zone.getByPosition(pos)
	const auto pos = Lua::getPosition(L, 1);
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
		Lua::pushUserdata<Zone>(L, zone);
		Lua::setMetatable(L, -1, "Zone");
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
		Lua::pushUserdata<Zone>(L, zone);
		Lua::setMetatable(L, -1, "Zone");
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ZoneFunctions::luaZoneRefresh(lua_State* L) {
	// Zone:refresh()
	const auto &zone = Lua::getUserdataShared<Zone>(L, 1);
	if (!zone) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ZONE_NOT_FOUND));
		return 1;
	}
	zone->refresh();
	return 1;
}
