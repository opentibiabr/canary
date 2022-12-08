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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "game/game.h"
#include "creatures/creature.h"
#include "creatures/monsters/monster.h"
#include "creatures/monsters/monsters.h"
#include "lua/functions/creatures/monster/monster_functions.hpp"

int MonsterFunctions::luaMonsterCreate(lua_State* L) {
	// Monster(id or userdata)
	Monster* monster;
	if (isNumber(L, 2)) {
		monster = g_game().getMonsterByID(getNumber<uint32_t>(L, 2));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Monster) {
			lua_pushnil(L);
			return 1;
		}
		monster = getUserdata<Monster>(L, 2);
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
	pushBoolean(L, getUserdata<const Monster>(L, 1) != nullptr);
	return 1;
}

int MonsterFunctions::luaMonsterGetType(lua_State* L) {
	// monster:getType()
	const Monster* monster = getUserdata<const Monster>(L, 1);
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
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		MonsterType* monsterType = nullptr;
		if (isNumber(L, 2)) {
			monsterType = g_monsters().getMonsterTypeByRaceId(getNumber<uint16_t>(L, 2));
		} else {
			monsterType = g_monsters().getMonsterType(getString(L, 2));
		}
		// Unregister creature events (current MonsterType)
		for (const std::string& scriptName : monster->mType->info.scripts) {
			if (!monster->unregisterCreatureEvent(scriptName)) {
				SPDLOG_WARN("[Warning - MonsterFunctions::luaMonsterSetType] Unknown event name: {}", scriptName);
			}
		}
		// Assign new MonsterType
		monster->mType = monsterType;
		monster->strDescription = asLowerCaseString(monsterType->nameDescription);
		monster->defaultOutfit = monsterType->info.outfit;
		monster->currentOutfit = monsterType->info.outfit;
		monster->skull = monsterType->info.skull;
		float multiplier = g_configManager().getFloat(RATE_MONSTER_HEALTH);
		monster->health = monsterType->info.health * multiplier;
		monster->healthMax = monsterType->info.healthMax * multiplier;
		monster->baseSpeed = monsterType->getBaseSpeed();
		monster->internalLight = monsterType->info.light;
		monster->hiddenHealth = monsterType->info.hiddenHealth;
		monster->targetDistance = monsterType->info.targetDistance;
		// Register creature events (new MonsterType)
		for (const std::string& scriptName : monsterType->info.scripts) {
			if (!monster->registerCreatureEvent(scriptName)) {
				SPDLOG_WARN("[Warning - MonsterFunctions::luaMonsterSetType] Unknown event name: {}", scriptName);
			}
		}
		// Reload creature on spectators
		SpectatorHashSet spectators;
		g_game().map.getSpectators(spectators, monster->getPosition(), true);
		for (Creature* spectator : spectators) {
			if (Player* tmpPlayer = spectator->getPlayer()) {
				tmpPlayer->sendCreatureReload(monster);
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetSpawnPosition(lua_State* L) {
	// monster:getSpawnPosition()
	const Monster* monster = getUserdata<const Monster>(L, 1);
	if (monster) {
		pushPosition(L, monster->getMasterPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsInSpawnRange(lua_State* L) {
	// monster:isInSpawnRange([position])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isInSpawnRange(lua_gettop(L) >= 2 ? getPosition(L, 2) : monster->getPosition()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsIdle(lua_State* L) {
	// monster:isIdle()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->getIdleStatus());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetIdle(lua_State* L) {
	// monster:setIdle(idle)
	Monster* monster = getUserdata<Monster>(L, 1);
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
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->isTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsOpponent(lua_State* L) {
	// monster:isOpponent(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->isOpponent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterIsFriend(lua_State* L) {
	// monster:isFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->isFriend(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddFriend(lua_State* L) {
	// monster:addFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		monster->addFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterRemoveFriend(lua_State* L) {
	// monster:removeFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		monster->removeFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetFriendList(lua_State* L) {
	// monster:getFriendList()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto& friendList = monster->getFriendList();
	lua_createtable(L, friendList.size(), 0);

	int index = 0;
	for (Creature* creature : friendList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetFriendCount(lua_State* L) {
	// monster:getFriendCount()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getFriendList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterAddTarget(lua_State* L) {
	// monster:addTarget(creature[, pushFront = false])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = getCreature(L, 2);
	bool pushFront = getBoolean(L, 3, false);
	monster->addTarget(creature, pushFront);
	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterRemoveTarget(lua_State* L) {
	// monster:removeTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
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
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto& targetList = monster->getTargetList();
	lua_createtable(L, targetList.size(), 0);

	int index = 0;
	for (Creature* creature : targetList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int MonsterFunctions::luaMonsterGetTargetCount(lua_State* L) {
	// monster:getTargetCount()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getTargetList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterChangeTargetDistance(lua_State* L) {
	// monster:changeTargetDistance(distance)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		int32_t distance = getNumber<int32_t>(L, 2, 1);
		pushBoolean(L, monster->changeTargetDistance(distance));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSelectTarget(lua_State* L) {
	// monster:selectTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->selectTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSearchTarget(lua_State* L) {
	// monster:searchTarget([searchType = TARGETSEARCH_DEFAULT])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		TargetSearchType_t searchType = getNumber<TargetSearchType_t>(L, 2, TARGETSEARCH_DEFAULT);
		pushBoolean(L, monster->searchTarget(searchType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterFunctions::luaMonsterSetSpawnPosition(lua_State* L) {
	// monster:setSpawnPosition()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const Position& pos = monster->getPosition();
	monster->setMasterPos(pos);

	g_game().map.spawnsMonster.getspawnMonsterList().emplace_front(pos, 5);
	SpawnMonster& spawnMonster = g_game().map.spawnsMonster.getspawnMonsterList().front();
	spawnMonster.addMonster(monster->mType->name, pos, DIRECTION_NORTH, 60000);
	spawnMonster.startSpawnMonsterCheck();

	pushBoolean(L, true);
	return 1;
}

int MonsterFunctions::luaMonsterGetRespawnType(lua_State *L) {
	// monster:getRespawnType()
	Monster *monster = getUserdata<Monster>(L, 1);

	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	RespawnType respawnType = monster->getRespawnType();
	lua_pushnumber(L, respawnType.period);
	pushBoolean(L, respawnType.underground);

	return 2;
}

int MonsterFunctions::luaMonsterGetTimeToChangeFiendish(lua_State *L) {
	// monster:getTimeToChangeFiendish()
	const Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(monster->getTimeToChangeFiendish()));
	return 1;
}

int MonsterFunctions::luaMonsterSetTimeToChangeFiendish(lua_State *L) {
	// monster:setTimeToChangeFiendish(endTime)
	time_t endTime = getNumber<uint32_t>(L, 2, 1);
	Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setTimeToChangeFiendish(endTime);
	return 1;
}

int MonsterFunctions::luaMonsterGetMonsterForgeClassification(lua_State *L) {
	// monster:getMonsterForgeClassification()
	const Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto classification = static_cast<lua_Number>(monster->getMonsterForgeClassification());
	lua_pushnumber(L, classification);
	return 1;
}

int MonsterFunctions::luaMonsterSetMonsterForgeClassification(lua_State *L) {
	// monster:setMonsterForgeClassification(classication)
	ForgeClassifications_t classification = getNumber<ForgeClassifications_t>(L, 2);
	Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setMonsterForgeClassification(classification);
	return 1;
}

int MonsterFunctions::luaMonsterGetForgeStack(lua_State *L) {
	// monster:getForgeStack()
	const Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, monster->getForgeStack());
	return 1;
}

int MonsterFunctions::luaMonsterSetForgeStack(lua_State *L) {
	// monster:setForgeStack(stack)
	uint16_t stack = getNumber<uint16_t>(L, 2, 0);
	Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->setForgeStack(stack);
	// Update new stack icon
	g_game().updateCreatureIcon(monster);
	g_game().sendUpdateCreature(monster);
	return 1;
}

int MonsterFunctions::luaMonsterConfigureForgeSystem(lua_State *L) {
	// monster:configureForgeSystem()
	Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->configureForgeSystem();
	return 1;
}

int MonsterFunctions::luaMonsterClearFiendishStatus(lua_State *L) {
	// monster:clearFiendishStatus()
	Monster *monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	monster->clearFiendishStatus();
	return 1;
}
