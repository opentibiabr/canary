/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "lua/methods/player_functions.hpp"

#include "creatures/combat/spells.h"
#include "creatures/creature.h"
#include "creatures/interactions/chat.h"
#include "creatures/players/player.h"
#include "game/game.h"
#include "io/iologindata.h"
#include "io/ioprey.h"
#include "items/item.h"

int LuaPlayerFunctions::create(lua_State *L)
{
	// Player(id or guid or name or userdata)
	Player * player;
	if (isNumber(L, 2))
	{
		uint32_t id = getNumber<uint32_t> (L, 2);
		if (id >= 0x10000000 && id <= Player::playerAutoID)
		{
			player = g_game().getPlayerByID(id);
		}
		else
		{
			player = g_game().getPlayerByGUID(id);
		}
	}
	else if (isString(L, 2))
	{
		ReturnValue ret = g_game().getPlayerByNameWildcard(getString(L, 2), player);
		if (ret != RETURNVALUE_NOERROR)
		{
			lua_pushnil(L);
			lua_pushnumber(L, ret);
			return 2;
		}
	}
	else if (isUserdata(L, 2))
	{
		if (getUserdataType(L, 2) != LuaData_Player)
		{
			lua_pushnil(L);
			return 1;
		}

		player = getPlayerUserdata(L, 2);
	}
	else
	{
		player = nullptr;
	}

	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Player> (L, player);
	setMetatable(L, -1, "Player");
	return 1;
}

