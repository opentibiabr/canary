/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.hpp"
#include "creatures/creature.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "lua/functions/creatures/monster/monster_functions.hpp"
#include "map/spectators.hpp"
#include "game/scheduling/events_scheduler.hpp"

int MonsterFunctions::luaMonsterCreate(lua_State* L) {
	// Monster(id or userdata)
	std::shared_ptr<Monster> monster;
	if (isNumber(L, 2)) {
		monster = g_game().getMonsterByID(getNumber<uint32_t>(L, 2));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_t::Monster) {
			lua_pushnil(L);
			return 1;
		}
		monster = getUserdataShared<Monster>(L, 2);
	} else {
		monster = nullptr;
	}

	if (monster) {
		pushUserdata<Monster>(L, monster);
		setMetatable(L, -1, "Monster");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsMonster(lua_State* L) {
	// monster:isMonster()
	pushBoolean(L, getUserdataShared<Monster>(L, 1) != nullptr);
	return 1;
}

int MonsterFunctions::luaMonsterGetType(lua_State* L) {
	// monster:getType()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		pushUserdata<MonsterType>(L, monster->mType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetType(lua_State* L) {
	// monster:setType(name or raceid)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<MonsterType> mType = nullptr;
		if (isNumber(L, 2)) {
			mType = g_monsters().getMonsterTypeByRaceId(getNumber<uint16_t>(L, 2));
		} else {
			mType = g_monsters().getMonsterType(getString(L, 2));
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
		monster->health = mType->info.health * mType->getHealthMultiplier();
		monster->healthMax = mType->info.healthMax * mType->getHealthMultiplier();
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
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetSpawnPosition(lua_State* L) {
	// monster:getSpawnPosition()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		pushPosition(L, monster->getMasterPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsInSpawnRange(lua_State* L) {
	// monster:isInSpawnRange([position])
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isInSpawnRange(lua_gettop(L) >= 2 ? getPosition(L, 2) : monster->getPosition()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsIdle(lua_State* L) {
	// monster:isIdle()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->getIdleStatus());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetIdle(lua_State* L) {
	// monster:setIdle(idle)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->setIdle(getBoolean(L, 2));
	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterIsTarget(lua_State* L) {
	// monster:isTarget(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<Creature> creature = getCreature(L, 2);
		pushBoolean(L, monster->isTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsOpponent(lua_State* L) {
	// monster:isOpponent(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<Creature> creature = getCreature(L, 2);
		pushBoolean(L, monster->isOpponent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsFriend(lua_State* L) {
	// monster:isFriend(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<Creature> creature = getCreature(L, 2);
		pushBoolean(L, monster->isFriend(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddFriend(lua_State* L) {
	// monster:addFriend(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<Creature> creature = getCreature(L, 2);
		monster->addFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterRemoveFriend(lua_State* L) {
	// monster:removeFriend(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<Creature> creature = getCreature(L, 2);
		monster->removeFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetFriendList(lua_State* L) {
	// monster:getFriendList()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto &friendList = monster->getFriendList();
	lua_createtable(L, friendList.size(), 0);

	int index = 0;
	for (const auto &creature : friendList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetFriendCount(lua_State* L) {
	// monster:getFriendCount()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getFriendList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddTarget(lua_State* L) {
	// monster:addTarget(creature[, pushFront = false])
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Creature> creature = getCreature(L, 2);
	bool pushFront = getBoolean(L, 3, false);
	monster->addTarget(creature, pushFront);
	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterRemoveTarget(lua_State* L) {
	// monster:removeTarget(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->removeTarget(getCreature(L, 2));
	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterGetTargetList(lua_State* L) {
	// monster:getTargetList()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto targetList = monster->getTargetList();
	lua_createtable(L, targetList.size(), 0);

	int index = 0;
	for (std::shared_ptr<Creature> creature : targetList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetTargetCount(lua_State* L) {
	// monster:getTargetCount()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getTargetList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterChangeTargetDistance(lua_State* L) {
	// monster:changeTargetDistance(distance[, duration = 12000])
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		int32_t distance = getNumber<int32_t>(L, 2, 1);
		uint32_t duration = getNumber<uint32_t>(L, 3, 12000);
		pushBoolean(L, monster->changeTargetDistance(distance, duration));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsChallenged(lua_State* L) {
	// monster:isChallenged()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isChallenged());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSelectTarget(lua_State* L) {
	// monster:selectTarget(creature)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		std::shared_ptr<Creature> creature = getCreature(L, 2);
		pushBoolean(L, monster->selectTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSearchTarget(lua_State* L) {
	// monster:searchTarget([searchType = TARGETSEARCH_DEFAULT])
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (monster) {
		TargetSearchType_t searchType = getNumber<TargetSearchType_t>(L, 2, TARGETSEARCH_DEFAULT);
		pushBoolean(L, monster->searchTarget(searchType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetSpawnPosition(lua_State* L) {
	// monster:setSpawnPosition(interval)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t eventschedule = g_eventsScheduler().getSpawnMonsterSchedule();

	const Position &pos = monster->getPosition();
	monster->setMasterPos(pos);

	g_game().map.spawnsMonster.getspawnMonsterList().emplace_front(pos, 5);
	SpawnMonster &spawnMonster = g_game().map.spawnsMonster.getspawnMonsterList().front();
	uint32_t interval = getNumber<uint32_t>(L, 2, 90) * 1000 * 100 / std::max((uint32_t)1, (g_configManager().getNumber(RATE_SPAWN, __FUNCTION__) * eventschedule));
	spawnMonster.addMonster(monster->mType->typeName, pos, DIRECTION_NORTH, static_cast<uint32_t>(interval));
	spawnMonster.startSpawnMonsterCheck();

	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterGetRespawnType(lua_State* L) {
	// monster:getRespawnType()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);

	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	RespawnType respawnType = monster->getRespawnType();
	lua_pushnumber(L, respawnType.period);
	pushBoolean(L, respawnType.underground);

	return 2;
}

int MonsterFunctions::luaMonsterGetTimeToChangeFiendish(lua_State* L) {
	// monster:getTimeToChangeFiendish()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(monster->getTimeToChangeFiendish()));
	return 1;
}

int MonsterFunctions::luaMonsterSetTimeToChangeFiendish(lua_State* L) {
	// monster:setTimeToChangeFiendish(endTime)
	time_t endTime = getNumber<uint32_t>(L, 2, 1);
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setTimeToChangeFiendish(endTime);
	return 1;
}

int MonsterFunctions::luaMonsterGetMonsterForgeClassification(lua_State* L) {
	// monster:getMonsterForgeClassification()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto classification = static_cast<lua_Number>(monster->getMonsterForgeClassification());
	lua_pushnumber(L, classification);
	return 1;
}

int MonsterFunctions::luaMonsterSetMonsterForgeClassification(lua_State* L) {
	// monster:setMonsterForgeClassification(classication)
	ForgeClassifications_t classification = getNumber<ForgeClassifications_t>(L, 2);
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setMonsterForgeClassification(classification);
	return 1;
}

int MonsterFunctions::luaMonsterGetForgeStack(lua_State* L) {
	// monster:getForgeStack()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, monster->getForgeStack());
	return 1;
}

int MonsterFunctions::luaMonsterSetForgeStack(lua_State* L) {
	// monster:setForgeStack(stack)
	uint16_t stack = getNumber<uint16_t>(L, 2, 0);
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setForgeStack(stack);
	auto icon = stack < 15
		? CreatureIconModifications_t::Influenced
		: CreatureIconModifications_t::Fiendish;
	monster->setIcon("forge", CreatureIcon(icon, icon == CreatureIconModifications_t::Influenced ? static_cast<uint8_t>(stack) : 0));
	g_game().updateCreatureIcon(monster);
	g_game().sendUpdateCreature(monster);
	return 1;
}

int MonsterFunctions::luaMonsterConfigureForgeSystem(lua_State* L) {
	// monster:configureForgeSystem()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->configureForgeSystem();
	return 1;
}

int MonsterFunctions::luaMonsterClearFiendishStatus(lua_State* L) {
	// monster:clearFiendishStatus()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->clearFiendishStatus();
	return 1;
}

int MonsterFunctions::luaMonsterIsForgeable(lua_State* L) {
	// monster:isForgeable()
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, monster->canBeForgeMonster());
	return 1;
}

int MonsterFunctions::luaMonsterGetName(lua_State* L) {
	// monster:getName()
	const auto monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushString(L, monster->getName());
	return 1;
}

int MonsterFunctions::luaMonsterSetName(lua_State* L) {
	// monster:setName(name[, nameDescription])
	auto monster = getUserdataShared<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setName(getString(L, 2));
	if (lua_gettop(L) >= 3) {
		monster->setNameDescription(getString(L, 3));
	}

	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterHazard(lua_State* L) {
	// get: monster:hazard() ; set: monster:hazard(hazard)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	bool hazard = getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monster->getHazard());
		} else {
			monster->setHazard(hazard);
			pushBoolean(L, monster->getHazard());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardCrit(lua_State* L) {
	// get: monster:hazardCrit() ; set: monster:hazardCrit(hazardCrit)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	bool hazardCrit = getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monster->getHazardSystemCrit());
		} else {
			monster->setHazardSystemCrit(hazardCrit);
			pushBoolean(L, monster->getHazardSystemCrit());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardDodge(lua_State* L) {
	// get: monster:hazardDodge() ; set: monster:hazardDodge(hazardDodge)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	bool hazardDodge = getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monster->getHazardSystemDodge());
		} else {
			monster->setHazardSystemDodge(hazardDodge);
			pushBoolean(L, monster->getHazardSystemDodge());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardDamageBoost(lua_State* L) {
	// get: monster:hazardDamageBoost() ; set: monster:hazardDamageBoost(hazardDamageBoost)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	bool hazardDamageBoost = getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monster->getHazardSystemDamageBoost());
		} else {
			monster->setHazardSystemDamageBoost(hazardDamageBoost);
			pushBoolean(L, monster->getHazardSystemDamageBoost());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterHazardDefenseBoost(lua_State* L) {
	// get: monster:hazardDefenseBoost() ; set: monster:hazardDefenseBoost(hazardDefenseBoost)
	std::shared_ptr<Monster> monster = getUserdataShared<Monster>(L, 1);
	bool hazardDefenseBoost = getBoolean(L, 2, false);
	if (monster) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monster->getHazardSystemDefenseBoost());
		} else {
			monster->setHazardSystemDefenseBoost(hazardDefenseBoost);
			pushBoolean(L, monster->getHazardSystemDefenseBoost());
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
