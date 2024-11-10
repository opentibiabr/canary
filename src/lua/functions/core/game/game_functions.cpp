/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/game_functions.hpp"

#include "core.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "game/functions/game_reload.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "io/io_bosstiary.hpp"
#include "io/iobestiary.hpp"
#include "items/item.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"
#include "lua/creature/talkaction.hpp"
#include "lua/functions/creatures/npc/npc_type_functions.hpp"
#include "lua/functions/events/event_callback_functions.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "map/spectators.hpp"
#include "creatures/players/player.hpp"

// Game
int GameFunctions::luaGameCreateMonsterType(lua_State* L) {
	// Game.createMonsterType(name[, variant = ""[, alternateName = ""]])
	if (isString(L, 1)) {
		const auto name = getString(L, 1);
		std::string uniqueName = name;
		auto variant = getString(L, 2, "");
		const auto alternateName = getString(L, 3, "");
		std::set<std::string> names;
		const auto monsterType = std::make_shared<MonsterType>(name);
		if (!monsterType) {
			lua_pushstring(L, "MonsterType is nullptr");
			lua_error(L);
			return 1;
		}

		// if variant starts with !, then it's the only variant for this monster, so we register it with both names
		if (variant.starts_with("!")) {
			names.insert(name);
			variant = variant.substr(1);
		}
		if (!variant.empty()) {
			uniqueName = variant + "|" + name;
		}
		names.insert(uniqueName);

		monsterType->name = name;
		if (!alternateName.empty()) {
			names.insert(alternateName);
			monsterType->name = alternateName;
		}

		monsterType->variantName = variant;
		monsterType->nameDescription = "a " + name;

		for (const auto &alternateName : names) {
			if (!g_monsters().tryAddMonsterType(alternateName, monsterType)) {
				lua_pushstring(L, fmt::format("The monster with name {} already registered", alternateName).c_str());
				lua_error(L);
				return 1;
			}
		}

		pushUserdata<MonsterType>(L, monsterType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameCreateNpcType(lua_State* L) {
	return NpcTypeFunctions::luaNpcTypeCreate(L);
}

int GameFunctions::luaGameGetSpectators(lua_State* L) {
	// Game.getSpectators(position[, multifloor = false[, onlyPlayer = false[, minRangeX = 0[, maxRangeX = 0[, minRangeY = 0[, maxRangeY = 0]]]]]])
	const Position &position = getPosition(L, 1);
	const bool multifloor = getBoolean(L, 2, false);
	const bool onlyPlayers = getBoolean(L, 3, false);
	const auto minRangeX = getNumber<int32_t>(L, 4, 0);
	const auto maxRangeX = getNumber<int32_t>(L, 5, 0);
	const auto minRangeY = getNumber<int32_t>(L, 6, 0);
	const auto maxRangeY = getNumber<int32_t>(L, 7, 0);

	Spectators spectators;

	if (onlyPlayers) {
		spectators.find<Player>(position, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY);
	} else {
		spectators.find<Creature>(position, multifloor, minRangeX, maxRangeX, minRangeY, maxRangeY);
	}

	lua_createtable(L, spectators.size(), 0);

	int index = 0;
	for (const auto &creature : spectators) {
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
	const bool name = getBoolean(L, 2, false);

	if (lua_gettop(L) <= 2) {
		const std::map<uint16_t, std::string> &mtype_list = g_game().getBestiaryList();
		for (const auto &ita : mtype_list) {
			if (name) {
				pushString(L, ita.second);
			} else {
				lua_pushnumber(L, ita.first);
			}
			lua_rawseti(L, -2, ++index);
		}
	} else {
		if (isNumber(L, 2)) {
			const std::map<uint16_t, std::string> tmplist = g_iobestiary().findRaceByName("CANARY", false, getNumber<BestiaryType_t>(L, 2));
			for (const auto &itb : tmplist) {
				if (name) {
					pushString(L, itb.second);
				} else {
					lua_pushnumber(L, itb.first);
				}
				lua_rawseti(L, -2, ++index);
			}
		} else {
			const std::map<uint16_t, std::string> tmplist = g_iobestiary().findRaceByName(getString(L, 2));
			for (const auto &itc : tmplist) {
				if (name) {
					pushString(L, itc.second);
				} else {
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
	for (const auto &playerEntry : g_game().getPlayers()) {
		pushUserdata<Player>(L, playerEntry.second);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameLoadMap(lua_State* L) {
	// Game.loadMap(path)
	const std::string &path = getString(L, 1);
	g_dispatcher().addEvent([path]() { g_game().loadMap(path); }, __FUNCTION__);
	return 0;
}

int GameFunctions::luaGameloadMapChunk(lua_State* L) {
	// Game.loadMapChunk(path, position, remove)
	const std::string &path = getString(L, 1);
	const Position &position = getPosition(L, 2);
	g_dispatcher().addEvent([path, position]() { g_game().loadMap(path, position); }, __FUNCTION__);
	return 0;
}

int GameFunctions::luaGameGetExperienceForLevel(lua_State* L) {
	// Game.getExperienceForLevel(level)
	const uint32_t level = getNumber<uint32_t>(L, 1);
	if (level == 0) {
		reportErrorFunc("Level must be greater than 0.");
	} else {
		lua_pushnumber(L, Player::getExpForLevel(level));
	}
	return 1;
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
	const auto type = g_monsters().monsters;
	lua_createtable(L, type.size(), 0);

	for (const auto &[typeName, mType] : type) {
		pushUserdata<MonsterType>(L, mType);
		setMetatable(L, -1, "MonsterType");
		lua_setfield(L, -2, typeName.c_str());
	}
	return 1;
}

int GameFunctions::luaGameGetTowns(lua_State* L) {
	// Game.getTowns()
	const auto towns = g_game().map.towns.getTowns();
	lua_createtable(L, towns.size(), 0);

	int index = 0;
	for (const auto &townEntry : towns) {
		pushUserdata<Town>(L, townEntry.second);
		setMetatable(L, -1, "Town");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameGetHouses(lua_State* L) {
	// Game.getHouses()
	const auto houses = g_game().map.houses.getHouses();
	lua_createtable(L, houses.size(), 0);

	int index = 0;
	for (const auto &houseEntry : houses) {
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
	const GameState_t state = getNumber<GameState_t>(L, 1);
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
	const WorldType_t type = getNumber<WorldType_t>(L, 1);
	g_game().setWorldType(type);
	pushBoolean(L, true);
	return 1;
}

int GameFunctions::luaGameGetReturnMessage(lua_State* L) {
	// Game.getReturnMessage(value)
	const ReturnValue value = getNumber<ReturnValue>(L, 1);
	pushString(L, getReturnMessage(value));
	return 1;
}

int GameFunctions::luaGameCreateItem(lua_State* L) {
	// Game.createItem(itemId or name[, count[, position]])
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

	const auto count = getNumber<int32_t>(L, 2, 1);
	int32_t itemCount = 1;
	int32_t subType = 1;

	const ItemType &it = Item::items[itemId];
	if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = std::ceil(count / static_cast<float_t>(it.stackSize));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	Position position;
	if (lua_gettop(L) >= 3) {
		position = getPosition(L, 3);
	}

	const bool hasTable = itemCount > 1;
	if (hasTable) {
		lua_newtable(L);
	} else if (itemCount == 0) {
		lua_pushnil(L);
		return 1;
	}

	for (int32_t i = 1; i <= itemCount; ++i) {
		int32_t stackCount = subType;
		if (it.stackable) {
			stackCount = std::min<int32_t>(stackCount, it.stackSize);
			subType -= stackCount;
		}

		const auto &item = Item::CreateItem(itemId, stackCount);
		if (!item) {
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		if (position.x != 0) {
			const auto &tile = g_game().map.getTile(position);
			if (!tile) {
				if (!hasTable) {
					lua_pushnil(L);
				}
				return 1;
			}

			ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
			if (ret != RETURNVALUE_NOERROR) {
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
	const uint16_t size = getNumber<uint16_t>(L, 2);
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

	const auto &container = Item::CreateItemAsContainer(id, size);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) >= 3) {
		const Position &position = getPosition(L, 3);
		const auto &tile = g_game().map.getTile(position);
		if (!tile) {
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
	const auto &monster = Monster::createMonster(getString(L, 1));
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	bool isSummon = false;
	if (lua_gettop(L) >= 5) {
		if (const auto &master = getCreature(L, 5)) {
			monster->setMaster(master, true);
			isSummon = true;
		}
	}

	const Position &position = getPosition(L, 2);
	const bool extended = getBoolean(L, 3, false);
	const bool force = getBoolean(L, 4, false);
	if (g_game().placeCreature(monster, position, extended, force)) {
		monster->onSpawn();
		const auto &mtype = monster->getMonsterType();
		if (mtype && mtype->info.raceid > 0 && mtype->info.bosstiaryRace == BosstiaryRarity_t::RARITY_ARCHFOE) {
			for (const auto &spectator : Spectators().find<Player>(monster->getPosition(), true)) {
				if (const auto &tmpPlayer = spectator->getPlayer()) {
					tmpPlayer->sendBosstiaryCooldownTimer();
				}
			}
		}

		pushUserdata<Monster>(L, monster);
		setMetatable(L, -1, "Monster");
	} else {
		if (isSummon) {
			monster->setMaster(nullptr);
		} else {
		}
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameGenerateNpc(lua_State* L) {
	// Game.generateNpc(npcName)
	const auto &npc = Npc::createNpc(getString(L, 1));
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
	const auto &npc = Npc::createNpc(getString(L, 1));
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	const Position &position = getPosition(L, 2);
	const bool extended = getBoolean(L, 3, false);
	const bool force = getBoolean(L, 4, false);
	if (g_game().placeCreature(npc, position, extended, force)) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
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

	pushUserdata(L, g_game().map.getOrCreateTile(position, isDynamic));
	setMetatable(L, -1, "Tile");
	return 1;
}

int GameFunctions::luaGameGetBestiaryCharm(lua_State* L) {
	// Game.getBestiaryCharm()
	const auto c_list = g_game().getCharmList();
	lua_createtable(L, c_list.size(), 0);

	int index = 0;
	for (const auto &charmPtr : c_list) {
		pushUserdata<Charm>(L, charmPtr);
		setMetatable(L, -1, "Charm");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameCreateBestiaryCharm(lua_State* L) {
	// Game.createBestiaryCharm(id)
	if (const std::shared_ptr<Charm> &charm = g_iobestiary().getBestiaryCharm(static_cast<charmRune_t>(getNumber<int8_t>(L, 1, 0)), true)) {
		pushUserdata<Charm>(L, charm);
		setMetatable(L, -1, "Charm");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameCreateItemClassification(lua_State* L) {
	// Game.createItemClassification(id)
	const ItemClassification* itemClassification = g_game().getItemsClassification(getNumber<uint8_t>(L, 1), true);
	if (itemClassification) {
		pushUserdata<const ItemClassification>(L, itemClassification);
		setMetatable(L, -1, "ItemClassification");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameStartRaid(lua_State* L) {
	// Game.startRaid(raidName)
	const std::string &raidName = getString(L, 1);

	const auto &raid = g_game().raids.getRaidByName(raidName);
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
	const std::string version = fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER);
	setField(L, "string", version);
	return 1;
}

int GameFunctions::luaGameReload(lua_State* L) {
	// Game.reload(reloadType)
	const Reload_t reloadType = getNumber<Reload_t>(L, 1);
	if (GameReload::getReloadNumber(reloadType) == GameReload::getReloadNumber(Reload_t::RELOAD_TYPE_NONE)) {
		reportErrorFunc("Reload type is none");
		pushBoolean(L, false);
		return 0;
	}

	if (GameReload::getReloadNumber(reloadType) >= GameReload::getReloadNumber(Reload_t::RELOAD_TYPE_LAST)) {
		reportErrorFunc("Reload type not exist");
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, GameReload::init(reloadType));
	lua_gc(g_luaEnvironment().getLuaState(), LUA_GCCOLLECT, 0);
	return 1;
}

int GameFunctions::luaGameHasEffect(lua_State* L) {
	// Game.hasEffect(effectId)
	const uint16_t effectId = getNumber<uint16_t>(L, 1);
	pushBoolean(L, g_game().hasEffect(effectId));
	return 1;
}

int GameFunctions::luaGameHasDistanceEffect(lua_State* L) {
	// Game.hasDistanceEffect(effectId)
	const uint16_t effectId = getNumber<uint16_t>(L, 1);
	pushBoolean(L, g_game().hasDistanceEffect(effectId));
	return 1;
}

int GameFunctions::luaGameGetOfflinePlayer(lua_State* L) {
	// Game.getOfflinePlayer(name or id)
	std::shared_ptr<Player> player = nullptr;
	if (isNumber(L, 1)) {
		const uint32_t id = getNumber<uint32_t>(L, 1);
		if (id >= Player::getFirstID() && id <= Player::getLastID()) {
			player = g_game().getPlayerByID(id, true);
		} else {
			player = g_game().getPlayerByGUID(id, true);
		}
	} else if (isString(L, 1)) {
		const auto name = getString(L, 1);
		player = g_game().getPlayerByName(name, true);
	}
	if (!player) {
		lua_pushnil(L);
	} else {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
	}

	return 1;
}

int GameFunctions::luaGameGetNormalizedPlayerName(lua_State* L) {
	// Game.getNormalizedPlayerName(name[, isNewName = false])
	const auto name = getString(L, 1);
	const auto isNewName = getBoolean(L, 2, false);
	const auto &player = g_game().getPlayerByName(name, true, isNewName);
	if (player) {
		pushString(L, player->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameGetNormalizedGuildName(lua_State* L) {
	// Game.getNormalizedGuildName(name)
	const auto name = getString(L, 1);
	const auto &guild = g_game().getGuildByName(name, true);
	if (guild) {
		pushString(L, guild->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GameFunctions::luaGameAddInfluencedMonster(lua_State* L) {
	// Game.addInfluencedMonster(monster)
	const auto &monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushboolean(L, g_game().addInfluencedMonster(monster));
	return 1;
}

int GameFunctions::luaGameRemoveInfluencedMonster(lua_State* L) {
	// Game.removeInfluencedMonster(monsterId)
	const uint32_t monsterId = getNumber<uint32_t>(L, 1);
	const auto create = getBoolean(L, 2, false);
	lua_pushnumber(L, g_game().removeInfluencedMonster(monsterId, create));
	return 1;
}

int GameFunctions::luaGameGetInfluencedMonsters(lua_State* L) {
	// Game.getInfluencedMonsters()
	const auto &monsters = g_game().getInfluencedMonsters();
	lua_createtable(L, static_cast<int>(monsters.size()), 0);
	int index = 0;
	for (const auto monsterId : monsters) {
		++index;
		lua_pushnumber(L, monsterId);
		lua_rawseti(L, -2, index);
	}

	return 1;
}

int GameFunctions::luaGameGetLadderIds(lua_State* L) {
	// Game.getLadderIds()
	const auto &ladders = Item::items.getLadders();
	lua_createtable(L, static_cast<int>(ladders.size()), 0);
	int index = 0;
	for (const auto &ladderId : ladders) {
		++index;
		lua_pushnumber(L, static_cast<lua_Number>(ladderId));
		lua_rawseti(L, -2, index);
	}

	return 1;
}

int GameFunctions::luaGameGetDummies(lua_State* L) {
	/**
	 * @brief Retrieve dummy IDs categorized by type.
	 * @details This function provides a table containing two sub-tables: one for free dummies and one for house (or premium) dummies.

	* @note usage on lua:
	    local dummies = Game.getDummies()
	    local rate = dummies[1] -- Retrieve dummy rate
	*/

	const auto &dummies = Item::items.getDummys();
	lua_createtable(L, dummies.size(), 0);
	for (const auto &[dummyId, rate] : dummies) {
		lua_pushnumber(L, static_cast<lua_Number>(rate));
		lua_rawseti(L, -2, dummyId);
	}
	return 1;
}

int GameFunctions::luaGameMakeFiendishMonster(lua_State* L) {
	// Game.makeFiendishMonster(monsterId[default= 0])
	const auto monsterId = getNumber<uint32_t>(L, 1, 0);
	const auto createForgeableMonsters = getBoolean(L, 2, false);
	lua_pushnumber(L, g_game().makeFiendishMonster(monsterId, createForgeableMonsters));
	return 1;
}

int GameFunctions::luaGameRemoveFiendishMonster(lua_State* L) {
	// Game.removeFiendishMonster(monsterId)
	const uint32_t monsterId = getNumber<uint32_t>(L, 1);
	const auto create = getBoolean(L, 2, false);
	lua_pushnumber(L, g_game().removeFiendishMonster(monsterId, create));
	return 1;
}

int GameFunctions::luaGameGetFiendishMonsters(lua_State* L) {
	// Game.getFiendishMonsters()
	const auto &monsters = g_game().getFiendishMonsters();

	lua_createtable(L, static_cast<int>(monsters.size()), 0);
	int index = 0;
	for (const auto monsterId : monsters) {
		++index;
		lua_pushnumber(L, monsterId);
		lua_rawseti(L, -2, index);
	}

	return 1;
}

int GameFunctions::luaGameGetBoostedBoss(lua_State* L) {
	// Game.getBoostedBoss()
	pushString(L, g_ioBosstiary().getBoostedBossName());
	return 1;
}

int GameFunctions::luaGameGetTalkActions(lua_State* L) {
	// Game.getTalkActions()
	const auto talkactionsMap = g_talkActions().getTalkActionsMap();
	lua_createtable(L, static_cast<int>(talkactionsMap.size()), 0);

	for (const auto &[talkName, talkactionSharedPtr] : talkactionsMap) {
		pushUserdata<TalkAction>(L, talkactionSharedPtr);
		setMetatable(L, -1, "TalkAction");
		lua_setfield(L, -2, talkName.c_str());
	}
	return 1;
}

int GameFunctions::luaGameGetEventCallbacks(lua_State* L) {
	lua_createtable(L, 0, 0);
	lua_pushcfunction(L, EventCallbackFunctions::luaEventCallbackLoad);
	for (const auto &[value, name] : magic_enum::enum_entries<EventCallback_t>()) {
		if (value != EventCallback_t::none) {
			std::string methodName = magic_enum::enum_name(value).data();
			lua_pushstring(L, methodName.c_str());
			// Copy the function reference to the top of the stack
			lua_pushvalue(L, -2);
			lua_settable(L, -4);
		}
	}
	// Pop the function
	lua_pop(L, 1);
	return 1;
}

int GameFunctions::luaGameRegisterAchievement(lua_State* L) {
	// Game.registerAchievement(id, name, description, secret, grade, points)
	if (lua_gettop(L) < 6) {
		reportErrorFunc("Achievement can only be registered with all params.");
		return 1;
	}

	const uint16_t id = getNumber<uint16_t>(L, 1);
	const std::string name = getString(L, 2);
	const std::string description = getString(L, 3);
	const bool secret = getBoolean(L, 4);
	const uint8_t grade = getNumber<uint8_t>(L, 5);
	const uint8_t points = getNumber<uint8_t>(L, 6);
	g_game().registerAchievement(id, name, description, secret, grade, points);
	pushBoolean(L, true);
	return 1;
}

int GameFunctions::luaGameGetAchievementInfoById(lua_State* L) {
	// Game.getAchievementInfoById(id)
	const uint16_t id = getNumber<uint16_t>(L, 1);
	const Achievement achievement = g_game().getAchievementById(id);
	if (achievement.id == 0) {
		reportErrorFunc("Achievement id is wrong");
		return 1;
	}

	lua_createtable(L, 0, 6);
	setField(L, "id", achievement.id);
	setField(L, "name", achievement.name);
	setField(L, "description", achievement.description);
	setField(L, "points", achievement.points);
	setField(L, "grade", achievement.grade);
	setField(L, "secret", achievement.secret);
	return 1;
}

int GameFunctions::luaGameGetAchievementInfoByName(lua_State* L) {
	// Game.getAchievementInfoByName(name)
	const std::string name = getString(L, 1);
	const Achievement achievement = g_game().getAchievementByName(name);
	if (achievement.id == 0) {
		reportErrorFunc("Achievement name is wrong");
		return 1;
	}

	lua_createtable(L, 0, 6);
	setField(L, "id", achievement.id);
	setField(L, "name", achievement.name);
	setField(L, "description", achievement.description);
	setField(L, "points", achievement.points);
	setField(L, "grade", achievement.grade);
	setField(L, "secret", achievement.secret);
	return 1;
}

int GameFunctions::luaGameGetSecretAchievements(lua_State* L) {
	// Game.getSecretAchievements()
	const std::vector<Achievement> &achievements = g_game().getSecretAchievements();
	int index = 0;
	lua_createtable(L, achievements.size(), 0);
	for (const auto &achievement : achievements) {
		lua_createtable(L, 0, 6);
		setField(L, "id", achievement.id);
		setField(L, "name", achievement.name);
		setField(L, "description", achievement.description);
		setField(L, "points", achievement.points);
		setField(L, "grade", achievement.grade);
		setField(L, "secret", achievement.secret);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameGetPublicAchievements(lua_State* L) {
	// Game.getPublicAchievements()
	const std::vector<Achievement> &achievements = g_game().getPublicAchievements();
	int index = 0;
	lua_createtable(L, achievements.size(), 0);
	for (const auto &achievement : achievements) {
		lua_createtable(L, 0, 6);
		setField(L, "id", achievement.id);
		setField(L, "name", achievement.name);
		setField(L, "description", achievement.description);
		setField(L, "points", achievement.points);
		setField(L, "grade", achievement.grade);
		setField(L, "secret", achievement.secret);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GameFunctions::luaGameGetAchievements(lua_State* L) {
	// Game.getAchievements()
	const std::map<uint16_t, Achievement> &achievements = g_game().getAchievements();
	int index = 0;
	lua_createtable(L, achievements.size(), 0);
	for (const auto &achievement_it : achievements) {
		lua_createtable(L, 0, 6);
		setField(L, "id", achievement_it.first);
		setField(L, "name", achievement_it.second.name);
		setField(L, "description", achievement_it.second.description);
		setField(L, "points", achievement_it.second.points);
		setField(L, "grade", achievement_it.second.grade);
		setField(L, "secret", achievement_it.second.secret);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}
