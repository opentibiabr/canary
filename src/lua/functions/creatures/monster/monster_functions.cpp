/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/monster/monster_functions.hpp"

#include "config/configmanager.hpp"
#include "creatures/creature.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/events_scheduler.hpp"
#include "map/spectators.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void MonsterFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Monster", "Creature", MonsterFunctions::luaMonsterCreate);
	Lua::registerMetaMethod(L, "Monster", "__eq", Lua::luaUserdataCompare);
	Lua::registerMethod(L, "Monster", "isMonster", MonsterFunctions::luaMonsterIsMonster);
	Lua::registerMethod(L, "Monster", "getType", MonsterFunctions::luaMonsterGetType);
	Lua::registerMethod(L, "Monster", "setType", MonsterFunctions::luaMonsterSetType);
	Lua::registerMethod(L, "Monster", "getSpawnPosition", MonsterFunctions::luaMonsterGetSpawnPosition);
	Lua::registerMethod(L, "Monster", "isInSpawnRange", MonsterFunctions::luaMonsterIsInSpawnRange);
	Lua::registerMethod(L, "Monster", "isIdle", MonsterFunctions::luaMonsterIsIdle);
	Lua::registerMethod(L, "Monster", "setIdle", MonsterFunctions::luaMonsterSetIdle);
	Lua::registerMethod(L, "Monster", "isTarget", MonsterFunctions::luaMonsterIsTarget);
	Lua::registerMethod(L, "Monster", "isOpponent", MonsterFunctions::luaMonsterIsOpponent);
	Lua::registerMethod(L, "Monster", "isFriend", MonsterFunctions::luaMonsterIsFriend);
	Lua::registerMethod(L, "Monster", "addFriend", MonsterFunctions::luaMonsterAddFriend);
	Lua::registerMethod(L, "Monster", "removeFriend", MonsterFunctions::luaMonsterRemoveFriend);
	Lua::registerMethod(L, "Monster", "getFriendList", MonsterFunctions::luaMonsterGetFriendList);
	Lua::registerMethod(L, "Monster", "getFriendCount", MonsterFunctions::luaMonsterGetFriendCount);
	Lua::registerMethod(L, "Monster", "addTarget", MonsterFunctions::luaMonsterAddTarget);
	Lua::registerMethod(L, "Monster", "removeTarget", MonsterFunctions::luaMonsterRemoveTarget);
	Lua::registerMethod(L, "Monster", "getTargetList", MonsterFunctions::luaMonsterGetTargetList);
	Lua::registerMethod(L, "Monster", "getTargetCount", MonsterFunctions::luaMonsterGetTargetCount);
	Lua::registerMethod(L, "Monster", "changeTargetDistance", MonsterFunctions::luaMonsterChangeTargetDistance);
	Lua::registerMethod(L, "Monster", "isChallenged", MonsterFunctions::luaMonsterIsChallenged);
	Lua::registerMethod(L, "Monster", "selectTarget", MonsterFunctions::luaMonsterSelectTarget);
	Lua::registerMethod(L, "Monster", "searchTarget", MonsterFunctions::luaMonsterSearchTarget);
	Lua::registerMethod(L, "Monster", "setSpawnPosition", MonsterFunctions::luaMonsterSetSpawnPosition);
	Lua::registerMethod(L, "Monster", "getRespawnType", MonsterFunctions::luaMonsterGetRespawnType);

	Lua::registerMethod(L, "Monster", "getTimeToChangeFiendish", MonsterFunctions::luaMonsterGetTimeToChangeFiendish);
	Lua::registerMethod(L, "Monster", "setTimeToChangeFiendish", MonsterFunctions::luaMonsterSetTimeToChangeFiendish);
	Lua::registerMethod(L, "Monster", "getMonsterForgeClassification", MonsterFunctions::luaMonsterGetMonsterForgeClassification);
	Lua::registerMethod(L, "Monster", "setMonsterForgeClassification", MonsterFunctions::luaMonsterSetMonsterForgeClassification);
	Lua::registerMethod(L, "Monster", "getForgeStack", MonsterFunctions::luaMonsterGetForgeStack);
	Lua::registerMethod(L, "Monster", "setForgeStack", MonsterFunctions::luaMonsterSetForgeStack);
	Lua::registerMethod(L, "Monster", "configureForgeSystem", MonsterFunctions::luaMonsterConfigureForgeSystem);
	Lua::registerMethod(L, "Monster", "clearFiendishStatus", MonsterFunctions::luaMonsterClearFiendishStatus);
	Lua::registerMethod(L, "Monster", "isForgeable", MonsterFunctions::luaMonsterIsForgeable);

	Lua::registerMethod(L, "Monster", "getName", MonsterFunctions::luaMonsterGetName);
	Lua::registerMethod(L, "Monster", "setName", MonsterFunctions::luaMonsterSetName);

	Lua::registerMethod(L, "Monster", "hazard", MonsterFunctions::luaMonsterHazard);
	Lua::registerMethod(L, "Monster", "hazardCrit", MonsterFunctions::luaMonsterHazardCrit);
	Lua::registerMethod(L, "Monster", "hazardDodge", MonsterFunctions::luaMonsterHazardDodge);
	Lua::registerMethod(L, "Monster", "hazardDamageBoost", MonsterFunctions::luaMonsterHazardDamageBoost);
	Lua::registerMethod(L, "Monster", "hazardDefenseBoost", MonsterFunctions::luaMonsterHazardDefenseBoost);

	Lua::registerMethod(L, "Monster", "addReflectElement", MonsterFunctions::luaMonsterAddReflectElement);
	Lua::registerMethod(L, "Monster", "addDefense", MonsterFunctions::luaMonsterAddDefense);
	Lua::registerMethod(L, "Monster", "getDefense", MonsterFunctions::luaMonsterGetDefense);

	Lua::registerMethod(L, "Monster", "isDead", MonsterFunctions::luaMonsterIsDead);
	Lua::registerMethod(L, "Monster", "immune", MonsterFunctions::luaMonsterImmune);

	CharmFunctions::init(L);
	LootFunctions::init(L);
	MonsterSpellFunctions::init(L);
	MonsterTypeFunctions::init(L);
}

