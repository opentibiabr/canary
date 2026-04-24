/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/game_functions.hpp"

#include "core.hpp"
#include "items/items_classification.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/player.hpp"
#include "game/functions/game_reload.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "io/io_bosstiary.hpp"
#include "io/iobestiary.hpp"
#include "items/item.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"
#include "lua/creature/talkaction.hpp"
#include "lua/functions/creatures/npc/npc_type_functions.hpp"
#include "lua/functions/events/event_callback_functions.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "map/spectators.hpp"
#include "lua/functions/lua_functions_loader.hpp"

#include <sol/sol.hpp>

void GameFunctions::init(lua_State* L) {
	sol::state_view lua(L);
	auto game = lua.create_named_table("Game");

	// Helpers to push objects with legacy metatables
	auto pushCreature = [](lua_State* L, std::shared_ptr<Creature> c) {
		if (!c) {
			return sol::make_object(L, sol::lua_nil);
		}
		Lua::pushUserdata<Creature>(L, c);
		Lua::setCreatureMetatable(L, -1, c);
		return sol::stack::pop<sol::object>(L);
	};

	auto pushItem = [](lua_State* L, std::shared_ptr<Item> i) {
		if (!i) {
			return sol::make_object(L, sol::lua_nil);
		}
		Lua::pushUserdata<Item>(L, i);
		Lua::setItemMetatable(L, -1, i);
		return sol::stack::pop<sol::object>(L);
	};

	auto pushObjectWithMeta = []<typename T>(lua_State* L, std::shared_ptr<T> obj, const std::string &metaName) {
		if (!obj) {
			return sol::make_object(L, sol::lua_nil);
		}
		Lua::pushUserdata<T>(L, obj);
		Lua::setMetatable(L, -1, metaName);
		return sol::stack::pop<sol::object>(L);
	};

	auto pushRawObjectWithMeta = []<typename T>(lua_State* L, const T* obj, const std::string &metaName) {
		if (!obj) {
			return sol::make_object(L, sol::lua_nil);
		}
		Lua::pushUserdata<const T>(L, obj);
		Lua::setMetatable(L, -1, metaName);
		return sol::stack::pop<sol::object>(L);
	};

	game.set_function("createNpcType", &NpcTypeFunctions::luaNpcTypeCreate);

	game.set_function("createMonsterType", [pushObjectWithMeta](sol::this_state s, std::string name, sol::optional<std::string> variant, sol::optional<std::string> alternateName) {
		std::string uniqueName = name;
		std::string variantStr = variant.value_or("");
		std::string alternateNameStr = alternateName.value_or("");

		std::set<std::string> names;
		const auto monsterType = std::make_shared<MonsterType>(name);

		if (variantStr.starts_with("!")) {
			names.insert(name);
			variantStr = variantStr.substr(1);
		}
		if (!variantStr.empty()) {
			uniqueName = variantStr + "|" + name;
		}
		names.insert(uniqueName);

		monsterType->name = name;
		if (!alternateNameStr.empty()) {
			names.insert(alternateNameStr);
			monsterType->name = alternateNameStr;
		}

		monsterType->variantName = variantStr;
		monsterType->nameDescription = "a " + name;

		for (const auto &altName : names) {
			if (!g_monsters().tryAddMonsterType(altName, monsterType)) {
				Lua::reportErrorFunc(fmt::format("The monster with name {} already registered", altName));
				return sol::make_object(s.lua_state(), sol::lua_nil);
			}
		}

		return pushObjectWithMeta(s.lua_state(), monsterType, "MonsterType");
	});

	game.set_function("getMonsterTypeByName", [pushObjectWithMeta](sol::this_state s, std::string name) {
		const auto &mType = g_monsters().getMonsterType(name);
		if (!mType) {
			Lua::reportErrorFunc(fmt::format("MonsterType with name {} not found", name));
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}
		return pushObjectWithMeta(s.lua_state(), mType, "MonsterType");
	});

	game.set_function("getSpectators", [pushCreature](sol::this_state s, sol::table positionTable, sol::optional<bool> multifloor, sol::optional<bool> onlyPlayers, sol::optional<int32_t> minRangeX, sol::optional<int32_t> maxRangeX, sol::optional<int32_t> minRangeY, sol::optional<int32_t> maxRangeY) {
		Position position(
			static_cast<uint16_t>(positionTable["x"].get_or(0)),
			static_cast<uint16_t>(positionTable["y"].get_or(0)),
			static_cast<uint8_t>(positionTable["z"].get_or(0))
		);

		Spectators spectators;
		if (onlyPlayers.value_or(false)) {
			spectators.find<Player>(position, multifloor.value_or(false), minRangeX.value_or(0), maxRangeX.value_or(0), minRangeY.value_or(0), maxRangeY.value_or(0));
		} else {
			spectators.find<Creature>(position, multifloor.value_or(false), minRangeX.value_or(0), maxRangeX.value_or(0), minRangeY.value_or(0), maxRangeY.value_or(0));
		}

		std::vector<sol::object> result;
		sol::state_view L = s;
		for (const auto &creature : spectators) {
			result.push_back(pushCreature(L.lua_state(), creature));
		}
		return sol::as_table(result);
	});

	game.set_function("getBoostedCreature", []() {
		return g_game().getBoostedMonsterName();
	});

	game.set_function("getBestiaryList", [](sol::this_state s, sol::optional<sol::object> arg, sol::optional<bool> name) {
		std::map<uint16_t, std::string> resultList;
		bool useName = false;

		if (!arg) {
			resultList = g_game().getBestiaryList();
			if (name) {
				useName = name.value();
			}
		} else {
			if (arg->is<bool>()) {
				resultList = g_game().getBestiaryList();
				useName = arg->as<bool>();
			} else {
				if (name) {
					useName = name.value();
				}
				if (arg->is<double>()) {
					resultList = g_iobestiary().findRaceByName("CANARY", false, static_cast<BestiaryType_t>(arg->as<int>()));
				} else {
					resultList = g_iobestiary().findRaceByName(arg->as<std::string>());
				}
			}
		}

		std::vector<sol::object> list;
		sol::state_view L = s;
		for (const auto &pair : resultList) {
			if (useName) {
				list.push_back(sol::make_object(L, pair.second));
			} else {
				list.push_back(sol::make_object(L, pair.first));
			}
		}
		return sol::as_table(list);
	});

	game.set_function("getPlayers", [pushCreature](sol::this_state s) {
		std::vector<sol::object> players;
		sol::state_view L = s;
		for (const auto &playerEntry : g_game().getPlayers()) {
			players.push_back(pushCreature(L.lua_state(), playerEntry.second));
		}
		return sol::as_table(players);
	});

	game.set_function("loadMap", [](std::string path) {
		g_dispatcher().addEvent([path]() { g_game().loadMap(path); }, "Game.loadMap");
	});

	game.set_function("loadMapChunk", [](std::string path, sol::table positionTable) {
		Position position(
			static_cast<uint16_t>(positionTable["x"].get_or(0)),
			static_cast<uint16_t>(positionTable["y"].get_or(0)),
			static_cast<uint8_t>(positionTable["z"].get_or(0))
		);
		g_dispatcher().addEvent([path, position]() { g_game().loadMap(path, position); }, "Game.loadMapChunk");
	});

	game.set_function("getExperienceForLevel", [](uint32_t level) {
		if (level == 0) {
			Lua::reportErrorFunc("Level must be greater than 0.");
			return 0.0;
		}
		return static_cast<double>(Player::getExpForLevel(level));
	});

	game.set_function("getMonsterCount", []() { return g_game().getMonstersOnline(); });
	game.set_function("getPlayerCount", []() { return g_game().getPlayersOnline(); });
	game.set_function("getNpcCount", []() { return g_game().getNpcsOnline(); });

	game.set_function("getMonsterTypes", [pushObjectWithMeta](sol::this_state s) {
		sol::state_view L = s;
		sol::table table = L.create_table();
		for (const auto &[typeName, mType] : g_monsters().monsters) {
			table[typeName] = pushObjectWithMeta(L.lua_state(), mType, "MonsterType");
		}
		return table;
	});

	game.set_function("getTowns", [pushObjectWithMeta](sol::this_state s) {
		std::vector<sol::object> towns;
		sol::state_view L = s;
		for (const auto &townEntry : g_game().map.towns.getTowns()) {
			towns.push_back(pushObjectWithMeta(L.lua_state(), townEntry.second, "Town"));
		}
		return sol::as_table(towns);
	});

	game.set_function("getHouses", [pushObjectWithMeta](sol::this_state s) {
		std::vector<sol::object> houses;
		sol::state_view L = s;
		for (const auto &houseEntry : g_game().map.houses.getHouses()) {
			houses.push_back(pushObjectWithMeta(L.lua_state(), houseEntry.second, "House"));
		}
		return sol::as_table(houses);
	});

	game.set_function("getGameState", []() { return g_game().getGameState(); });
	game.set_function("setGameState", [](GameState_t state) { g_game().setGameState(state); return true; });
	game.set_function("getWorldType", []() { return g_game().getWorldType(); });
	game.set_function("setWorldType", [](WorldType_t type) { g_game().setWorldType(type); return true; });
	game.set_function("getReturnMessage", [](ReturnValue value) { return getReturnMessage(value); });

	game.set_function("createItem", [pushItem](sol::this_state s, sol::object idOrName, sol::optional<int32_t> countOpt, sol::optional<sol::table> posOpt) {
		uint16_t itemId;
		if (idOrName.is<uint16_t>()) {
			itemId = idOrName.as<uint16_t>();
		} else {
			itemId = Item::items.getItemIdByName(idOrName.as<std::string>());
			if (itemId == 0) {
				return sol::make_object(s.lua_state(), sol::lua_nil);
			}
		}

		int32_t count = countOpt.value_or(1);
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
		if (posOpt) {
			position = Position(
				static_cast<uint16_t>(posOpt.value()["x"].get_or(0)),
				static_cast<uint16_t>(posOpt.value()["y"].get_or(0)),
				static_cast<uint8_t>(posOpt.value()["z"].get_or(0))
			);
		}

		const bool hasTable = itemCount > 1;
		sol::state_view L = s;

		sol::object result = sol::lua_nil;
		sol::table resultTable;
		if (hasTable) {
			resultTable = L.create_table();
		}

		if (itemCount == 0) {
			return sol::make_object(L.lua_state(), sol::lua_nil);
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
					return sol::make_object(L.lua_state(), sol::lua_nil);
				}
				return sol::make_object(L, resultTable);
			}

			if (position.x != 0) {
				const auto &tile = g_game().map.getTile(position);
				if (!tile) {
					if (!hasTable) {
						return sol::make_object(L.lua_state(), sol::lua_nil);
					}
					return sol::make_object(L, resultTable);
				}

				ReturnValue ret = g_game().internalAddItem(tile, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
				if (ret != RETURNVALUE_NOERROR) {
					if (!hasTable) {
						return sol::make_object(L.lua_state(), sol::lua_nil);
					}
					return sol::make_object(L, resultTable);
				}
			} else {
				Lua::getScriptEnv()->addTempItem(item);
				item->setParent(VirtualCylinder::virtualCylinder);
			}

			if (hasTable) {
				resultTable[i] = pushItem(L.lua_state(), item);
			} else {
				result = pushItem(L.lua_state(), item);
			}
		}

		if (hasTable) {
			return sol::make_object(L, resultTable);
		}
		return result;
	});

	game.set_function("createContainer", [pushItem](sol::this_state s, sol::object idOrName, uint16_t size, sol::optional<sol::table> posOpt) {
		uint16_t id;
		if (idOrName.is<uint16_t>()) {
			id = idOrName.as<uint16_t>();
		} else {
			id = Item::items.getItemIdByName(idOrName.as<std::string>());
			if (id == 0) {
				return sol::make_object(s.lua_state(), sol::lua_nil);
			}
		}

		const auto &container = Item::CreateItemAsContainer(id, size);
		if (!container) {
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}

		if (posOpt) {
			Position position(
				static_cast<uint16_t>(posOpt.value()["x"].get_or(0)),
				static_cast<uint16_t>(posOpt.value()["y"].get_or(0)),
				static_cast<uint8_t>(posOpt.value()["z"].get_or(0))
			);
			const auto &tile = g_game().map.getTile(position);
			if (!tile) {
				return sol::make_object(s.lua_state(), sol::lua_nil);
			}

			g_game().internalAddItem(tile, container, INDEX_WHEREEVER, FLAG_NOLIMIT);
		} else {
			Lua::getScriptEnv()->addTempItem(container);
			container->setParent(VirtualCylinder::virtualCylinder);
		}

		return pushItem(s.lua_state(), container);
	});

	game.set_function("createMonster", [pushCreature](sol::this_state s, std::string monsterName, sol::table positionTable, sol::optional<bool> extended, sol::optional<bool> force, sol::optional<std::shared_ptr<Creature>> master) {
		const auto &monster = Monster::createMonster(monsterName);
		if (!monster) {
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}

		bool isSummon = false;
		if (master && master.value()) {
			monster->setMaster(master.value(), true);
			isSummon = true;
		}

		Position position(
			static_cast<uint16_t>(positionTable["x"].get_or(0)),
			static_cast<uint16_t>(positionTable["y"].get_or(0)),
			static_cast<uint8_t>(positionTable["z"].get_or(0))
		);

		if (g_game().placeCreature(monster, position, extended.value_or(false), force.value_or(false))) {
			monster->onSpawn(position);
			const auto &mtype = monster->getMonsterType();
			if (mtype && mtype->info.raceid > 0 && mtype->info.bosstiaryRace == BosstiaryRarity_t::RARITY_ARCHFOE) {
				for (const auto &spectator : Spectators().find<Player>(monster->getPosition(), true)) {
					if (const auto &tmpPlayer = spectator->getPlayer()) {
						tmpPlayer->sendBosstiaryCooldownTimer();
					}
				}
			}
			return pushCreature(s.lua_state(), monster);
		} else {
			if (isSummon) {
				monster->setMaster(nullptr);
			}
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}
	});

	game.set_function("createSoulPitMonster", [pushCreature](sol::this_state s, std::string monsterName, sol::table positionTable, sol::optional<uint8_t> stack, sol::optional<bool> extended, sol::optional<bool> force, sol::optional<std::shared_ptr<Creature>> master) {
		const auto &monster = Monster::createMonster(monsterName);
		if (!monster) {
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}

		bool isSummon = false;
		if (master && master.value()) {
			monster->setMaster(master.value(), true);
			isSummon = true;
		}

		Position position(
			static_cast<uint16_t>(positionTable["x"].get_or(0)),
			static_cast<uint16_t>(positionTable["y"].get_or(0)),
			static_cast<uint8_t>(positionTable["z"].get_or(0))
		);

		if (g_game().placeCreature(monster, position, extended.value_or(false), force.value_or(false))) {
			monster->setSoulPitStack(stack.value_or(1));
			monster->onSpawn(position);
			return pushCreature(s.lua_state(), monster);
		} else {
			if (isSummon) {
				monster->setMaster(nullptr);
			}
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}
	});

	game.set_function("createNpc", [pushCreature](sol::this_state s, std::string npcName, sol::table positionTable, sol::optional<bool> extended, sol::optional<bool> force) {
		const auto &npc = Npc::createNpc(npcName);
		if (!npc) {
			return sol::make_object(s.lua_state(), sol::lua_nil);
		}

		Position position(
			static_cast<uint16_t>(positionTable["x"].get_or(0)),
			static_cast<uint16_t>(positionTable["y"].get_or(0)),
			static_cast<uint8_t>(positionTable["z"].get_or(0))
		);

		if (g_game().placeCreature(npc, position, extended.value_or(false), force.value_or(false))) {
			return pushCreature(s.lua_state(), npc);
		}
		return sol::make_object(s.lua_state(), sol::lua_nil);
	});

	game.set_function("generateNpc", [pushCreature](sol::this_state s, std::string npcName) {
		return pushCreature(s.lua_state(), Npc::createNpc(npcName));
	});

	game.set_function("createTile", [pushObjectWithMeta](sol::this_state s, sol::object arg1, sol::optional<sol::object> arg2, sol::optional<sol::object> arg3, sol::optional<sol::object> arg4) {
		Position position;
		bool isDynamic = false;

		if (arg1.is<sol::table>()) {
			sol::table t = arg1.as<sol::table>();
			position = Position(
				static_cast<uint16_t>(t["x"].get_or(0)),
				static_cast<uint16_t>(t["y"].get_or(0)),
				static_cast<uint8_t>(t["z"].get_or(0))
			);
			if (arg2 && arg2->is<bool>()) {
				isDynamic = arg2->as<bool>();
			}
		} else {
			position.x = arg1.as<uint16_t>();
			if (arg2) {
				position.y = arg2->as<uint16_t>();
			}
			if (arg3) {
				position.z = arg3->as<uint8_t>();
			}
			if (arg4 && arg4->is<bool>()) {
				isDynamic = arg4->as<bool>();
			}
		}
		return pushObjectWithMeta(s.lua_state(), g_game().map.getOrCreateTile(position, isDynamic), "Tile");
	});

	game.set_function("getBestiaryCharm", []() {
		return g_game().getCharmList();
	});

	game.set_function("createBestiaryCharm", [pushObjectWithMeta](sol::this_state s, int8_t id) {
		return pushObjectWithMeta(s.lua_state(), g_iobestiary().getBestiaryCharm(static_cast<charmRune_t>(id), true), "Charm");
	});

	game.set_function("createItemClassification", [pushRawObjectWithMeta](sol::this_state s, uint8_t id) {
		const ItemClassification* ic = g_game().getItemsClassification(id, true);
		return pushRawObjectWithMeta(s.lua_state(), ic, "ItemClassification");
	});

	game.set_function("startRaid", [](std::string raidName) {
		const auto &raid = g_game().raids.getRaidByName(raidName);
		if (!raid || !raid->isLoaded()) {
			return RETURNVALUE_NOSUCHRAIDEXISTS;
		}
		if (g_game().raids.getRunning()) {
			return RETURNVALUE_ANOTHERRAIDISALREADYEXECUTING;
		}

		g_game().raids.setRunning(raid);
		raid->startRaid();
		return RETURNVALUE_NOERROR;
	});

	game.set_function("getClientVersion", [](sol::this_state s) {
		sol::state_view L = s;
		sol::table t = L.create_table();
		t["min"] = CLIENT_VERSION;
		t["max"] = CLIENT_VERSION;
		t["string"] = fmt::format("{}.{}", CLIENT_VERSION_UPPER, CLIENT_VERSION_LOWER);
		return t;
	});

	game.set_function("reload", [](Reload_t reloadType, sol::this_state s) {
		if (GameReload::getReloadNumber(reloadType) == GameReload::getReloadNumber(Reload_t::RELOAD_TYPE_NONE)) {
			Lua::reportErrorFunc("Reload type is none");
			return false;
		}
		if (GameReload::getReloadNumber(reloadType) >= GameReload::getReloadNumber(Reload_t::RELOAD_TYPE_LAST)) {
			Lua::reportErrorFunc("Reload type not exist");
			return false;
		}
		bool res = GameReload::init(reloadType);
		lua_gc(s.lua_state(), LUA_GCCOLLECT, 0);
		return res;
	});

	game.set_function("hasEffect", [](uint16_t effectId) { return g_game().hasEffect(effectId); });
	game.set_function("hasDistanceEffect", [](uint16_t effectId) { return g_game().hasDistanceEffect(effectId); });

	game.set_function("getOfflinePlayer", [pushCreature](sol::this_state s, sol::object arg) {
		std::shared_ptr<Player> player = nullptr;
		if (arg.is<uint32_t>()) {
			uint32_t id = arg.as<uint32_t>();
			if (id >= Player::getFirstID() && id <= Player::getLastID()) {
				player = g_game().getPlayerByID(id, true);
			} else {
				player = g_game().getPlayerByGUID(id, true);
			}
		} else if (arg.is<std::string>()) {
			player = g_game().getPlayerByName(arg.as<std::string>(), true);
		}
		return pushCreature(s.lua_state(), player);
	});

	game.set_function("getNormalizedPlayerName", [](std::string name, sol::optional<bool> isNewName) -> sol::optional<std::string> {
		const auto &player = g_game().getPlayerByName(name, true, isNewName.value_or(false));
		if (player) {
			return player->getName();
		}
		return std::nullopt;
	});

	game.set_function("getNormalizedGuildName", [](std::string name) -> sol::optional<std::string> {
		const auto &guild = g_game().getGuildByName(name, true);
		if (guild) {
			return guild->getName();
		}
		return std::nullopt;
	});

	game.set_function("addInfluencedMonster", [](std::shared_ptr<Monster> monster) {
		if (!monster) {
			Lua::reportErrorFunc("Monster not found");
			return false;
		}
		return g_game().addInfluencedMonster(monster);
	});

	game.set_function("removeInfluencedMonster", [](uint32_t monsterId, sol::optional<bool> create) {
		return g_game().removeInfluencedMonster(monsterId, create.value_or(false));
	});

	game.set_function("getInfluencedMonsters", [](sol::this_state s) {
		sol::state_view L = s;
		sol::table t = L.create_table();
		int index = 1;
		for (const auto &val : g_game().getInfluencedMonsters()) {
			t[index++] = val;
		}
		return t;
	});

	game.set_function("makeFiendishMonster", [](sol::optional<uint32_t> monsterId, sol::optional<bool> create) {
		return g_game().makeFiendishMonster(monsterId.value_or(0), create.value_or(false));
	});

	game.set_function("removeFiendishMonster", [](uint32_t monsterId, sol::optional<bool> create) {
		return g_game().removeFiendishMonster(monsterId, create.value_or(false));
	});

	game.set_function("getFiendishMonsters", [](sol::this_state s) {
		sol::state_view L = s;
		sol::table t = L.create_table();
		int index = 1;
		for (const auto &val : g_game().getFiendishMonsters()) {
			t[index++] = val;
		}
		return t;
	});

	game.set_function("getBoostedBoss", []() {
		return g_ioBosstiary().getBoostedBossName();
	});

	game.set_function("getLadderIds", []() {
		return sol::as_table(Item::items.getLadders());
	});

	game.set_function("getDummies", [](sol::this_state s) {
		const auto &dummies = Item::items.getDummys();
		sol::table t = sol::state_view(s).create_table();
		for (const auto &[dummyId, rate] : dummies) {
			t[dummyId] = rate;
		}
		return t;
	});

	game.set_function("getTalkActions", [](sol::this_state s) {
		sol::state_view L = s;
		sol::table t = L.create_table();
		for (const auto &[talkName, talkactionSharedPtr] : g_talkActions().getTalkActionsMap()) {
			t[talkName] = talkactionSharedPtr;
		}
		return t;
	});

	game.set_function("getEventCallbacks", [](sol::this_state s) {
		sol::state_view L = s;
		sol::table t = L.create_table();

		auto func = sol::make_object(L, &EventCallbackFunctions::luaEventCallbackLoad);
		for (const auto &[value, name] : magic_enum::enum_entries<EventCallback_t>()) {
			if (value != EventCallback_t::none) {
				t[magic_enum::enum_name(value)] = func;
			}
		}
		return t;
	});

	game.set_function("registerAchievement", [](uint16_t id, std::string name, std::string description, bool secret, uint8_t grade, uint8_t points) {
		g_game().registerAchievement(id, name, description, secret, grade, points);
		return true;
	});

	game.set_function("getAchievementInfoById", [](uint16_t id, sol::this_state s) -> sol::object {
		const Achievement achievement = g_game().getAchievementById(id);
		if (achievement.id == 0) {
			Lua::reportErrorFunc("Achievement id is wrong");
			return sol::object(sol::lua_nil);
		}
		sol::state_view L = s;
		sol::table t = L.create_table();
		t["id"] = achievement.id;
		t["name"] = achievement.name;
		t["description"] = achievement.description;
		t["points"] = achievement.points;
		t["grade"] = achievement.grade;
		t["secret"] = achievement.secret;
		return t;
	});

	game.set_function("getAchievementInfoByName", [](std::string name, sol::this_state s) -> sol::object {
		const Achievement achievement = g_game().getAchievementByName(name);
		if (achievement.id == 0) {
			Lua::reportErrorFunc("Achievement name is wrong");
			return sol::object(sol::lua_nil);
		}
		sol::state_view L = s;
		sol::table t = L.create_table();
		t["id"] = achievement.id;
		t["name"] = achievement.name;
		t["description"] = achievement.description;
		t["points"] = achievement.points;
		t["grade"] = achievement.grade;
		t["secret"] = achievement.secret;
		return t;
	});

	auto achievementToTable = [](sol::state_view L, const Achievement &a) {
		sol::table t = L.create_table();
		t["id"] = a.id;
		t["name"] = a.name;
		t["description"] = a.description;
		t["points"] = a.points;
		t["grade"] = a.grade;
		t["secret"] = a.secret;
		return t;
	};

	game.set_function("getSecretAchievements", [achievementToTable](sol::this_state s) {
		sol::state_view L = s;
		std::vector<sol::table> list;
		for (const auto &a : g_game().getSecretAchievements()) {
			list.push_back(achievementToTable(L, a));
		}
		return sol::as_table(list);
	});

	game.set_function("getPublicAchievements", [achievementToTable](sol::this_state s) {
		sol::state_view L = s;
		std::vector<sol::table> list;
		for (const auto &a : g_game().getPublicAchievements()) {
			list.push_back(achievementToTable(L, a));
		}
		return sol::as_table(list);
	});

	game.set_function("getAchievements", [achievementToTable](sol::this_state s) {
		sol::state_view L = s;
		std::vector<sol::table> list;
		for (const auto &entry : g_game().getAchievements()) {
			list.push_back(achievementToTable(L, entry.second));
		}
		return sol::as_table(list);
	});

	game.set_function("getSoulCoreItems", [pushRawObjectWithMeta](sol::this_state s) {
		sol::state_view L = s;
		sol::table t = L.create_table();
		int index = 1;
		for (const auto &itemType : Item::items.getItems()) {
			if (itemType.m_primaryType == "SoulCores" || itemType.type == ITEM_TYPE_SOULCORES) {
				t[index++] = pushRawObjectWithMeta(L.lua_state(), &itemType, "ItemType");
			}
		}
		return t;
	});

	game.set_function("getMonstersByRace", [](BestiaryType_t race) {
		return sol::as_table(g_monsters().getMonstersByRace(race));
	});

	game.set_function("getMonstersByBestiaryStars", [](uint8_t stars) {
		return sol::as_table(g_monsters().getMonstersByBestiaryStars(stars));
	});
}