int LuaPlayerFunctions::resetCharmsBestiary(lua_State *L)
{
	// player:resetCharmsBestiary()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setCharmPoints(0);
	player->setCharmExpansion(false);
	player->setUsedRunesBit(0);
	player->setUnlockedRunesBit(0);
	for (int8_t i = CHARM_WOUND; i <= CHARM_LAST; i++)
	{
		player->parseRacebyCharm(static_cast<charmRune_t> (i), true, 0);
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::unlockAllCharmRunes(lua_State *L)
{
	// player:unlockAllCharmRunes()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	for (int8_t i = CHARM_WOUND; i <= CHARM_LAST; i++)
	{
		Charm *charm = g_iobestiary().getBestiaryCharm(static_cast<charmRune_t> (i));
		if (charm)
		{
			int32_t value = g_iobestiary().bitToggle(player->getUnlockedRunesBit(), charm, true);
			player->setUnlockedRunesBit(value);
		}
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addCharmPoints(lua_State *L)
{
	// player:addCharmPoints()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int16_t charms = getNumber<int16_t> (L, 2);
	if (charms >= 0)
	{
		g_iobestiary().addCharmPoints(player, static_cast<uint16_t> (charms));
	}
	else
	{
		charms = -charms;
		g_iobestiary().addCharmPoints(player, static_cast<uint16_t> (charms), true);
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::isPlayer(lua_State *L)
{
	// player:isPlayer()
	pushBoolean(L, getPlayerUserdata(L) != nullptr);
	return 1;
}

int LuaPlayerFunctions::getGuid(lua_State *L)
{
	// player:getGuid()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getGUID());
	return 1;
}

int LuaPlayerFunctions::getIp(lua_State *L)
{
	// player:getIp()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getIP());
	return 1;
}

int LuaPlayerFunctions::getAccountId(lua_State *L)
{
	// player:getAccountId()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getAccount());
	return 1;
}

int LuaPlayerFunctions::getLastLoginSaved(lua_State *L)
{
	// player:getLastLoginSaved()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getLastLoginSaved());
	return 1;
}

int LuaPlayerFunctions::getLastLogout(lua_State *L)
{
	// player:getLastLogout()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getLastLogout());
	return 1;
}

int LuaPlayerFunctions::getAccountType(lua_State *L)
{
	// player:getAccountType()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getAccountType());
	return 1;
}

int LuaPlayerFunctions::setAccountType(lua_State *L)
{
	// player:setAccountType(accountType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->accountType = getNumber<account::AccountType > (L, 2);
	IOLoginData::setAccountType(player->getAccount(), player->accountType);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addBestiaryKill(lua_State *L)
{
	// player:addBestiaryKill(name[, amount = 1])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	MonsterType *mtype = g_monsters().getMonsterType(getString(L, 2));
	if (mtype == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	g_iobestiary().addBestiaryKill(player, mtype, getNumber<uint32_t> (L, 3, 1));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::isMonsterBestiaryUnlocked(lua_State *L)
{
	// player:isMonsterBestiaryUnlocked(raceId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto raceId = getNumber<uint16_t> (L, 2, 0);
	if (!g_monsters().getMonsterTypeByRaceId(raceId))
	{
		reportErrorFunc("Monster race id not exists");
		pushBoolean(L, false);
		return 0;
	}

	for (auto finishedMonsters = g_iobestiary().getBestiaryFinished(player); uint16_t finishedRaceId: finishedMonsters)
	{
		if (raceId == finishedRaceId)
		{
			pushBoolean(L, true);
			return 1;
		}
	}

	pushBoolean(L, false);
	return 0;
}

int LuaPlayerFunctions::getCharmMonsterType(lua_State *L)
{
	// player:getCharmMonsterType(charmRune_t)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	charmRune_t charmid = getNumber<charmRune_t> (L, 2);
	uint16_t raceid = player->parseRacebyCharm(charmid, false, 0);
	if (raceid == 0)
	{
		reportErrorFunc("Race id is 0");
		pushBoolean(L, false);
		return 0;
	}

	MonsterType *mtype = g_monsters().getMonsterTypeByRaceId(raceid);
	if (mtype == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_MONSTER_TYPE_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<MonsterType> (L, mtype);
	setMetatable(L, -1, "MonsterType");
	return 1;
}

int LuaPlayerFunctions::removePreyStamina(lua_State *L)
{
	// player:removePreyStamina(amount)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	g_ioprey().CheckPlayerPreys(player, getNumber<uint8_t> (L, 2, 1));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addPreyCards(lua_State *L)
{
	// player:addPreyCards(amount)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addPreyCards(getNumber<uint64_t> (L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getPreyCards(lua_State *L)
{
	// player:getPreyCards()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number> (player->getPreyCards()));
	return 1;
}

int LuaPlayerFunctions::getPreyExperiencePercentage(lua_State *L)
{
	// player:getPreyExperiencePercentage(raceId)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (const PreySlot *slot = player->getPreyWithMonster(getNumber<uint16_t> (L, 2, 0)); slot && slot->isOccupied() && slot->bonus == PreyBonus_Experience && slot->bonusTimeLeft > 0)
	{
		lua_pushnumber(L, static_cast<lua_Number> (100 + slot->bonusPercentage));
	}
	else
	{
		lua_pushnumber(L, 100);
	}

	return 1;
}

int LuaPlayerFunctions::removeTaskHuntingPoints(lua_State *L)
{
	// player:removeTaskHuntingPoints(amount)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->useTaskHuntingPoints(getNumber<uint64_t> (L, 2, 0)));
	return 1;
}

int LuaPlayerFunctions::getTaskHuntingPoints(lua_State *L)
{
	// player:getTaskHuntingPoints()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, static_cast<double> (player->getTaskHuntingPoints()));
	return 1;
}

int LuaPlayerFunctions::addTaskHuntingPoints(lua_State *L)
{
	// player:addTaskHuntingPoints(amount)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto points = getNumber<uint64_t> (L, 2);
	player->addTaskHuntingPoints(getNumber<uint64_t> (L, 2));
	lua_pushnumber(L, static_cast<lua_Number> (points));
	return 1;
}

int LuaPlayerFunctions::getPreyLootPercentage(lua_State *L)
{
	// player:getPreyLootPercentage(raceid)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (const PreySlot *slot = player->getPreyWithMonster(getNumber<uint16_t> (L, 2, 0)); slot && slot->isOccupied() && slot->bonus == PreyBonus_Loot)
	{
		lua_pushnumber(L, slot->bonusPercentage);
	}
	else
	{
		lua_pushnumber(L, 0);
	}

	return 1;
}

int LuaPlayerFunctions::preyThirdSlot(lua_State *L)
{
	// get: player:preyThirdSlot() set: player:preyThirdSlot(bool)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	PreySlot *slot = player->getPreySlotById(PreySlot_Three);
	if (slot == nullptr)
	{
		reportErrorFunc("Prey slot is nullptr");
		pushBoolean(L, false);
		return 0;
	}

	if (lua_gettop(L) == 1)
	{
		pushBoolean(L, slot->state != PreyDataState_Locked);
	}
	else
	{
		if (getBoolean(L, 2, false))
		{
			slot->eraseBonus();
			slot->state = PreyDataState_Selection;
			slot->reloadMonsterGrid(player->getPreyBlackList(), player->getLevel());
			player->reloadPreySlot(PreySlot_Three);
		}
		else
		{
			slot->state = PreyDataState_Locked;
		}

		pushBoolean(L, true);
	}

	return 1;
}

int LuaPlayerFunctions::taskHuntingThirdSlot(lua_State *L)
{
	// get: player:taskHuntingThirdSlot() set: player:taskHuntingThirdSlot(bool)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	TaskHuntingSlot *slot = player->getTaskHuntingSlotById(PreySlot_Three);
	if (slot == nullptr)
	{
		reportErrorFunc("Slot is nullptr");
		pushBoolean(L, false);
		return 0;
	}

	if (lua_gettop(L) == 1)
	{
		pushBoolean(L, slot->state != PreyTaskDataState_Locked);
	}
	else
	{
		if (getBoolean(L, 2, false))
		{
			slot->eraseTask();
			slot->reloadReward();
			slot->state = PreyTaskDataState_Selection;
			slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
			player->reloadTaskSlot(PreySlot_Three);
		}
		else
		{
			slot->state = PreyTaskDataState_Locked;
		}

		pushBoolean(L, true);
	}

	return 1;
}

int LuaPlayerFunctions::charmExpansion(lua_State *L)
{
	// get: player:charmExpansion() set: player:charmExpansion(bool)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (lua_gettop(L) == 1)
	{
		pushBoolean(L, player->hasCharmExpansion());
	}
	else
	{
		player->setCharmExpansion(getBoolean(L, 2, false));
		pushBoolean(L, true);
	}

	return 1;
}

int LuaPlayerFunctions::getCapacity(lua_State *L)
{
	// player:getCapacity()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getCapacity());
	return 1;
}

int LuaPlayerFunctions::setCapacity(lua_State *L)
{
	// player:setCapacity(capacity)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->capacity = getNumber<uint32_t> (L, 2);
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setTraining(lua_State *L)
{
	// player:setTraining(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	bool value = getBoolean(L, 2, false);
	player->setTraining(value);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getIsTraining(lua_State *L)
{
	// player:isTraining()
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->isExerciseTraining());
	return 1;
}

int LuaPlayerFunctions::getFreeCapacity(lua_State *L)
{
	// player:getFreeCapacity()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getFreeCapacity());
	return 1;
}

int LuaPlayerFunctions::getKills(lua_State *L)
{
	// player:getKills()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_createtable(L, player->unjustifiedKills.size(), 0);
	int idx = 0;
	for (const auto &kill: player->unjustifiedKills)
	{
		lua_createtable(L, 3, 0);
		lua_pushnumber(L, kill.target);
		lua_rawseti(L, -2, 1);
		lua_pushnumber(L, kill.time);
		lua_rawseti(L, -2, 2);
		pushBoolean(L, kill.unavenged);
		lua_rawseti(L, -2, 3);
		lua_rawseti(L, -2, ++idx);
	}

	return 1;
}

int LuaPlayerFunctions::setKills(lua_State *L)
{
	// player:setKills(kills)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	luaL_checktype(L, 2, LUA_TTABLE);
	std::vector<Kill> newKills;

	lua_pushnil(L);
	while (lua_next(L, 2) != 0)
	{
		// -2 is index, -1 is value
		luaL_checktype(L, -1, LUA_TTABLE);
		lua_rawgeti(L, -1, 1);	// push target
		lua_rawgeti(L, -2, 2);	// push time
		lua_rawgeti(L, -3, 3);	// push unavenged
		newKills.emplace_back(luaL_checknumber(L, -3), luaL_checknumber(L, -2), getBoolean(L, -1));
		lua_pop(L, 4);
	}

	player->unjustifiedKills = std::move(newKills);
	player->sendUnjustifiedPoints();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getReward(lua_State *L)
{
	// player:getReward(rewardId[, autoCreate = false])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t rewardId = getNumber<uint32_t> (L, 2);
	bool autoCreate = getBoolean(L, 3, false);
	if (Reward *reward = player->getReward(rewardId, autoCreate))
	{
		pushUserdata<Item> (L, reward);
		setItemMetatable(L, -1, reward);
	}
	else
	{
		pushBoolean(L, false);
	}

	return 1;
}

int LuaPlayerFunctions::removeReward(lua_State *L)
{
	// player:removeReward(rewardId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t rewardId = getNumber<uint32_t> (L, 2);
	player->removeReward(rewardId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getRewardList(lua_State *L)
{
	// player:getRewardList()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	std::vector<uint32_t> rewardVec;
	player->getRewardList(rewardVec);
	lua_createtable(L, rewardVec.size(), 0);

	int index = 0;
	for (const auto &rewardId: rewardVec)
	{
		lua_pushnumber(L, rewardId);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaPlayerFunctions::setDailyReward(lua_State *L)
{
	// player:setDailyReward(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setDailyReward(getNumber<uint8_t> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::sendInventory(lua_State *L)
{
	// player:sendInventory()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendInventoryIds();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::sendLootStats(lua_State *L)
{
	// player:sendLootStats(item, count)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Item *item = getUserdata<Item> (L, 2);
	if (item == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint8_t count = getNumber<uint8_t> (L, 3, 0);
	if (count == 0)
	{
		reportErrorFunc("Count is 0");
		pushBoolean(L, false);
		return 0;
	}

	player->sendLootStats(item, count);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::updateSupplyTracker(lua_State *L)
{
	// player:updateSupplyTracker(item)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Item *item = getUserdata<Item> (L, 2);
	if (item == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->updateSupplyTracker(item);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::updateKillTracker(lua_State *L)
{
	// player:updateKillTracker(creature, corpse)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const Creature *monster = getUserdata<const Creature > (L, 2);
	if (monster == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Container *corpse = getUserdata<Container> (L, 3);
	if (corpse == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->updateKillTracker(corpse, monster->getName(), monster->getCurrentOutfit());
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getDepotLocker(lua_State *L)
{
	// player:getDepotLocker(depotId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t depotId = getNumber<uint32_t> (L, 2);
	DepotLocker *depotLocker = player->getDepotLocker(depotId);
	if (depotLocker)
	{
		depotLocker->setParent(player);
		pushUserdata<Item> (L, depotLocker);
		setItemMetatable(L, -1, depotLocker);
	}
	else
	{
		pushBoolean(L, false);
	}

	return 1;
}

int LuaPlayerFunctions::getStashCounter(lua_State *L)
{
	// player:getStashCount()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t sizeStash = getStashSize(player->getStashItems());
	lua_pushnumber(L, sizeStash);
	return 1;
}

int LuaPlayerFunctions::getDepotChest(lua_State *L)
{
	// player:getDepotChest(depotId[, autoCreate = false])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t depotId = getNumber<uint32_t> (L, 2);
	bool autoCreate = getBoolean(L, 3, false);
	DepotChest *depotChest = player->getDepotChest(depotId, autoCreate);
	if (depotChest)
	{
		player->setLastDepotId(depotId);
		pushUserdata<Item> (L, depotChest);
		setItemMetatable(L, -1, depotChest);
	}
	else
	{
		pushBoolean(L, false);
	}

	return 1;
}

int LuaPlayerFunctions::getInbox(lua_State *L)
{
	// player:getInbox()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Inbox *inbox = player->getInbox();
	if (inbox)
	{
		pushUserdata<Item> (L, inbox);
		setItemMetatable(L, -1, inbox);
	}
	else
	{
		pushBoolean(L, false);
	}

	return 1;
}

int LuaPlayerFunctions::getSkullTime(lua_State *L)
{
	// player:getSkullTime()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getSkullTicks());
	return 1;
}

int LuaPlayerFunctions::setSkullTime(lua_State *L)
{
	// player:setSkullTime(skullTime)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setSkullTicks(getNumber<int64_t> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getDeathPenalty(lua_State *L)
{
	// player:getDeathPenalty()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<uint32_t> (player->getLostPercent() *100));
	return 1;
}

int LuaPlayerFunctions::getExperience(lua_State *L)
{
	// player:getExperience()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getExperience());
	return 1;
}

int LuaPlayerFunctions::addExperience(lua_State *L)
{
	// player:addExperience(experience[, sendText = false])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int64_t experience = getNumber<int64_t> (L, 2);
	bool sendText = getBoolean(L, 3, false);
	player->addExperience(nullptr, experience, sendText);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeExperience(lua_State *L)
{
	// player:removeExperience(experience[, sendText = false])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int64_t experience = getNumber<int64_t> (L, 2);
	bool sendText = getBoolean(L, 3, false);
	player->removeExperience(experience, sendText);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getLevel(lua_State *L)
{
	// player:getLevel()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getLevel());
	return 1;
}

int LuaPlayerFunctions::getMagicLevel(lua_State *L)
{
	// player:getMagicLevel()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getMagicLevel());
	return 1;
}

int LuaPlayerFunctions::getBaseMagicLevel(lua_State *L)
{
	// player:getBaseMagicLevel()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getBaseMagicLevel());
	return 1;
}

int LuaPlayerFunctions::getMana(lua_State *L)
{
	// player:getMana()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getMana());
	return 1;
}

int LuaPlayerFunctions::addMana(lua_State *L)
{
	// player:addMana(manaChange[, animationOnLoss = false])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int32_t manaChange = getNumber<int32_t> (L, 2);
	bool animationOnLoss = getBoolean(L, 3, false);
	if (!animationOnLoss && manaChange < 0)
	{
		player->changeMana(manaChange);
	}
	else
	{
		CombatDamage damage;
		damage.primary.value = manaChange;
		damage.origin = ORIGIN_NONE;
		g_game().combatChangeMana(nullptr, player, damage);
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getMaxMana(lua_State *L)
{
	// player:getMaxMana()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getMaxMana());
	return 1;
}

int LuaPlayerFunctions::setMaxMana(lua_State *L)
{
	// player:setMaxMana(maxMana)
	Player *player = getPlayer(L, 1);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->manaMax = getNumber<int32_t> (L, 2);
	player->mana = std::min<int32_t> (player->mana, player->manaMax);
	g_game().addPlayerMana(player);
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getManaSpent(lua_State *L)
{
	// player:getManaSpent()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getSpentMana());
	return 1;
}

int LuaPlayerFunctions::addManaSpent(lua_State *L)
{
	// player:addManaSpent(amount)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addManaSpent(getNumber<uint64_t> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getName(lua_State *L)
{
	// player:getName()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushString(L, player->getName());
	return 1;
}

int LuaPlayerFunctions::getId(lua_State *L)
{
	// player:getId()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getID());
	return 1;
}

int LuaPlayerFunctions::getPosition(lua_State *L)
{
	// player:getPosition()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushPosition(L, player->getPosition());
	return 1;
}

int LuaPlayerFunctions::teleportTo(lua_State *L)
{
	// player:teleportTo(position[, pushMovement = false])
	bool pushMovement = getBoolean(L, 3, false);

	const Position &position = getPositionFromLua(L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const Position oldPosition = player->getPosition();
	if (g_game().internalTeleport(player, position, pushMovement) != RETURNVALUE_NOERROR)
	{
		SPDLOG_WARN("[{}] - Cannot teleport creature with name: {}, fromPosition {}, toPosition {}", __FUNCTION__, player->getName(), oldPosition.toString(), position.toString());
		pushBoolean(L, false);
		return 1;
	}

	if (!pushMovement)
	{
		if (oldPosition.x == position.x)
		{
			if (oldPosition.y < position.y)
			{
				g_game().internalCreatureTurn(player, DIRECTION_SOUTH);
			}
			else
			{
				g_game().internalCreatureTurn(player, DIRECTION_NORTH);
			}
		}
		else if (oldPosition.x > position.x)
		{
			g_game().internalCreatureTurn(player, DIRECTION_WEST);
		}
		else if (oldPosition.x < position.x)
		{
			g_game().internalCreatureTurn(player, DIRECTION_EAST);
		}
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getBaseMaxHealth(lua_State *L)
{
	// player:getBaseMaxHealth()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->healthMax);
	return 1;
}

int LuaPlayerFunctions::getBaseMaxMana(lua_State *L)
{
	// player:getBaseMaxMana()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->manaMax);
	return 1;
}

int LuaPlayerFunctions::getSkillLevel(lua_State *L)
{
	// player:getSkillLevel(skillType)
	skills_t skillType = getNumber<skills_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (skillType <= SKILL_LAST)
	{
		lua_pushnumber(L, player->skills[skillType].level);
	}

	return 1;
}

int LuaPlayerFunctions::getEffectiveSkillLevel(lua_State *L)
{
	// player:getEffectiveSkillLevel(skillType)
	skills_t skillType = getNumber<skills_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (skillType <= SKILL_LAST)
	{
		lua_pushnumber(L, player->getSkillLevel(skillType));
	}

	return 1;
}

int LuaPlayerFunctions::getSkillPercent(lua_State *L)
{
	// player:getSkillPercent(skillType)
	skills_t skillType = getNumber<skills_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (skillType <= SKILL_LAST)
	{
		lua_pushnumber(L, player->skills[skillType].percent);
	}

	return 1;
}

int LuaPlayerFunctions::getSkillTries(lua_State *L)
{
	// player:getSkillTries(skillType)
	skills_t skillType = getNumber<skills_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (skillType <= SKILL_LAST)
	{
		lua_pushnumber(L, player->skills[skillType].tries);
	}

	return 1;
}

int LuaPlayerFunctions::addSkillTries(lua_State *L)
{
	// player:addSkillTries(skillType, tries)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	skills_t skillType = getNumber<skills_t> (L, 2);
	uint64_t tries = getNumber<uint64_t> (L, 3);
	player->addSkillAdvance(skillType, tries);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setMagicLevel(lua_State *L)
{
	// player:setMagicLevel(level[, manaSpent])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t level = getNumber<uint16_t> (L, 2);
	player->magLevel = level;
	if (getNumber<uint64_t> (L, 3, 0) > 0)
	{
		uint64_t manaSpent = getNumber<uint64_t> (L, 3);
		uint64_t nextReqMana = player->vocation->getReqMana(level + 1);
		player->manaSpent = manaSpent;
		player->magLevelPercent = Player::getPercentLevel(manaSpent, nextReqMana);
	}
	else
	{
		player->manaSpent = 0;
		player->magLevelPercent = 0;
	}

	player->sendStats();
	player->sendSkills();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setSkillLevel(lua_State *L)
{
	// player:setSkillLevel(skillType, level[, tries])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	skills_t skillType = getNumber<skills_t> (L, 2);
	uint16_t level = getNumber<uint16_t> (L, 3);
	player->skills[skillType].level = level;
	if (getNumber<uint64_t> (L, 4, 0) > 0)
	{
		uint64_t tries = getNumber<uint64_t> (L, 4);
		uint64_t nextReqTries = player->vocation->getReqSkillTries(skillType, level + 1);
		player->skills[skillType].tries = tries;
		player->skills[skillType].percent = Player::getPercentLevel(tries, nextReqTries);
	}
	else
	{
		player->skills[skillType].tries = 0;
		player->skills[skillType].percent = 0;
	}

	player->sendStats();
	player->sendSkills();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addOfflineTrainingTime(lua_State *L)
{
	// player:addOfflineTrainingTime(time)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int32_t time = getNumber<int32_t> (L, 2);
	player->addOfflineTrainingTime(time);
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getOfflineTrainingTime(lua_State *L)
{
	// player:getOfflineTrainingTime()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getOfflineTrainingTime());
	return 1;
}

int LuaPlayerFunctions::removeOfflineTrainingTime(lua_State *L)
{
	// player:removeOfflineTrainingTime(time)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int32_t time = getNumber<int32_t> (L, 2);
	player->removeOfflineTrainingTime(time);
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addOfflineTrainingTries(lua_State *L)
{
	// player:addOfflineTrainingTries(skillType, tries)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	skills_t skillType = getNumber<skills_t> (L, 2);
	uint64_t tries = getNumber<uint64_t> (L, 3);
	pushBoolean(L, player->addOfflineTrainingTries(skillType, tries));
	return 1;
}

int LuaPlayerFunctions::getOfflineTrainingSkill(lua_State *L)
{
	// player:getOfflineTrainingSkill()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getOfflineTrainingSkill());
	return 1;
}

int LuaPlayerFunctions::setOfflineTrainingSkill(lua_State *L)
{
	// player:setOfflineTrainingSkill(skillId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int8_t skillId = getNumber<int8_t> (L, 2);
	player->setOfflineTrainingSkill(skillId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::openStash(lua_State *L)
{
	// player:openStash(isNpc)
	Player *player = getPlayerUserdata(L);
	bool isNpc = getBoolean(L, 2, false);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendOpenStash(isNpc);
	pushBoolean(L, true);

	return 1;
}

int LuaPlayerFunctions::getItemCount(lua_State *L)
{
	// player:getItemCount(itemId[, subType = -1])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t itemId;
	if (isNumber(L, 2))
	{
		itemId = getNumber<uint16_t> (L, 2);
	}
	else
	{
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0)
		{
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t subType = getNumber<int32_t> (L, 3, -1);
	lua_pushnumber(L, player->getItemTypeCount(itemId, subType));
	return 1;
}

int LuaPlayerFunctions::getStashItemCount(lua_State *L)
{
	// player:getStashItemCount(itemId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t itemId;
	if (isNumber(L, 2))
	{
		itemId = getNumber<uint16_t> (L, 2);
	}
	else
	{
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0)
		{
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType &itemType = Item::items[itemId];
	if (itemType.id == 0)
	{
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getStashItemCount(itemType.id));
	return 1;
}

int LuaPlayerFunctions::getItemById(lua_State *L)
{
	// player:getItemById(itemId, deepSearch[, subType = -1])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t itemId;
	if (isNumber(L, 2))
	{
		itemId = getNumber<uint16_t> (L, 2);
	}
	else
	{
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0)
		{
			lua_pushnil(L);
			return 1;
		}
	}

	bool deepSearch = getBoolean(L, 3);
	int32_t subType = getNumber<int32_t> (L, 4, -1);

	Item *item = g_game().findItemOfType(player, itemId, deepSearch, subType);
	if (item == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Item> (L, item);
	setItemMetatable(L, -1, item);
	return 1;
}

int LuaPlayerFunctions::getVocation(lua_State *L)
{
	// player:getVocation()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Vocation> (L, player->getVocation());
	setMetatable(L, -1, "Vocation");
	return 1;
}

int LuaPlayerFunctions::setVocation(lua_State *L)
{
	// player:setVocation(id or name or userdata)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Vocation * vocation;
	if (isNumber(L, 2))
	{
		vocation = g_vocations().getVocation(getNumber<uint16_t> (L, 2));
	}
	else if (isString(L, 2))
	{
		vocation = g_vocations().getVocation(g_vocations().getVocationId(getString(L, 2)));
	}
	else if (isUserdata(L, 2))
	{
		vocation = getUserdata<Vocation> (L, 2);
	}
	else
	{
		vocation = nullptr;
	}

	if (!vocation)
	{
		pushBoolean(L, false);
		return 1;
	}

	player->setVocation(vocation->getId());
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getSex(lua_State *L)
{
	// player:getSex()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getSex());
	return 1;
}

int LuaPlayerFunctions::setSex(lua_State *L)
{
	// player:setSex(newSex)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	PlayerSex_t newSex = getNumber<PlayerSex_t> (L, 2);
	player->setSex(newSex);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getTown(lua_State *L)
{
	// player:getTown()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Town> (L, player->getTown());
	setMetatable(L, -1, "Town");
	return 1;
}

int LuaPlayerFunctions::setTown(lua_State *L)
{
	// player:setTown(town)
	Town *town = getUserdata<Town> (L, 2);
	if (!town)
	{
		pushBoolean(L, false);
		return 1;
	}

	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setTown(town);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getGuild(lua_State *L)
{
	// player:getGuild()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Guild *guild = player->getGuild();
	if (!guild)
	{
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Guild> (L, guild);
	setMetatable(L, -1, "Guild");
	return 1;
}

int LuaPlayerFunctions::setGuild(lua_State *L)
{
	// player:setGuild(guild)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setGuild(getUserdata<Guild> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getGuildLevel(lua_State *L)
{
	// player:getGuildLevel()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (!player->getGuild())
	{
		reportErrorFunc("Guild is nullptr");
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getGuildRank()->level);
	return 1;
}

int LuaPlayerFunctions::setGuildLevel(lua_State *L)
{
	// player:setGuildLevel(level)
	uint8_t level = getNumber<uint8_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (!player || !player->getGuild())
	{
		lua_pushnil(L);
		return 1;
	}

	GuildRank_ptr rank = player->getGuild()->getRankByLevel(level);
	if (!rank)
	{
		pushBoolean(L, false);
	}
	else
	{
		player->setGuildRank(rank);
		pushBoolean(L, true);
	}

	return 1;
}

int LuaPlayerFunctions::getGuildNick(lua_State *L)
{
	// player:getGuildNick()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushString(L, player->getGuildNick());
	return 1;
}

int LuaPlayerFunctions::setGuildNick(lua_State *L)
{
	// player:setGuildNick(nick)
	const std::string &nick = getString(L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setGuildNick(nick);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getGroup(lua_State *L)
{
	// player:getGroup()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Group> (L, player->getGroup());
	setMetatable(L, -1, "Group");
	return 1;
}

int LuaPlayerFunctions::setGroup(lua_State *L)
{
	// player:setGroup(group)
	Group *group = getUserdata<Group> (L, 2);
	if (!group)
	{
		pushBoolean(L, false);
		return 1;
	}

	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setGroup(group);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setSpecialContainersAvailable(lua_State *L)
{
	// player:setSpecialContainersAvailable(stashMenu, marketMenu, depotSearchMenu)
	bool supplyStashMenu = getBoolean(L, 2, false);
	bool marketMenu = getBoolean(L, 3, false);
	bool depotSearchMenu = getBoolean(L, 4, false);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setSpecialMenuAvailable(supplyStashMenu, marketMenu, depotSearchMenu);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getStamina(lua_State *L)
{
	// player:getStamina()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getStaminaMinutes());
	return 1;
}

int LuaPlayerFunctions::setStamina(lua_State *L)
{
	// player:setStamina(stamina)
	uint16_t stamina = getNumber<uint16_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->staminaMinutes = std::min<uint16_t> (2520, stamina);
	player->sendStats();
	return 1;
}

int LuaPlayerFunctions::getSoul(lua_State *L)
{
	// player:getSoul()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getSoul());
	return 1;
}

int LuaPlayerFunctions::addSoul(lua_State *L)
{
	// player:addSoul(soulChange)
	int32_t soulChange = getNumber<int32_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->changeSoul(soulChange);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getMaxSoul(lua_State *L)
{
	// player:getMaxSoul()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (!player->vocation)
	{
		reportErrorFunc("Vocation nullptr");
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->vocation->getSoulMax());

	return 1;
}

int LuaPlayerFunctions::getBankBalance(lua_State *L)
{
	// player:getBankBalance()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getBankBalance());
	return 1;
}

int LuaPlayerFunctions::setBankBalance(lua_State *L)
{
	// player:setBankBalance(bankBalance)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setBankBalance(getNumber<uint64_t> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getStorageValue(lua_State *L)
{
	// player:getStorageValue(key)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t key = getNumber<uint32_t> (L, 2);
	lua_pushnumber(L, player->getStorageValue(key));
	return 1;
}

int LuaPlayerFunctions::setStorageValue(lua_State *L)
{
	// player:setStorageValue(key, value)
	int32_t value = getNumber<int32_t> (L, 3);
	uint32_t key = getNumber<uint32_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE))
	{
		std::ostringstream ss;
		ss << "Accessing reserved range: " << key;
		reportErrorFunc(ss.str());
		pushBoolean(L, false);
		return 1;
	}

	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addStorageValue(key, value);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addItem(lua_State *L)
{
	// player:addItem(itemId, count = 1, canDropOnMap = true, subType = 1, slot = CONST_SLOT_WHEREEVER, tier = 0)
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2))
	{
		itemId = getNumber<uint16_t> (L, 2);
	}
	else
	{
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0)
		{
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t count = getNumber<int32_t> (L, 3, 1);
	int32_t subType = getNumber<int32_t> (L, 5, 1);

	const ItemType &it = Item::items[itemId];

	int32_t itemCount = 1;
	int parameters = lua_gettop(L);
	if (parameters >= 4)
	{
		itemCount = std::max<int32_t> (1, count);
	}
	else if (it.hasSubType())
	{
		if (it.stackable)
		{
			itemCount = std::ceil(count / 100.f);
		}

		subType = count;
	}
	else
	{
		itemCount = std::max<int32_t> (1, count);
	}

	bool hasTable = itemCount > 1;
	if (hasTable)
	{
		lua_newtable(L);
	}
	else if (itemCount == 0)
	{
		lua_pushnil(L);
		return 1;
	}

	bool canDropOnMap = getBoolean(L, 4, true);
	Slots_t slot = getNumber<Slots_t> (L, 6, CONST_SLOT_WHEREEVER);
	auto tier = getNumber<uint8_t> (L, 7, 0);
	for (int32_t i = 1; i <= itemCount; ++i)
	{
		int32_t stackCount = subType;
		if (it.stackable)
		{
			stackCount = std::min<int32_t> (stackCount, 100);
			subType -= stackCount;
		}

		Item *item = Item::CreateItem(itemId, stackCount);
		if (!item)
		{
			if (!hasTable)
			{
				lua_pushnil(L);
			}

			return 1;
		}

		if (tier > 0)
		{
			item->setTier(tier);
		}

		ReturnValue ret = g_game().internalPlayerAddItem(player, item, canDropOnMap, slot);
		if (ret != RETURNVALUE_NOERROR)
		{
			delete item;
			if (!hasTable)
			{
				lua_pushnil(L);
			}

			return 1;
		}

		if (hasTable)
		{
			lua_pushnumber(L, i);
			pushUserdata<Item> (L, item);
			setItemMetatable(L, -1, item);
			lua_settable(L, -3);
		}
		else
		{
			pushUserdata<Item> (L, item);
			setItemMetatable(L, -1, item);
		}
	}

	return 1;
}

int LuaPlayerFunctions::addItemEx(lua_State *L)
{
	// player:addItemEx(item[, canDropOnMap = false[, index = INDEX_WHEREEVER[, flags = 0]]])
	// player:addItemEx(item[, canDropOnMap = true[, slot = CONST_SLOT_WHEREEVER]])
	Item *item = getUserdata<Item> (L, 2);
	if (!item)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder)
	{
		reportErrorFunc("Item already has a parent");
		pushBoolean(L, false);
		return 1;
	}

	bool canDropOnMap = getBoolean(L, 3, false);
	ReturnValue returnValue;
	if (canDropOnMap)
	{
		Slots_t slot = getNumber<Slots_t> (L, 4, CONST_SLOT_WHEREEVER);
		returnValue = g_game().internalPlayerAddItem(player, item, true, slot);
	}
	else
	{
		int32_t index = getNumber<int32_t> (L, 4, INDEX_WHEREEVER);
		uint32_t flags = getNumber<uint32_t> (L, 5, 0);
		returnValue = g_game().internalAddItem(player, item, index, flags);
	}

	if (returnValue == RETURNVALUE_NOERROR)
	{
		ScriptEnvironment::removeTempItem(item);
	}

	lua_pushnumber(L, returnValue);
	return 1;
}

int LuaPlayerFunctions::removeStashItem(lua_State *L)
{
	// player:removeStashItem(itemId, count)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t itemId;
	if (isNumber(L, 2))
	{
		itemId = getNumber<uint16_t> (L, 2);
	}
	else
	{
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0)
		{
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType &itemType = Item::items[itemId];
	if (itemType.id == 0)
	{
		lua_pushnil(L);
		return 1;
	}

	uint32_t count = getNumber<uint32_t> (L, 3);
	pushBoolean(L, player->withdrawItem(itemType.id, count));
	return 1;
}

int LuaPlayerFunctions::removeItem(lua_State *L)
{
	// player:removeItem(itemId, count[, subType = -1[, ignoreEquipped = false]])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t itemId;
	if (isNumber(L, 2))
	{
		itemId = getNumber<uint16_t> (L, 2);
	}
	else
	{
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0)
		{
			lua_pushnil(L);
			return 1;
		}
	}

	uint32_t count = getNumber<uint32_t> (L, 3);
	int32_t subType = getNumber<int32_t> (L, 4, -1);
	bool ignoreEquipped = getBoolean(L, 5, false);
	pushBoolean(L, player->removeItemOfType(itemId, count, subType, ignoreEquipped));
	return 1;
}

int LuaPlayerFunctions::sendContainer(lua_State *L)
{
	// player:sendContainer(container)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Container *container = getUserdata<Container> (L, 2);
	if (!container)
	{
		lua_pushnil(L);
		return 1;
	}

	player->sendContainer(static_cast<uint8_t> (container->getID()), container, container->hasParent(), static_cast<uint8_t> (container->getFirstIndex()));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getMoney(lua_State *L)
{
	// player:getMoney()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getMoney());
	return 1;
}

int LuaPlayerFunctions::addMoney(lua_State *L)
{
	// player:addMoney(money)
	uint64_t money = getNumber<uint64_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	g_game().addMoney(player, money);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeMoney(lua_State *L)
{
	// player:removeMoney(money)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint64_t money = getNumber<uint64_t> (L, 2);
	pushBoolean(L, g_game().removeMoney(player, money));
	return 1;
}

int LuaPlayerFunctions::showTextDialog(lua_State *L)
{
	// player:showTextDialog(id or name or userdata[, text[, canWrite[, length]]])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int32_t length = getNumber<int32_t> (L, 5, -1);
	bool canWrite = getBoolean(L, 4, false);
	std::string text;

	int parameters = lua_gettop(L);
	if (parameters >= 3)
	{
		text = getString(L, 3);
	}

	Item * item;
	if (isNumber(L, 2))
	{
		item = Item::CreateItem(getNumber<uint16_t> (L, 2));
	}
	else if (isString(L, 2))
	{
		item = Item::CreateItem(Item::items.getItemIdByName(getString(L, 2)));
	}
	else if (isUserdata(L, 2))
	{
		if (getUserdataType(L, 2) != LuaData_Item)
		{
			pushBoolean(L, false);
			return 1;
		}

		item = getUserdata<Item> (L, 2);
	}
	else
	{
		item = nullptr;
	}

	if (!item)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (length < 0)
	{
		length = Item::items[item->getID()].maxTextLen;
	}

	if (!text.empty())
	{
		item->setText(text);
		length = std::max<int32_t> (text.size(), length);
	}

	item->setParent(player);
	player->setWriteItem(item, length);
	player->sendTextWindow(item, length, canWrite);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::sendTextMessage(lua_State *L)
{
	// player:sendTextMessage(type, text[, position, primaryValue = 0, primaryColor = TEXTCOLOR_NONE[, secondaryValue = 0, secondaryColor = TEXTCOLOR_NONE]])
	// player:sendTextMessage(type, text, channelId)

	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	int parameters = lua_gettop(L);

	TextMessage message(getNumber<MessageClasses> (L, 2), getString(L, 3));
	if (parameters == 4)
	{
		uint16_t channelId = getNumber<uint16_t> (L, 4);
		ChatChannel *channel = g_chat().getChannel(*player, channelId);
		if (!channel || !channel->hasUser(*player))
		{
			pushBoolean(L, false);
			return 1;
		}

		message.channelId = channelId;
	}
	else
	{
		if (parameters >= 6)
		{
			message.position = getPositionFromLua(L, 4);
			message.primary.value = getNumber<int32_t> (L, 5);
			message.primary.color = getNumber<TextColor_t> (L, 6);
		}

		if (parameters >= 8)
		{
			message.secondary.value = getNumber<int32_t> (L, 7);
			message.secondary.color = getNumber<TextColor_t> (L, 8);
		}
	}

	player->sendTextMessage(message);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::sendChannelMessage(lua_State *L)
{
	// player:sendChannelMessage(author, text, type, channelId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t channelId = getNumber<uint16_t> (L, 5);
	SpeakClasses type = getNumber<SpeakClasses> (L, 4);
	const std::string &text = getString(L, 3);
	const std::string &author = getString(L, 2);
	player->sendChannelMessage(author, text, type, channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::sendPrivateMessage(lua_State *L)
{
	// player:sendPrivateMessage(speaker, text[, type])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const Player *speaker = getPlayerUserdata(L, 2);
	const std::string &text = getString(L, 3);
	SpeakClasses type = getNumber<SpeakClasses> (L, 4, TALKTYPE_PRIVATE_FROM);
	player->sendPrivateMessage(speaker, type, text);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::channelSay(lua_State *L)
{
	// player:channelSay(speaker, type, text, channelId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Creature *speaker = getCreature(L, 2);
	SpeakClasses type = getNumber<SpeakClasses> (L, 3);
	const std::string &text = getString(L, 4);
	uint16_t channelId = getNumber<uint16_t> (L, 5);
	player->sendToChannel(speaker, type, text, channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::openChannel(lua_State *L)
{
	// player:openChannel(channelId)
	uint16_t channelId = getNumber<uint16_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	g_game().playerOpenChannel(player->getID(), channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getSlotItem(lua_State *L)
{
	// player:getSlotItem(slot)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t slot = getNumber<uint32_t> (L, 2);
	Thing *thing = player->getThing(slot);
	if (!thing)
	{
		lua_pushnil(L);
		return 1;
	}

	Item *item = thing->getItem();
	if (item == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Item> (L, item);
	setItemMetatable(L, -1, item);
	return 1;
}

int LuaPlayerFunctions::getParty(lua_State *L)
{
	// player:getParty()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Party *party = player->getParty();
	if (party == nullptr)
	{
		reportErrorFunc("Party nullptr");
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Party> (L, party);
	setMetatable(L, -1, "Party");
	return 1;
}

int LuaPlayerFunctions::addOutfit(lua_State *L)
{
	// player:addOutfit(lookType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addOutfit(getNumber<uint16_t> (L, 2), 0);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addOutfitAddon(lua_State *L)
{
	// player:addOutfitAddon(lookType, addon)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t lookType = getNumber<uint16_t> (L, 2);
	uint8_t addon = getNumber<uint8_t> (L, 3);
	player->addOutfit(lookType, addon);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeOutfit(lua_State *L)
{
	// player:removeOutfit(lookType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t lookType = getNumber<uint16_t> (L, 2);
	pushBoolean(L, player->removeOutfit(lookType));
	return 1;
}

int LuaPlayerFunctions::removeOutfitAddon(lua_State *L)
{
	// player:removeOutfitAddon(lookType, addon)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t lookType = getNumber<uint16_t> (L, 2);
	uint8_t addon = getNumber<uint8_t> (L, 3);
	pushBoolean(L, player->removeOutfitAddon(lookType, addon));
	return 1;
}

int LuaPlayerFunctions::hasOutfit(lua_State *L)
{
	// player:hasOutfit(lookType[, addon = 0])
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t lookType = getNumber<uint16_t> (L, 2);
	uint8_t addon = getNumber<uint8_t> (L, 3, 0);
	pushBoolean(L, player->canWear(lookType, addon));
	return 1;
}

int LuaPlayerFunctions::sendOutfitWindow(lua_State *L)
{
	// player:sendOutfitWindow()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendOutfitWindow();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addMount(lua_State *L)
{
	// player:addMount(mountId or mountName)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint8_t mountId;
	if (isNumber(L, 2))
	{
		mountId = getNumber<uint8_t> (L, 2);
	}
	else
	{
		Mount *mount = g_game().mounts.getMountByName(getString(L, 2));
		if (!mount)
		{
			lua_pushnil(L);
			return 1;
		}

		mountId = mount->id;
	}

	pushBoolean(L, player->tameMount(mountId));
	return 1;
}

int LuaPlayerFunctions::removeMount(lua_State *L)
{
	// player:removeMount(mountId or mountName)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint8_t mountId;
	if (isNumber(L, 2))
	{
		mountId = getNumber<uint8_t> (L, 2);
	}
	else
	{
		Mount *mount = g_game().mounts.getMountByName(getString(L, 2));
		if (!mount)
		{
			lua_pushnil(L);
			return 1;
		}

		mountId = mount->id;
	}

	pushBoolean(L, player->untameMount(mountId));
	return 1;
}

int LuaPlayerFunctions::hasMount(lua_State *L)
{
	// player:hasMount(mountId or mountName)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Mount *mount = nullptr;
	if (isNumber(L, 2))
	{
		mount = g_game().mounts.getMountByID(getNumber<uint8_t> (L, 2));
	}
	else
	{
		mount = g_game().mounts.getMountByName(getString(L, 2));
	}

	if (mount == nullptr)
	{
		reportErrorFunc("Mount nullptr");
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->hasMount(mount));
	return 1;
}

int LuaPlayerFunctions::addFamiliar(lua_State *L)
{
	// player:addFamiliar(lookType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addFamiliar(getNumber<uint16_t> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeFamiliar(lua_State *L)
{
	// player:removeFamiliar(lookType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t lookType = getNumber<uint16_t> (L, 2);
	pushBoolean(L, player->removeFamiliar(lookType));
	return 1;
}

int LuaPlayerFunctions::hasFamiliar(lua_State *L)
{
	// player:hasFamiliar(lookType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t lookType = getNumber<uint16_t> (L, 2);
	pushBoolean(L, player->canFamiliar(lookType));
	return 1;
}

int LuaPlayerFunctions::setFamiliarLooktype(lua_State *L)
{
	// player:setFamiliarLooktype(lookType)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setFamiliarLooktype(getNumber<uint16_t> (L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getFamiliarLooktype(lua_State *L)
{
	// player:getFamiliarLooktype()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->defaultOutfit.lookFamiliarsType);
	return 1;
}

int LuaPlayerFunctions::getPremiumDays(lua_State *L)
{
	// player:getPremiumDays()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->premiumDays);
	return 1;
}

int LuaPlayerFunctions::addPremiumDays(lua_State *L)
{
	// player:addPremiumDays(days)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (player->premiumDays != std::numeric_limits<uint16_t>::max())
	{
		uint16_t days = getNumber<uint16_t> (L, 2);
		int32_t addDays = std::min<int32_t> (0xFFFE - player->premiumDays, days);
		if (addDays > 0)
		{
			player->setPremiumDays(player->premiumDays + addDays);
			IOLoginData::addPremiumDays(player->getAccount(), addDays);
		}
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removePremiumDays(lua_State *L)
{
	// player:removePremiumDays(days)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	if (player->premiumDays != std::numeric_limits<uint16_t>::max())
	{
		uint16_t days = getNumber<uint16_t> (L, 2);
		int32_t removeDays = std::min<int32_t> (player->premiumDays, days);
		if (removeDays > 0)
		{
			player->setPremiumDays(player->premiumDays - removeDays);
			IOLoginData::removePremiumDays(player->getAccount(), removeDays);
		}
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getTibiaCoins(lua_State *L)
{
	// player:getTibiaCoins()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	account::Account account(player->getAccount());
	account.LoadAccountDB();
	uint32_t coins;
	account.GetCoins(&coins);
	lua_pushnumber(L, coins);
	return 1;
}

int LuaPlayerFunctions::addTibiaCoins(lua_State *L)
{
	// player:addTibiaCoins(coins)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t coins = getNumber<uint32_t> (L, 2);

	account::Account account(player->getAccount());
	account.LoadAccountDB();
	if (account.AddCoins(coins))
	{
		account.GetCoins(&(player->coinBalance));
		pushBoolean(L, true);
	}
	else
	{
		lua_pushnil(L);
	}

	return 1;
}

int LuaPlayerFunctions::removeTibiaCoins(lua_State *L)
{
	// player:removeTibiaCoins(coins)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint32_t coins = getNumber<uint32_t> (L, 2);

	account::Account account(player->getAccount());
	account.LoadAccountDB();
	if (account.RemoveCoins(coins))
	{
		account.GetCoins(&(player->coinBalance));
		pushBoolean(L, true);
	}
	else
	{
		lua_pushnil(L);
	}

	return 1;
}

int LuaPlayerFunctions::hasBlessing(lua_State *L)
{
	// player:hasBlessing(blessing)
	uint8_t blessing = getNumber<uint8_t> (L, 2);
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->hasBlessing(blessing));
	return 1;
}

int LuaPlayerFunctions::addBlessing(lua_State *L)
{
	// player:addBlessing(blessing)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint8_t blessing = getNumber<uint8_t> (L, 2);
	uint8_t count = getNumber<uint8_t> (L, 3);

	player->addBlessing(blessing, count);
	player->sendBlessStatus();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeBlessing(lua_State *L)
{
	// player:removeBlessing(blessing)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint8_t blessing = getNumber<uint8_t> (L, 2);
	uint8_t count = getNumber<uint8_t> (L, 3);

	if (!player->hasBlessing(blessing))
	{
		pushBoolean(L, false);
		return 1;
	}

	player->removeBlessing(blessing, count);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getBlessingCount(lua_State *L)
{
	// player:getBlessingCount(index)
	Player *player = getPlayerUserdata(L);
	uint8_t index = getNumber<uint8_t> (L, 2);
	if (index == 0)
	{
		index = 1;
	}

	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getBlessingCount(index));
	return 1;
}

int LuaPlayerFunctions::canLearnSpell(lua_State *L)
{
	// player:canLearnSpell(spellName)
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const std::string &spellName = getString(L, 2);
	const InstantSpell *spell = g_spells().getInstantSpellByName(spellName);
	if (!spell)
	{
		reportErrorFunc("Spell \"" + spellName + "\" not found");
		pushBoolean(L, false);
		return 1;
	}

	if (player->hasFlag(PlayerFlags_t::IgnoreSpellCheck))
	{
		pushBoolean(L, true);
		return 1;
	}

	const auto &vocMap = spell->getVocMap();
	if (vocMap.count(player->getVocationId()) == 0)
	{
		pushBoolean(L, false);
	}
	else if (player->getLevel() < spell->getLevel())
	{
		pushBoolean(L, false);
	}
	else if (player->getMagicLevel() < spell->getMagicLevel())
	{
		pushBoolean(L, false);
	}
	else
	{
		pushBoolean(L, true);
	}

	return 1;
}

int LuaPlayerFunctions::learnSpell(lua_State *L)
{
	// player:learnSpell(spellName)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const std::string &spellName = getString(L, 2);
	player->learnInstantSpell(spellName);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::forgetSpell(lua_State *L)
{
	// player:forgetSpell(spellName)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const std::string &spellName = getString(L, 2);
	player->forgetInstantSpell(spellName);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::hasLearnedSpell(lua_State *L)
{
	// player:hasLearnedSpell(spellName)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const std::string &spellName = getString(L, 2);
	pushBoolean(L, player->hasLearnedInstantSpell(spellName));
	return 1;
}

int LuaPlayerFunctions::sendTutorial(lua_State *L)
{
	// player:sendTutorial(tutorialId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint8_t tutorialId = getNumber<uint8_t> (L, 2);
	player->sendTutorial(tutorialId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::openImbuementWindow(lua_State *L)
{
	// player:openImbuementWindow(item)
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Item *item = getUserdata<Item> (L, 2);
	if (!item)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	player->openImbuementWindow(item);
	return 1;
}

int LuaPlayerFunctions::closeImbuementWindow(lua_State *L)
{
	// player:closeImbuementWindow()
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	player->closeImbuementWindow();
	return 1;
}

int LuaPlayerFunctions::addMapMark(lua_State *L)
{
	// player:addMapMark(position, type, description)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const Position &position = getPositionFromLua(L, 2);
	uint8_t type = getNumber<uint8_t> (L, 3);
	const std::string &description = getString(L, 4);
	player->sendAddMarker(position, type, description);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::save(lua_State *L)
{
	// player:save()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->loginPosition = player->getPosition();
	pushBoolean(L, IOLoginData::savePlayer(player));
	if (player->isOffline())
	{
		delete player;	//avoiding memory leak
	}

	return 1;
}

int LuaPlayerFunctions::popupFYI(lua_State *L)
{
	// player:popupFYI(message)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const std::string &message = getString(L, 2);
	player->sendFYIBox(message);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::isPzLocked(lua_State *L)
{
	// player:isPzLocked()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->isPzLocked());
	return 1;
}

int LuaPlayerFunctions::getClient(lua_State *L)
{
	// player:getClient()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_createtable(L, 0, 2);
	setField(L, "version", player->getProtocolVersion());
	setField(L, "os", player->getOperatingSystem());
	return 1;
}

int LuaPlayerFunctions::getHouse(lua_State *L)
{
	// player:getHouse()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	House *house = g_game().map.houses.getHouseByPlayerId(player->getGUID());
	if (house == nullptr)
	{
		reportErrorFunc("House nullptr");
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<House> (L, house);
	setMetatable(L, -1, "House");
	return 1;
}

int LuaPlayerFunctions::sendHouseWindow(lua_State *L)
{
	// player:sendHouseWindow(house, listId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	House *house = getUserdata<House> (L, 2);
	if (house == nullptr)
	{
		reportErrorFunc("House nullptr");
		pushBoolean(L, false);
		return 0;
	}

	uint32_t listId = getNumber<uint32_t> (L, 3);
	player->sendHouseWindow(house, listId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setEditHouse(lua_State *L)
{
	// player:setEditHouse(house, listId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	House *house = getUserdata<House> (L, 2);
	if (house == nullptr)
	{
		reportErrorFunc("House nullptr");
		pushBoolean(L, false);
		return 0;
	}

	uint32_t listId = getNumber<uint32_t> (L, 3);
	player->setEditHouse(house, listId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setGhostMode(lua_State *L)
{
	// player:setGhostMode(enabled)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	bool enabled = getBoolean(L, 2);
	if (player->isInGhostMode() == enabled)
	{
		pushBoolean(L, true);
		return 1;
	}

	player->switchGhostMode();

	Tile *tile = player->getTile();
	const Position &position = player->getPosition();

	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, position, true, true);
	for (Creature *spectator: spectators)
	{
		Player *tmpPlayer = spectator->getPlayer();
		if (tmpPlayer != player && !tmpPlayer->isAccessPlayer())
		{
			if (enabled)
			{
				tmpPlayer->sendRemoveTileThing(position, tile->getStackposOfCreature(tmpPlayer, player));
			}
			else
			{
				tmpPlayer->sendCreatureAppear(player, position, true);
			}
		}
		else
		{
			tmpPlayer->sendCreatureChangeVisible(player, !enabled);
		}
	}

	if (player->isInGhostMode())
	{
		for (const auto &it: g_game().getPlayers())
		{
			if (!it.second->isAccessPlayer())
			{
				it.second->notifyStatusChange(player, VIPSTATUS_OFFLINE);
			}
		}

		IOLoginData::updateOnlineStatus(player->getGUID(), false);
	}
	else
	{
		for (const auto &it: g_game().getPlayers())
		{
			if (!it.second->isAccessPlayer())
			{
				it.second->notifyStatusChange(player, player->statusVipList);
			}
		}

		IOLoginData::updateOnlineStatus(player->getGUID(), true);
	}

	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getContainerId(lua_State *L)
{
	// player:getContainerId(container)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Container *container = getUserdata<Container> (L, 2);
	if (container == nullptr)
	{
		reportErrorFunc("Container nullptr");
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getContainerID(container));
	return 1;
}

int LuaPlayerFunctions::getContainerById(lua_State *L)
{
	// player:getContainerById(id)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Container *container = player->getContainerByID(getNumber<uint8_t> (L, 2));
	if (container == nullptr)
	{
		reportErrorFunc("Container nullptr");
		pushBoolean(L, false);
		return 0;
	}

	pushUserdata<Container> (L, container);
	setMetatable(L, -1, "Container");
	return 1;
}

int LuaPlayerFunctions::getContainerIndex(lua_State *L)
{
	// player:getContainerIndex(id)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getContainerIndex(getNumber<uint8_t> (L, 2)));
	return 1;
}

int LuaPlayerFunctions::getInstantSpells(lua_State *L)
{
	// player:getInstantSpells()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	std::vector<const InstantSpell*> spells;
	for (auto &[key, spell]: g_spells().getInstantSpells())
	{
		if (spell.canCast(player))
		{
			spells.push_back(&spell);
		}
	}

	lua_createtable(L, spells.size(), 0);

	int index = 0;
	for (auto spell: spells)
	{
		pushInstantSpell(L, *spell);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaPlayerFunctions::canCast(lua_State *L)
{
	// player:canCast(spell)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	InstantSpell *spell = getUserdata<InstantSpell> (L, 2);
	if (spell == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, spell->canCast(player));
	return 1;
}

int LuaPlayerFunctions::hasChaseMode(lua_State *L)
{
	// player:hasChaseMode()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->chaseMode);
	return 1;
}

int LuaPlayerFunctions::hasSecureMode(lua_State *L)
{
	// player:hasSecureMode()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->secureMode);
	return 1;
}

int LuaPlayerFunctions::getFightMode(lua_State *L)
{
	// player:getFightMode()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->fightMode);
	return 1;
}

int LuaPlayerFunctions::getBaseXpGain(lua_State *L)
{
	// player:getBaseXpGain()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getBaseXpGain());
	return 1;
}

int LuaPlayerFunctions::setBaseXpGain(lua_State *L)
{
	// player:setBaseXpGain(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setBaseXpGain(getNumber<uint16_t> (L, 2));
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getVoucherXpBoost(lua_State *L)
{
	// player:getVoucherXpBoost()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getVoucherXpBoost());
	return 1;
}

int LuaPlayerFunctions::setVoucherXpBoost(lua_State *L)
{
	// player:setVoucherXpBoost(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setVoucherXpBoost(getNumber<uint16_t> (L, 2));
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getGrindingXpBoost(lua_State *L)
{
	// player:getGrindingXpBoost()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getGrindingXpBoost());
	return 1;
}

int LuaPlayerFunctions::setGrindingXpBoost(lua_State *L)
{
	// player:setGrindingXpBoost(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setGrindingXpBoost(getNumber<uint16_t> (L, 2));
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getStoreXpBoost(lua_State *L)
{
	// player:getStoreXpBoost()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getStoreXpBoost());
	return 1;
}

int LuaPlayerFunctions::setStoreXpBoost(lua_State *L)
{
	// player:setStoreXpBoost(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t experience = getNumber<uint16_t> (L, 2);
	player->setStoreXpBoost(experience);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getStaminaXpBoost(lua_State *L)
{
	// player:getStaminaXpBoost()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getStaminaXpBoost());
	return 1;
}

int LuaPlayerFunctions::setStaminaXpBoost(lua_State *L)
{
	// player:setStaminaXpBoost(value)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setStaminaXpBoost(getNumber<uint16_t> (L, 2));
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::setExpBoostStamina(lua_State *L)
{
	// player:setExpBoostStamina(percent)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	uint16_t stamina = getNumber<uint16_t> (L, 2);
	player->setExpBoostStamina(stamina);
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getExpBoostStamina(lua_State *L)
{
	// player:getExpBoostStamina()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getExpBoostStamina());
	return 1;
}

int LuaPlayerFunctions::getIdleTime(lua_State *L)
{
	// player:getIdleTime()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getIdleTime());
	return 1;
}

int LuaPlayerFunctions::getFreeBackpackSlots(lua_State *L)
{
	// player:getFreeBackpackSlots()
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		lua_pushnil(L);
	}

	lua_pushnumber(L, std::max<uint16_t> (0, player->getFreeBackpackSlots()));
	return 1;
}

int LuaPlayerFunctions::isOffline(lua_State *L)
{
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->isOffline());
	return 1;
}

int LuaPlayerFunctions::openMarket(lua_State *L)
{
	// player:openMarket()
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendMarketEnter(player->getLastDepotId());
	pushBoolean(L, true);
	return 1;
}

// Forge
int LuaPlayerFunctions::openForge(lua_State *L)
{
	// player:openForge()
	const Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendOpenForge();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::closeForge(lua_State *L)
{
	// player:closeForge()
	const Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->closeForgeWindow();
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addForgeDusts(lua_State *L)
{
	// player:addForgeDusts(amount)
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addForgeDusts(getNumber<uint64_t> (L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeForgeDusts(lua_State *L)
{
	// player:removeForgeDusts(amount)
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->removeForgeDusts(getNumber<uint64_t> (L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getForgeDusts(lua_State *L)
{
	// player:getForgeDusts()
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number> (player->getForgeDusts()));
	return 1;
}

int LuaPlayerFunctions::setForgeDusts(lua_State *L)
{
	// player:setForgeDusts()
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setForgeDusts(getNumber<uint64_t> (L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::addForgeDustLevel(lua_State *L)
{
	// player:addForgeDustLevel(amount)
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addForgeDustLevel(getNumber<uint64_t> (L, 2, 1));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::removeForgeDustLevel(lua_State *L)
{
	// player:removeForgeDustLevel(amount)
	Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->removeForgeDustLevel(getNumber<uint64_t> (L, 2, 1));
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getForgeDustLevel(lua_State *L)
{
	// player:getForgeDustLevel()
	const Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number> (player->getForgeDustLevel()));
	return 1;
}

int LuaPlayerFunctions::getForgeSlivers(lua_State *L)
{
	// player:getForgeSlivers()
	const Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto[sliver, core] = player->getForgeSliversAndCores();
	lua_pushnumber(L, static_cast<lua_Number> (sliver));
	return 1;
}

int LuaPlayerFunctions::getForgeCores(lua_State *L)
{
	// player:getForgeCores()
	const Player *player = getPlayerUserdata(L);
	if (!player)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto[sliver, core] = player->getForgeSliversAndCores();
	lua_pushnumber(L, static_cast<lua_Number> (core));
	return 1;
}

int LuaPlayerFunctions::setFaction(lua_State *L)
{
	// player:setFaction(factionId)
	Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	Faction_t factionId = getNumber<Faction_t> (L, 2);
	player->setFaction(factionId);
	pushBoolean(L, true);
	return 1;
}

int LuaPlayerFunctions::getFaction(lua_State *L)
{
	// player:getFaction()
	const Player *player = getPlayerUserdata(L);
	if (player == nullptr)
	{
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getFaction());
	return 1;
}