int MonsterFunctions::luaMonsterCreate(lua_State* L) {
	// Monster(id or userdata)
	std::shared_ptr<Monster> monster;
	if (Lua::isNumber(L, 2)) {
		monster = g_game().getMonsterByID(Lua::getNumber<uint32_t>(L, 2));
	} else if (Lua::isUserdata(L, 2)) {
		if (Lua::getUserdataType(L, 2) != LuaData_t::Monster) {
			lua_pushnil(L);
			return 1;
		}
		monster = Lua::getUserdataShared<Monster>(L, 2);
	} else {
		monster = nullptr;
	}

	if (monster) {
		Lua::pushUserdata<Monster>(L, monster);
		Lua::setMetatable(L, -1, "Monster");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsMonster(lua_State* L) {
	// monster:isMonster()
	Lua::pushBoolean(L, Lua::getUserdataShared<Monster>(L, 1) != nullptr);
	return 1;
}

int MonsterFunctions::luaMonsterGetType(lua_State* L) {
	// monster:getType()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		Lua::pushUserdata<MonsterType>(L, monster->mType);
		Lua::setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetType(lua_State* L) {
	// monster:setType(name or raceid, restoreHealth = false)
	bool restoreHealth = Lua::getBoolean(L, 3, false);
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<MonsterType> mType;
		if (Lua::isNumber(L, 2)) {
			mType = g_monsters().getMonsterTypeByRaceId(Lua::getNumber<uint16_t>(L, 2));
		} else {
			mType = g_monsters().getMonsterType(Lua::getString(L, 2));
		}
		// Unregister creature events (current MonsterType)
		for (const std::string &scriptName : monster->mType->info.scripts) {
			if (!monster->unregisterCreatureEvent(scriptName)) {
				g_logger().warn("[Warning - MonsterFunctions::luaMonsterSetType] Unknown event name: {}", scriptName);
			}
		}
		// Assign new MonsterType
		monster->mType = mType;
		monster->nameDescription = asLowerCaseString(mType->nameDescription);
		monster->defaultOutfit = mType->info.outfit;
		monster->currentOutfit = mType->info.outfit;
		monster->skull = mType->info.skull;
		if (restoreHealth) {
			auto multiplier = mType->getHealthMultiplier();
			monster->health = mType->info.health * multiplier;
			monster->healthMax = mType->info.healthMax * multiplier;
		} else {
			monster->health = monster->getHealth();
			monster->healthMax = monster->getMaxHealth();
		}
		monster->baseSpeed = mType->getBaseSpeed();
		monster->internalLight = mType->info.light;
		monster->hiddenHealth = mType->info.hiddenHealth;
		monster->targetDistance = mType->info.targetDistance;
		// Register creature events (new MonsterType)
		for (const std::string &scriptName : mType->info.scripts) {
			if (!monster->registerCreatureEvent(scriptName)) {
				g_logger().warn("[Warning - MonsterFunctions::luaMonsterSetType] Unknown event name: {}", scriptName);
			}
		}
		// Reload creature on spectators
		for (const auto &spectator : Spectators().find<Player>(monster->getPosition(), true)) {
			spectator->getPlayer()->sendCreatureReload(monster);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetSpawnPosition(lua_State* L) {
	// monster:getSpawnPosition()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		Lua::pushPosition(L, monster->getMasterPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsInSpawnRange(lua_State* L) {
	// monster:isInSpawnRange([position])
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		Lua::pushBoolean(L, monster->isInSpawnRange(lua_gettop(L) >= 2 ? Lua::getPosition(L, 2) : monster->getPosition()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsIdle(lua_State* L) {
	// monster:isIdle()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		Lua::pushBoolean(L, monster->getIdleStatus());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetIdle(lua_State* L) {
	// monster:setIdle(idle)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->setIdle(Lua::getBoolean(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterIsTarget(lua_State* L) {
	// monster:isTarget(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &creature = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, monster->isTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsOpponent(lua_State* L) {
	// monster:isOpponent(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &creature = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, monster->isOpponent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsFriend(lua_State* L) {
	// monster:isFriend(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &creature = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, monster->isFriend(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddFriend(lua_State* L) {
	// monster:addFriend(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &creature = Lua::getCreature(L, 2);
		monster->addFriend(creature);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterRemoveFriend(lua_State* L) {
	// monster:removeFriend(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &creature = Lua::getCreature(L, 2);
		monster->removeFriend(creature);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetFriendList(lua_State* L) {
	// monster:getFriendList()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto &friendList = monster->getFriendList();
	lua_createtable(L, friendList.size(), 0);

	int index = 0;
	for (const auto &creature : friendList) {
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetFriendCount(lua_State* L) {
	// monster:getFriendCount()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getFriendList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddTarget(lua_State* L) {
	// monster:addTarget(creature[, pushFront = false])
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto &creature = Lua::getCreature(L, 2);
	const bool pushFront = Lua::getBoolean(L, 3, false);
	monster->addTarget(creature, pushFront);
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterRemoveTarget(lua_State* L) {
	// monster:removeTarget(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->removeTarget(Lua::getCreature(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterGetTargetList(lua_State* L) {
	// monster:getTargetList()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto &targetList = monster->getTargetList();
	lua_createtable(L, targetList.size(), 0);

	int index = 0;
	for (const auto &creature : targetList) {
		Lua::pushUserdata<Creature>(L, creature);
		Lua::setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetTargetCount(lua_State* L) {
	// monster:getTargetCount()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getTargetList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterChangeTargetDistance(lua_State* L) {
	// monster:changeTargetDistance(distance[, duration = 12000])
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto distance = Lua::getNumber<int32_t>(L, 2, 1);
		const auto duration = Lua::getNumber<uint32_t>(L, 3, 12000);
		Lua::pushBoolean(L, monster->changeTargetDistance(distance, duration));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsChallenged(lua_State* L) {
	// monster:isChallenged()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		Lua::pushBoolean(L, monster->isChallenged());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSelectTarget(lua_State* L) {
	// monster:selectTarget(creature)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &creature = Lua::getCreature(L, 2);
		Lua::pushBoolean(L, monster->selectTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSearchTarget(lua_State* L) {
	// monster:searchTarget([searchType = TARGETSEARCH_DEFAULT])
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (monster) {
		const auto &searchType = Lua::getNumber<TargetSearchType_t>(L, 2, TARGETSEARCH_DEFAULT);
		Lua::pushBoolean(L, monster->searchTarget(searchType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetSpawnPosition(lua_State* L) {
	// monster:setSpawnPosition(interval)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t eventschedule = g_eventsScheduler().getSpawnMonsterSchedule();

	const Position &pos = monster->getPosition();
	monster->setMasterPos(pos);

	const auto &spawnMonster = g_game().map.spawnsMonster.getspawnMonsterList().emplace_back(std::make_shared<SpawnMonster>(pos, 5));
	uint32_t interval = Lua::getNumber<uint32_t>(L, 2, 90) * 1000 * 100 / std::max((uint32_t)1, (g_configManager().getNumber(RATE_SPAWN) * eventschedule));
	spawnMonster->addMonster(monster->mType->typeName, pos, DIRECTION_NORTH, static_cast<uint32_t>(interval));
	spawnMonster->startSpawnMonsterCheck();

	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterGetRespawnType(lua_State* L) {
	// monster:getRespawnType()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);

	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const RespawnType respawnType = monster->getRespawnType();
	lua_pushnumber(L, respawnType.period);
	Lua::pushBoolean(L, respawnType.underground);

	return 2;
}

int MonsterFunctions::luaMonsterGetTimeToChangeFiendish(lua_State* L) {
	// monster:getTimeToChangeFiendish()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(monster->getTimeToChangeFiendish()));
	return 1;
}

int MonsterFunctions::luaMonsterSetTimeToChangeFiendish(lua_State* L) {
	// monster:setTimeToChangeFiendish(endTime)
	const time_t endTime = Lua::getNumber<uint32_t>(L, 2, 1);
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->setTimeToChangeFiendish(endTime);
	return 1;
}

int MonsterFunctions::luaMonsterGetMonsterForgeClassification(lua_State* L) {
	// monster:getMonsterForgeClassification()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	const auto classification = static_cast<lua_Number>(monster->getMonsterForgeClassification());
	lua_pushnumber(L, classification);
	return 1;
}

int MonsterFunctions::luaMonsterSetMonsterForgeClassification(lua_State* L) {
	// monster:setMonsterForgeClassification(classication)
	const ForgeClassifications_t classification = Lua::getNumber<ForgeClassifications_t>(L, 2);
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->setMonsterForgeClassification(classification);
	return 1;
}

int MonsterFunctions::luaMonsterGetForgeStack(lua_State* L) {
	// monster:getForgeStack()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, monster->getForgeStack());
	return 1;
}

int MonsterFunctions::luaMonsterSetForgeStack(lua_State* L) {
	// monster:setForgeStack(stack)
	const auto stack = Lua::getNumber<uint16_t>(L, 2, 0);
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->setForgeStack(stack);
	const auto icon = stack < 15
		? CreatureIconModifications_t::Influenced
		: CreatureIconModifications_t::Fiendish;
	monster->setIcon("forge", CreatureIcon(icon, icon == CreatureIconModifications_t::Influenced ? static_cast<uint8_t>(stack) : 0));
	g_game().updateCreatureIcon(monster);
	g_game().sendUpdateCreature(monster);
	return 1;
}

int MonsterFunctions::luaMonsterConfigureForgeSystem(lua_State* L) {
	// monster:configureForgeSystem()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->configureForgeSystem();
	return 1;
}

int MonsterFunctions::luaMonsterClearFiendishStatus(lua_State* L) {
	// monster:clearFiendishStatus()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->clearFiendishStatus();
	return 1;
}

int MonsterFunctions::luaMonsterIsForgeable(lua_State* L) {
	// monster:isForgeable()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	Lua::pushBoolean(L, monster->canBeForgeMonster());
	return 1;
}

int MonsterFunctions::luaMonsterGetName(lua_State* L) {
	// monster:getName()
	const auto monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	Lua::pushString(L, monster->getName());
	return 1;
}

int MonsterFunctions::luaMonsterSetName(lua_State* L) {
	// monster:setName(name[, nameDescription])
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->setName(Lua::getString(L, 2));
	if (lua_gettop(L) >= 3) {
		monster->setNameDescription(Lua::getString(L, 3));
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterHazard(lua_State* L) {
	// get: monster:hazard() ; set: monster:hazard(hazard)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	const bool hazard = Lua::getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monster->getHazard());
		} else {
			monster->setHazard(hazard);
			Lua::pushBoolean(L, monster->getHazard());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardCrit(lua_State* L) {
	// get: monster:hazardCrit() ; set: monster:hazardCrit(hazardCrit)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	const bool hazardCrit = Lua::getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monster->getHazardSystemCrit());
		} else {
			monster->setHazardSystemCrit(hazardCrit);
			Lua::pushBoolean(L, monster->getHazardSystemCrit());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardDodge(lua_State* L) {
	// get: monster:hazardDodge() ; set: monster:hazardDodge(hazardDodge)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	const bool hazardDodge = Lua::getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monster->getHazardSystemDodge());
		} else {
			monster->setHazardSystemDodge(hazardDodge);
			Lua::pushBoolean(L, monster->getHazardSystemDodge());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardDamageBoost(lua_State* L) {
	// get: monster:hazardDamageBoost() ; set: monster:hazardDamageBoost(hazardDamageBoost)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	const bool hazardDamageBoost = Lua::getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monster->getHazardSystemDamageBoost());
		} else {
			monster->setHazardSystemDamageBoost(hazardDamageBoost);
			Lua::pushBoolean(L, monster->getHazardSystemDamageBoost());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardDefenseBoost(lua_State* L) {
	// get: monster:hazardDefenseBoost() ; set: monster:hazardDefenseBoost(hazardDefenseBoost)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	const bool hazardDefenseBoost = Lua::getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, monster->getHazardSystemDefenseBoost());
		} else {
			monster->setHazardSystemDefenseBoost(hazardDefenseBoost);
			Lua::pushBoolean(L, monster->getHazardSystemDefenseBoost());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddReflectElement(lua_State* L) {
	// monster:addReflectElement(type, percent)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	CombatType_t element = Lua::getNumber<CombatType_t>(L, 2);
	monster->addReflectElement(element, Lua::getNumber<int32_t>(L, 3));
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterAddDefense(lua_State* L) {
	// monster:addDefense(defense)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	monster->addDefense(Lua::getNumber<int32_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterGetDefense(lua_State* L) {
	// monster:getDefense(defense)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, monster->getDefense());
	return 1;
}

int MonsterFunctions::luaMonsterIsDead(lua_State* L) {
	// monster:isDead()
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	Lua::pushBoolean(L, monster->isDead());
	return 1;
}

int MonsterFunctions::luaMonsterImmune(lua_State* L) {
	// to get: isImmune = monster:immune()
	// to set and get: newImmuneBool = monster:immune(newImmuneBool)
	const auto &monster = Lua::getUserdataShared<Monster>(L, 1);
	if (!monster) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 0;
	}

	if (lua_gettop(L) > 1) {
		monster->setImmune(Lua::getBoolean(L, 2));
	}

	Lua::pushBoolean(L, monster->isImmune());
	return 1;
}
