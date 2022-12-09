/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "core.hpp"
#include "creatures/monsters/monster.h"
#include "game/functions/game_reload.hpp"
#include "game/game.h"
#include "items/item.h"
#include "io/iobestiary.h"
#include "io/iologindata.h"
#include "lua/functions/core/game/game_functions.hpp"
#include "game/scheduling/tasks.h"
#include "lua/functions/creatures/npc/npc_type_functions.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/scripts.h"

// Game
int GameFunctions::luaGameCreateMonsterType(lua_State* L) {
	// Game.createMonsterType(name)
	if (isString(L, 1)) {
		std::string name = getString(L, 1);
		auto monsterType = new MonsterType(name);
		g_monsters().addMonsterType(name, monsterType);
		if (!monsterType) {
			reportErrorFunc("MonsterType is nullptr");
			pushBoolean(L, false);
			delete monsterType;
			return 1;
		}

		monsterType->nameDescription = "a " + name;
		pushUserdata<MonsterType>(L, monsterType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameCreateNpcType(lua_State* L) {
	// Game.createNpcType(name)
	if (getScriptEnv()->getScriptInterface() != &g_scripts().getScriptInterface()) {
		reportErrorFunc("NpcType can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	NpcTypeFunctions::luaNpcTypeCreate(L);

	return 1;
}

int GameFunctions::luaGameGetSpectators(lua_State* L) {
	// Game.getSpectators(position[, multifloor = false[, onlyPlayer = false[, minRangeX = 0[, maxRangeX = 0[, minRangeY = 0[, maxRangeY = 0]]]]]])
	const Position& position = getPosition(L, 1);
	bool multifloor = getBoolean(L, 2, false);
	bool onlyPlayers = getBoolean(L, 3, false);
	int32_t minRangeX = getNumber<int32_t>(L, 4, 0);
	int32_t maxRangeX = getNumber<int32_t>(L, 5, 0);
	int32_t minRangeY = getNumber<int32_t>(L, 6, 0);
	int32_t maxRangeY = getNumber<int32_t>(L, 7, 0);

	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, position, multifloor, onlyPlayers, minRangeX, maxRangeX, minRangeY, maxRangeY);

	lua_createtable(L, spectators.size(), 0);

	int index = 0;
	for (Creature* creature : spectators) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameGetBoostedCreature(lua_State* L) {
	// Game.getBoostedCreature()
	pushString(L, g_game().getBoostedMonsterName());
	return 1;
}

int GameFunctions::luaGameGetBestiaryList(lua_State* L) {
	// Game.getBestiaryList([bool[string or BestiaryType_t]])
	lua_newtable(L);
	int index = 0;
	bool name = getBoolean(L, 2, false);

	if (lua_gettop(L) <= 2) {
		std::map<uint16_t, std::string> mtype_list = g_game().getBestiaryList();
		for (auto ita : mtype_list) {
			if (name) {
				pushString(L, ita.second);
			}
			else {
				lua_pushnumber(L, ita.first);
			}
			lua_rawseti(L, -2, ++index);
		}
	}
	else {
		if (isNumber(L, 2)) {
			std::map<uint16_t, std::string> tmplist = g_iobestiary().findRaceByName("CANARY", false, getNumber<BestiaryType_t>(L, 2));
			for (auto itb : tmplist) {
				if (name) {
					pushString(L, itb.second);
				}
				else {
					lua_pushnumber(L, itb.first);
				}
				lua_rawseti(L, -2, ++index);
			}
		}
		else {
			std::map<uint16_t, std::string> tmplist = g_iobestiary().findRaceByName(getString(L, 2));
			for (auto itc : tmplist) {
				if (name) {
					pushString(L, itc.second);
				}
				else {
					lua_pushnumber(L, itc.first);
				}
				lua_rawseti(L, -2, ++index);
			}
		}
	}
	return 1;
}

int GameFunctions::luaGameGetPlayers(lua_State* L) {
	// Game.getPlayers()
	lua_createtable(L, g_game().getPlayersOnline(), 0);

	int index = 0;
	for (const auto& playerEntry : g_game().getPlayers()) {
		pushUserdata<Player>(L, playerEntry.second);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameLoadMap(lua_State* L) {
	// Game.loadMap(path)
	const std::string& path = getString(L, 1);
	g_dispatcher().addTask(createTask([path]() {g_game().loadMap(path); }));
	return 0;
}

int GameFunctions::luaGameGetMonsterCount(lua_State* L) {
	// Game.getMonsterCount()
	lua_pushnumber(L, g_game().getMonstersOnline());
	return 1;
}

int GameFunctions::luaGameGetPlayerCount(lua_State* L) {
	// Game.getPlayerCount()
	lua_pushnumber(L, g_game().getPlayersOnline());
	return 1;
}

int GameFunctions::luaGameGetNpcCount(lua_State* L) {
	// Game.getNpcCount()
	lua_pushnumber(L, g_game().getNpcsOnline());
	return 1;
}

int GameFunctions::luaGameGetMonsterTypes(lua_State* L) {
	// Game.getMonsterTypes()
	auto& type = g_monsters().monsters;
	lua_createtable(L, type.size(), 0);

	for (auto& mType : type) {
		pushUserdata<MonsterType>(L, mType.second);
		setMetatable(L, -1, "MonsterType");
		lua_setfield(L, -2, mType.first.c_str());
	}
	return 1;
}

int GameFunctions::luaGameGetTowns(lua_State* L) {
	// Game.getTowns()
	const auto& towns = g_game().map.towns.getTowns();
	lua_createtable(L, towns.size(), 0);

	int index = 0;
	for (auto townEntry : towns) {
		pushUserdata<Town>(L, townEntry.second);
		setMetatable(L, -1, "Town");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameGetHouses(lua_State* L) {
	// Game.getHouses()
	const auto& houses = g_game().map.houses.getHouses();
	lua_createtable(L, houses.size(), 0);

	int index = 0;
	for (auto houseEntry : houses) {
		pushUserdata<House>(L, houseEntry.second);
		setMetatable(L, -1, "House");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameGetGameState(lua_State* L) {
	// Game.getGameState()
	lua_pushnumber(L, g_game().getGameState());
	return 1;
}

int GameFunctions::luaGameSetGameState(lua_State* L) {
	// Game.setGameState(state)
	GameState_t state = getNumber<GameState_t>(L, 1);
	g_game().setGameState(state);
	pushBoolean(L, true);
	return 1;
}

int GameFunctions::luaGameGetWorldType(lua_State* L) {
	// Game.getWorldType()
	lua_pushnumber(L, g_game().getWorldType());
	return 1;
}

int GameFunctions::luaGameSetWorldType(lua_State* L) {
	// Game.setWorldType(type)
	WorldType_t type = getNumber<WorldType_t>(L, 1);
	g_game().setWorldType(type);
	pushBoolean(L, true);
	return 1;
}

int GameFunctions::luaGameGetReturnMessage(lua_State* L) {
	// Game.getReturnMessage(value)
	ReturnValue value = getNumber<ReturnValue>(L, 1);
	pushString(L, getReturnMessage(value));
	return 1;
}

int GameFunctions::luaGameCreateItem(lua_State* L) {
	// Game.createItem(itemId[, count[, position]])
	uint16_t itemId;
	if (isNumber(L, 1)) {
		itemId = getNumber<uint16_t>(L, 1);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 1));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t count = getNumber<int32_t>(L, 2, 1);
	int32_t itemCount = 1;
	int32_t subType = 1;

	const ItemType& it = Item::items[itemId];
	if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = std::ceil(count / 100.f);
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	Position position;
	if (lua_gettop(L) >= 3) {
		position = getPosition(L, 3);
	}

	bool hasTable = itemCount > 1;
	if (hasTable) {
		lua_newtable(L);
	} else if (itemCount == 0) {
		lua_pushnil(L);
		return 1;
	}

	for (int32_t i = 1; i <= itemCount; ++i) {
		int32_t stackCount = subType;
		if (it.stackable) {
			stackCount = std::min<int32_t>(stackCount, 100);
			subType -= stackCount;
		}

		Item* item = Item::CreateItem(itemId, stackCount);
		if (!item) {
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		if (position.x != 0) {
			Tile* tile = g_game().map.getTile(position);
			if (!tile) {
				delete item;
				if (!hasTable) {
					lua_pushnil(L);
				}
				return 1;
			}

			ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
			if (ret != RETURNVALUE_NOERROR) {
				delete item;
				if (!hasTable) {
					lua_pushnil(L);
				}
				return 1;
			}

		} else {
			getScriptEnv()->addTempItem(item);
			item->setParent(VirtualCylinder::virtualCylinder);
		}

		if (hasTable) {
			lua_pushnumber(L, i);
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
			lua_settable(L, -3);
		} else {
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
		}
	}

	return 1;
}

int GameFunctions::luaGameCreateContainer(lua_State* L) {
	// Game.createContainer(itemId, size[, position])
	uint16_t size = getNumber<uint16_t>(L, 2);
	uint16_t id;
	if (isNumber(L, 1)) {
		id = getNumber<uint16_t>(L, 1);
	} else {
		id = Item::items.getItemIdByName(getString(L, 1));
		if (id == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	Container* container = Item::CreateItemAsContainer(id, size);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) >= 3) {
		const Position& position = getPosition(L, 3);
		Tile* tile = g_game().map.getTile(position);
		if (!tile) {
			delete container;
			lua_pushnil(L);
			return 1;
		}

		g_game().internalAddItem(tile, container, INDEX_WHEREEVER, FLAG_NOLIMIT);
	} else {
		getScriptEnv()->addTempItem(container);
		container->setParent(VirtualCylinder::virtualCylinder);
	}

	pushUserdata<Container>(L, container);
	setMetatable(L, -1, "Container");
	return 1;
}

int GameFunctions::luaGameCreateMonster(lua_State* L) {
	// Game.createMonster(monsterName, position[, extended = false[, force = false[, master = nil]]])
	Monster* monster = Monster::createMonster(getString(L, 1));
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	bool isSummon = false;
	if (lua_gettop(L) >= 5) {
		Creature* master = getCreature(L, 5);
		if (master) {
			monster->setMaster(master, true);
			isSummon = true;
		}
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	if (g_game().placeCreature(monster, position, extended, force)) {
		pushUserdata<Monster>(L, monster);
		setMetatable(L, -1, "Monster");
	} else {
		if (isSummon) {
			monster->setMaster(nullptr);
		} else {
			delete monster;
		}
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameGenerateNpc(lua_State* L) {
	// Game.generateNpc(npcName)
	Npc* npc = Npc::createNpc(getString(L, 1));
	if (!npc) {
		lua_pushnil(L);
		return 1;
	} else {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	}
	return 1;
}

int GameFunctions::luaGameCreateNpc(lua_State* L) {
	// Game.createNpc(npcName, position[, extended = false[, force = false]])
	Npc* npc = Npc::createNpc(getString(L, 1));
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	if (g_game().placeCreature(npc, position, extended, force)) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		delete npc;
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameCreateTile(lua_State* L) {
	// Game.createTile(x, y, z[, isDynamic = false])
	// Game.createTile(position[, isDynamic = false])
	Position position;
	bool isDynamic;
	if (isTable(L, 1)) {
		position = getPosition(L, 1);
		isDynamic = getBoolean(L, 2, false);
	} else {
		position.x = getNumber<uint16_t>(L, 1);
		position.y = getNumber<uint16_t>(L, 2);
		position.z = getNumber<uint16_t>(L, 3);
		isDynamic = getBoolean(L, 4, false);
	}

	Tile* tile = g_game().map.getTile(position);
	if (!tile) {
		if (isDynamic) {
			tile = new DynamicTile(position.x, position.y, position.z);
		} else {
			tile = new StaticTile(position.x, position.y, position.z);
		}

		g_game().map.setTile(position, tile);
	}

	pushUserdata(L, tile);
	setMetatable(L, -1, "Tile");
	return 1;
}

int GameFunctions::luaGameGetBestiaryCharm(lua_State* L) {
	// Game.getBestiaryCharm()
	std::vector<Charm*> c_list = g_game().getCharmList();
	lua_createtable(L, c_list.size(), 0);

	int index = 0;
	for (auto& it : c_list) {
		pushUserdata<Charm>(L, it);
		setMetatable(L, -1, "Charm");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameCreateBestiaryCharm(lua_State* L) {
	// Game.createBestiaryCharm(id)
	if (getScriptEnv()->getScriptInterface() != &g_scripts().getScriptInterface()) {
		reportErrorFunc("Charm bestiary can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	if (Charm* charm = g_iobestiary().getBestiaryCharm(static_cast<charmRune_t>(getNumber<int8_t>(L, 1, 0)), true)) {
		pushUserdata<Charm>(L, charm);
		setMetatable(L, -1, "Charm");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameCreateItemClassification(lua_State* L) {
	// Game.createItemClassification(id)
	if (getScriptEnv()->getScriptInterface() != &g_scripts().getScriptInterface()) {
		reportErrorFunc("Item classification can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	ItemClassification* itemClassification = g_game().getItemsClassification(getNumber<uint8_t>(L, 1), true);
	if (itemClassification) {
		pushUserdata<ItemClassification>(L, itemClassification);
		setMetatable(L, -1, "ItemClassification");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameStartRaid(lua_State* L) {
	// Game.startRaid(raidName)
	const std::string& raidName = getString(L, 1);

	Raid* raid = g_game().raids.getRaidByName(raidName);
	if (!raid || !raid->isLoaded()) {
		lua_pushnumber(L, RETURNVALUE_NOSUCHRAIDEXISTS);
		return 1;
	}

	if (g_game().raids.getRunning()) {
		lua_pushnumber(L, RETURNVALUE_ANOTHERRAIDISALREADYEXECUTING);
		return 1;
	}

	g_game().raids.setRunning(raid);
	raid->startRaid();
	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}

int GameFunctions::luaGameGetClientVersion(lua_State* L) {
	// Game.getClientVersion()
	lua_createtable(L, 0, 3);
	setField(L, "min", CLIENT_VERSION);
	setField(L, "max", CLIENT_VERSION);
	setField(L, "string", std::to_string(CLIENT_VERSION_UPPER) + "." + std::to_string(CLIENT_VERSION_LOWER));
	return 1;
}

int GameFunctions::luaGameReload(lua_State* L) {
	// Game.reload(reloadType)
	Reload_t reloadType = getNumber<Reload_t>(L, 1);
	if (g_gameReload.getReloadNumber(reloadType) == g_gameReload.getReloadNumber(Reload_t::RELOAD_TYPE_NONE)) {
		reportErrorFunc("Reload type is none");
		pushBoolean(L, false);
		return 0;
	}

	if (g_gameReload.getReloadNumber(reloadType) >= g_gameReload.getReloadNumber(Reload_t::RELOAD_TYPE_LAST)) {
		reportErrorFunc("Reload type not exist");
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, g_gameReload.init(reloadType));
	lua_gc(g_luaEnvironment.getLuaState(), LUA_GCCOLLECT, 0);
	return 1;
}

int GameFunctions::luaGameHasEffect(lua_State* L) {
	// Game.hasEffect(effectId)
	uint8_t effectId = getNumber<uint8_t>(L, 1);
	pushBoolean(L, g_game().hasEffect(effectId));
	return 1;
}

int GameFunctions::luaGameHasDistanceEffect(lua_State* L) {
	// Game.hasDistanceEffect(effectId)
	uint8_t effectId = getNumber<uint8_t>(L, 1);
	pushBoolean(L, g_game().hasDistanceEffect(effectId));
	return 1;
}

int GameFunctions::luaGameGetOfflinePlayer(lua_State* L) {
	uint32_t playerId = getNumber<uint32_t>(L, 1);

	Player* offlinePlayer = new Player(nullptr);
	if (!IOLoginData::loadPlayerById(offlinePlayer, playerId)) {
		delete offlinePlayer;
		lua_pushnil(L);
	} else {
		pushUserdata<Player>(L, offlinePlayer);
		setMetatable(L, -1, "Player");
	}

	return 1;
}

int GameFunctions::luaGameAddInfluencedMonster(lua_State *L) {
	// Game.addInfluencedMonster(monster)
	Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushboolean(L, g_game().addInfluencedMonster(monster));
	return 1;
}

int GameFunctions::luaGameRemoveInfluencedMonster(lua_State *L) {
	// Game.removeInfluencedMonster(monsterId)
	uint32_t monsterId = getNumber<uint32_t>(L, 1);
	auto create = getBoolean(L, 2, false);
	lua_pushnumber(L, g_game().removeInfluencedMonster(monsterId, create));
	return 1;
}

int GameFunctions::luaGameGetInfluencedMonsters(lua_State *L) {
	// Game.getInfluencedMonsters()
	const auto monsters = g_game().getInfluencedMonsters();
	lua_createtable(L, static_cast<int>(monsters.size()), 0);
	int index = 0;
	for (const auto &monsterId : monsters) {
		++index;
		lua_pushnumber(L, monsterId);
		lua_rawseti(L, -2, index);
	}

	return 1;
}

int GameFunctions::luaGameMakeFiendishMonster(lua_State *L) {
	// Game.makeFiendishMonster(monsterId[default= 0])
	uint32_t monsterId = getNumber<uint32_t>(L, 1, 0);
	auto createForgeableMonsters = getBoolean(L, 2, false);
	lua_pushnumber(L, g_game().makeFiendishMonster(monsterId, createForgeableMonsters));
	return 1;
}

int GameFunctions::luaGameRemoveFiendishMonster(lua_State *L) {
	// Game.removeFiendishMonster(monsterId)
	uint32_t monsterId = getNumber<uint32_t>(L, 1);
	auto create = getBoolean(L, 2, false);
	lua_pushnumber(L, g_game().removeFiendishMonster(monsterId, create));
	return 1;
}

int GameFunctions::luaGameGetFiendishMonsters(lua_State *L) {
	// Game.getFiendishMonsters()
	const auto monsters = g_game().getFiendishMonsters();

	lua_createtable(L, static_cast<int>(monsters.size()), 0);
	int index = 0;
	for (const auto &monsterId : monsters) {
		++index;
		lua_pushnumber(L, monsterId);
		lua_rawseti(L, -2, index);
	}

	return 1;
}
