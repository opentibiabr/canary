/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/player/player_functions.hpp"

#include "account/account.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/creature.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/vip/player_vip.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "game/game.hpp"
#include "game/scheduling/save_manager.hpp"
#include "io/iobestiary.hpp"
#include "io/iologindata.hpp"
#include "io/ioprey.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/item.hpp"
#include "map/spectators.hpp"

#include "enums/account_coins.hpp"
#include "enums/account_errors.hpp"
#include "enums/player_icons.hpp"

int PlayerFunctions::luaPlayerSendInventory(lua_State* L) {
	// player:sendInventory()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendInventoryIds();
	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendLootStats(lua_State* L) {
	// player:sendLootStats(item, count)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto count = getNumber<uint8_t>(L, 3, 0);
	if (count == 0) {
		lua_pushnil(L);
		return 1;
	}

	player->sendLootStats(item, count);
	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerUpdateSupplyTracker(lua_State* L) {
	// player:updateSupplyTracker(item)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	player->updateSupplyTracker(item);
	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerUpdateKillTracker(lua_State* L) {
	// player:updateKillTracker(creature, corpse)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &monster = getUserdataShared<Creature>(L, 2);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto &corpse = getUserdataShared<Container>(L, 3);
	if (!corpse) {
		lua_pushnil(L);
		return 1;
	}

	player->updateKillTracker(corpse, monster->getName(), monster->getCurrentOutfit());
	pushBoolean(L, true);

	return 1;
}

// Player
int PlayerFunctions::luaPlayerCreate(lua_State* L) {
	// Player(id or guid or name or userdata)
	std::shared_ptr<Player> player;
	if (isNumber(L, 2)) {
		const uint32_t id = getNumber<uint32_t>(L, 2);
		if (id >= Player::getFirstID() && id <= Player::getLastID()) {
			player = g_game().getPlayerByID(id);
		} else {
			player = g_game().getPlayerByGUID(id);
		}
	} else if (isString(L, 2)) {
		ReturnValue ret = g_game().getPlayerByNameWildcard(getString(L, 2), player);
		if (ret != RETURNVALUE_NOERROR) {
			lua_pushnil(L);
			lua_pushnumber(L, ret);
			return 2;
		}
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_t::Player) {
			lua_pushnil(L);
			return 1;
		}
		player = getUserdataShared<Player>(L, 2);
	} else {
		player = nullptr;
	}

	if (player) {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerResetCharmsMonsters(lua_State* L) {
	// player:resetCharmsBestiary()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setCharmPoints(0);
		player->setCharmExpansion(false);
		player->setUsedRunesBit(0);
		player->setUnlockedRunesBit(0);
		for (int8_t i = CHARM_WOUND; i <= CHARM_LAST; i++) {
			player->parseRacebyCharm(static_cast<charmRune_t>(i), true, 0);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerUnlockAllCharmRunes(lua_State* L) {
	// player:unlockAllCharmRunes()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		for (int8_t i = CHARM_WOUND; i <= CHARM_LAST; i++) {
			const auto charm = g_iobestiary().getBestiaryCharm(static_cast<charmRune_t>(i));
			if (charm) {
				const int32_t value = g_iobestiary().bitToggle(player->getUnlockedRunesBit(), charm, true);
				player->setUnlockedRunesBit(value);
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayeraddCharmPoints(lua_State* L) {
	// player:addCharmPoints()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		int16_t charms = getNumber<int16_t>(L, 2);
		if (charms >= 0) {
			g_iobestiary().addCharmPoints(player, static_cast<uint16_t>(charms));
		} else {
			charms = -charms;
			g_iobestiary().addCharmPoints(player, static_cast<uint16_t>(charms), true);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerIsPlayer(lua_State* L) {
	// player:isPlayer()
	pushBoolean(L, getUserdataShared<Player>(L, 1) != nullptr);
	return 1;
}

int PlayerFunctions::luaPlayerGetGuid(lua_State* L) {
	// player:getGuid()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getGUID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetIp(lua_State* L) {
	// player:getIp()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getIP());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetAccountId(lua_State* L) {
	// player:getAccountId()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || player->getAccountId() == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getAccountId());

	return 1;
}

int PlayerFunctions::luaPlayerGetLastLoginSaved(lua_State* L) {
	// player:getLastLoginSaved()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLoginSaved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetLastLogout(lua_State* L) {
	// player:getLastLogout()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLogout());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetAccountType(lua_State* L) {
	// player:getAccountType()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getAccountType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetAccountType(lua_State* L) {
	// player:setAccountType(accountType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->setAccountType(getNumber<AccountType>(L, 2)) != AccountErrors_t::Ok) {
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddBestiaryKill(lua_State* L) {
	// player:addBestiaryKill(name[, amount = 1])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const auto &mtype = g_monsters().getMonsterType(getString(L, 2));
		if (mtype) {
			g_iobestiary().addBestiaryKill(player, mtype, getNumber<uint32_t>(L, 3, 1));
			pushBoolean(L, true);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerIsMonsterBestiaryUnlocked(lua_State* L) {
	// player:isMonsterBestiaryUnlocked(raceId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const auto raceId = getNumber<uint16_t>(L, 2, 0);
	if (!g_monsters().getMonsterTypeByRaceId(raceId)) {
		reportErrorFunc("Monster race id not exists");
		pushBoolean(L, false);
		return 0;
	}

	for (const uint16_t finishedRaceId : g_iobestiary().getBestiaryFinished(player)) {
		if (raceId == finishedRaceId) {
			pushBoolean(L, true);
			return 1;
		}
	}

	pushBoolean(L, false);
	return 0;
}

int PlayerFunctions::luaPlayergetCharmMonsterType(lua_State* L) {
	// player:getCharmMonsterType(charmRune_t)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const charmRune_t charmid = getNumber<charmRune_t>(L, 2);
		const uint16_t raceid = player->parseRacebyCharm(charmid, false, 0);
		if (raceid > 0) {
			const auto &mtype = g_monsters().getMonsterTypeByRaceId(raceid);
			if (mtype) {
				pushUserdata<MonsterType>(L, mtype);
				setMetatable(L, -1, "MonsterType");
			} else {
				lua_pushnil(L);
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemovePreyStamina(lua_State* L) {
	// player:removePreyStamina(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		g_ioprey().checkPlayerPreys(player, getNumber<uint8_t>(L, 2, 1));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddPreyCards(lua_State* L) {
	// player:addPreyCards(amount)
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		player->addPreyCards(getNumber<uint64_t>(L, 2, 0));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPreyCards(lua_State* L) {
	// player:getPreyCards()
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		lua_pushnumber(L, static_cast<lua_Number>(player->getPreyCards()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPreyExperiencePercentage(lua_State* L) {
	// player:getPreyExperiencePercentage(raceId)
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		if (const std::unique_ptr<PreySlot> &slot = player->getPreyWithMonster(getNumber<uint16_t>(L, 2, 0));
		    slot && slot->isOccupied() && slot->bonus == PreyBonus_Experience && slot->bonusTimeLeft > 0) {
			lua_pushnumber(L, static_cast<lua_Number>(100 + slot->bonusPercentage));
		} else {
			lua_pushnumber(L, 100);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveTaskHuntingPoints(lua_State* L) {
	// player:removeTaskHuntingPoints(amount)
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		pushBoolean(L, player->useTaskHuntingPoints(getNumber<uint64_t>(L, 2, 0)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetTaskHuntingPoints(lua_State* L) {
	// player:getTaskHuntingPoints()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, static_cast<double>(player->getTaskHuntingPoints()));
	return 1;
}

int PlayerFunctions::luaPlayerAddTaskHuntingPoints(lua_State* L) {
	// player:addTaskHuntingPoints(amount)
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		const auto points = getNumber<uint64_t>(L, 2);
		player->addTaskHuntingPoints(getNumber<uint64_t>(L, 2));
		lua_pushnumber(L, static_cast<lua_Number>(points));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPreyLootPercentage(lua_State* L) {
	// player:getPreyLootPercentage(raceid)
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		if (const std::unique_ptr<PreySlot> &slot = player->getPreyWithMonster(getNumber<uint16_t>(L, 2, 0));
		    slot && slot->isOccupied() && slot->bonus == PreyBonus_Loot) {
			lua_pushnumber(L, slot->bonusPercentage);
		} else {
			lua_pushnumber(L, 0);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerisMonsterPrey(lua_State* L) {
	// player:isMonsterPrey(raceid)
	if (const auto &player = getUserdataShared<Player>(L, 1)) {
		if (const std::unique_ptr<PreySlot> &slot = player->getPreyWithMonster(getNumber<uint16_t>(L, 2, 0));
		    slot && slot->isOccupied()) {
			pushBoolean(L, true);
		} else {
			pushBoolean(L, false);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerPreyThirdSlot(lua_State* L) {
	// get: player:preyThirdSlot() set: player:preyThirdSlot(bool)
	if (const auto &player = getUserdataShared<Player>(L, 1);
	    const auto &slot = player->getPreySlotById(PreySlot_Three)) {
		if (!slot) {
			lua_pushnil(L);
		} else if (lua_gettop(L) == 1) {
			pushBoolean(L, slot->state != PreyDataState_Locked);
		} else {
			if (getBoolean(L, 2, false)) {
				slot->eraseBonus();
				slot->state = PreyDataState_Selection;
				slot->reloadMonsterGrid(player->getPreyBlackList(), player->getLevel());
				player->reloadPreySlot(PreySlot_Three);
			} else {
				slot->state = PreyDataState_Locked;
			}

			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int PlayerFunctions::luaPlayerTaskThirdSlot(lua_State* L) {
	// get: player:taskHuntingThirdSlot() set: player:taskHuntingThirdSlot(bool)
	if (const auto &player = getUserdataShared<Player>(L, 1);
	    const auto &slot = player->getTaskHuntingSlotById(PreySlot_Three)) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, slot->state != PreyTaskDataState_Locked);
		} else {
			if (getBoolean(L, 2, false)) {
				slot->eraseTask();
				slot->reloadReward();
				slot->state = PreyTaskDataState_Selection;
				slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
				player->reloadTaskSlot(PreySlot_Three);
			} else {
				slot->state = PreyTaskDataState_Locked;
			}

			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayercharmExpansion(lua_State* L) {
	// get: player:charmExpansion() set: player:charmExpansion(bool)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, player->hasCharmExpansion());
		} else {
			player->setCharmExpansion(getBoolean(L, 2, false));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetCapacity(lua_State* L) {
	// player:getCapacity()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetCapacity(lua_State* L) {
	// player:setCapacity(capacity)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->capacity = getNumber<uint32_t>(L, 2);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetTraining(lua_State* L) {
	// player:setTraining(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const bool value = getBoolean(L, 2, false);
		player->setTraining(value);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetIsTraining(lua_State* L) {
	// player:isTraining()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	lua_pushnumber(L, player->isExerciseTraining());
	return 1;
}

int PlayerFunctions::luaPlayerGetFreeCapacity(lua_State* L) {
	// player:getFreeCapacity()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getFreeCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetKills(lua_State* L) {
	// player:getKills()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, player->unjustifiedKills.size(), 0);
	int idx = 0;
	for (const auto &kill : player->unjustifiedKills) {
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

int PlayerFunctions::luaPlayerSetKills(lua_State* L) {
	// player:setKills(kills)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	luaL_checktype(L, 2, LUA_TTABLE);
	std::vector<Kill> newKills;

	lua_pushnil(L);
	while (lua_next(L, 2) != 0) {
		// -2 is index, -1 is value
		luaL_checktype(L, -1, LUA_TTABLE);
		lua_rawgeti(L, -1, 1); // push target
		lua_rawgeti(L, -2, 2); // push time
		lua_rawgeti(L, -3, 3); // push unavenged
		newKills.emplace_back(luaL_checknumber(L, -3), luaL_checknumber(L, -2), getBoolean(L, -1));
		lua_pop(L, 4);
	}

	player->unjustifiedKills = std::move(newKills);
	player->sendUnjustifiedPoints();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetReward(lua_State* L) {
	// player:getReward(rewardId[, autoCreate = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint64_t rewardId = getNumber<uint64_t>(L, 2);
	const bool autoCreate = getBoolean(L, 3, false);
	if (const auto &reward = player->getReward(rewardId, autoCreate)) {
		pushUserdata<Item>(L, reward);
		setItemMetatable(L, -1, reward);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveReward(lua_State* L) {
	// player:removeReward(rewardId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t rewardId = getNumber<uint32_t>(L, 2);
	player->removeReward(rewardId);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetRewardList(lua_State* L) {
	// player:getRewardList()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::vector<uint64_t> rewardVec;
	player->getRewardList(rewardVec);
	lua_createtable(L, rewardVec.size(), 0);

	int index = 0;
	for (const auto &rewardId : rewardVec) {
		lua_pushnumber(L, static_cast<lua_Number>(rewardId));
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetDailyReward(lua_State* L) {
	// player:setDailyReward(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setDailyReward(getNumber<uint8_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetDepotLocker(lua_State* L) {
	// player:getDepotLocker(depotId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t depotId = getNumber<uint32_t>(L, 2);
	const auto &depotLocker = player->getDepotLocker(depotId);
	if (depotLocker) {
		depotLocker->setParent(player);
		pushUserdata<Item>(L, depotLocker);
		setItemMetatable(L, -1, depotLocker);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStashCounter(lua_State* L) {
	// player:getStashCount()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t sizeStash = getStashSize(player->getStashItems());
		lua_pushnumber(L, sizeStash);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetDepotChest(lua_State* L) {
	// player:getDepotChest(depotId[, autoCreate = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t depotId = getNumber<uint32_t>(L, 2);
	const bool autoCreate = getBoolean(L, 3, false);
	const auto &depotChest = player->getDepotChest(depotId, autoCreate);
	if (depotChest) {
		player->setLastDepotId(depotId);
		pushUserdata<Item>(L, depotChest);
		setItemMetatable(L, -1, depotChest);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetInbox(lua_State* L) {
	// player:getInbox()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &inbox = player->getInbox();
	if (inbox) {
		pushUserdata<Item>(L, inbox);
		setItemMetatable(L, -1, inbox);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkullTime(lua_State* L) {
	// player:getSkullTime()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSkullTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSkullTime(lua_State* L) {
	// player:setSkullTime(skullTime)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setSkullTicks(getNumber<int64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetDeathPenalty(lua_State* L) {
	// player:getDeathPenalty()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, static_cast<uint32_t>(player->getLostPercent() * 100));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetExperience(lua_State* L) {
	// player:getExperience()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getExperience());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddExperience(lua_State* L) {
	// player:addExperience(experience[, sendText = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const int64_t experience = getNumber<int64_t>(L, 2);
		const bool sendText = getBoolean(L, 3, false);
		player->addExperience(nullptr, experience, sendText);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveExperience(lua_State* L) {
	// player:removeExperience(experience[, sendText = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const int64_t experience = getNumber<int64_t>(L, 2);
		const bool sendText = getBoolean(L, 3, false);
		player->removeExperience(experience, sendText);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetLevel(lua_State* L) {
	// player:getLevel()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMagicShieldCapacityFlat(lua_State* L) {
	// player:getMagicShieldCapacityFlat(useCharges)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicShieldCapacityFlat(getBoolean(L, 2, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMagicShieldCapacityPercent(lua_State* L) {
	// player:getMagicShieldCapacityPercent(useCharges)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicShieldCapacityPercent(getBoolean(L, 2, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendSpellCooldown(lua_State* L) {
	// player:sendSpellCooldown(spellId, time)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	const uint8_t spellId = getNumber<uint32_t>(L, 2, 1);
	const auto time = getNumber<uint32_t>(L, 3, 0);

	player->sendSpellCooldown(spellId, time);
	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendSpellGroupCooldown(lua_State* L) {
	// player:sendSpellGroupCooldown(groupId, time)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	const auto groupId = getNumber<SpellGroup_t>(L, 2, SPELLGROUP_ATTACK);
	const auto time = getNumber<uint32_t>(L, 3, 0);

	player->sendSpellGroupCooldown(groupId, time);
	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerGetMagicLevel(lua_State* L) {
	// player:getMagicLevel()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseMagicLevel(lua_State* L) {
	// player:getBaseMagicLevel()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMana(lua_State* L) {
	// player:getMana()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddMana(lua_State* L) {
	// player:addMana(manaChange[, animationOnLoss = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const int32_t manaChange = getNumber<int32_t>(L, 2);
	const bool animationOnLoss = getBoolean(L, 3, false);
	if (!animationOnLoss && manaChange < 0) {
		player->changeMana(manaChange);
	} else {
		CombatDamage damage;
		damage.primary.value = manaChange;
		damage.origin = ORIGIN_NONE;
		g_game().combatChangeMana(nullptr, player, damage);
	}
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetMaxMana(lua_State* L) {
	// player:getMaxMana()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMaxMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetMaxMana(lua_State* L) {
	// player:setMaxMana(maxMana)
	const auto &player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->manaMax = getNumber<int32_t>(L, 2);
	player->mana = std::min<int32_t>(player->mana, player->manaMax);
	g_game().addPlayerMana(player);
	player->sendStats();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetManaSpent(lua_State* L) {
	// player:getManaSpent()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSpentMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddManaSpent(lua_State* L) {
	// player:addManaSpent(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->addManaSpent(getNumber<uint64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseMaxHealth(lua_State* L) {
	// player:getBaseMaxHealth()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->healthMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseMaxMana(lua_State* L) {
	// player:getBaseMaxMana()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->manaMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkillLevel(lua_State* L) {
	// player:getSkillLevel(skillType)
	const skills_t skillType = getNumber<skills_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetEffectiveSkillLevel(lua_State* L) {
	// player:getEffectiveSkillLevel(skillType)
	const skills_t skillType = getNumber<skills_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->getSkillLevel(skillType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkillPercent(lua_State* L) {
	// player:getSkillPercent(skillType)
	const skills_t skillType = getNumber<skills_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].percent);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSkillTries(lua_State* L) {
	// player:getSkillTries(skillType)
	const skills_t skillType = getNumber<skills_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].tries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddSkillTries(lua_State* L) {
	// player:addSkillTries(skillType, tries)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const skills_t skillType = getNumber<skills_t>(L, 2);
		const uint64_t tries = getNumber<uint64_t>(L, 3);
		player->addSkillAdvance(skillType, tries);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetLevel(lua_State* L) {
	// player:setLevel(level)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t level = getNumber<uint16_t>(L, 2);
		player->level = level;
		player->experience = Player::getExpForLevel(level);
		player->sendStats();
		player->sendSkills();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetMagicLevel(lua_State* L) {
	// player:setMagicLevel(level[, manaSpent])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t level = getNumber<uint16_t>(L, 2);
		player->magLevel = level;
		if (getNumber<uint64_t>(L, 3, 0) > 0) {
			const uint64_t manaSpent = getNumber<uint64_t>(L, 3);
			const uint64_t nextReqMana = player->vocation->getReqMana(level + 1);
			player->manaSpent = manaSpent;
			player->magLevelPercent = Player::getPercentLevel(manaSpent, nextReqMana);
		} else {
			player->manaSpent = 0;
			player->magLevelPercent = 0;
		}
		player->sendStats();
		player->sendSkills();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSkillLevel(lua_State* L) {
	// player:setSkillLevel(skillType, level[, tries])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const skills_t skillType = getNumber<skills_t>(L, 2);
		const uint16_t level = getNumber<uint16_t>(L, 3);
		player->skills[skillType].level = level;
		if (getNumber<uint64_t>(L, 4, 0) > 0) {
			const uint64_t tries = getNumber<uint64_t>(L, 4);
			const uint64_t nextReqTries = player->vocation->getReqSkillTries(skillType, level + 1);
			player->skills[skillType].tries = tries;
			player->skills[skillType].percent = Player::getPercentLevel(tries, nextReqTries);
		} else {
			player->skills[skillType].tries = 0;
			player->skills[skillType].percent = 0;
		}
		player->sendStats();
		player->sendSkills();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOfflineTrainingTime(lua_State* L) {
	// player:addOfflineTrainingTime(time)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const int32_t time = getNumber<int32_t>(L, 2);
		player->addOfflineTrainingTime(time);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetOfflineTrainingTime(lua_State* L) {
	// player:getOfflineTrainingTime()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveOfflineTrainingTime(lua_State* L) {
	// player:removeOfflineTrainingTime(time)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const int32_t time = getNumber<int32_t>(L, 2);
		player->removeOfflineTrainingTime(time);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOfflineTrainingTries(lua_State* L) {
	// player:addOfflineTrainingTries(skillType, tries)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const skills_t skillType = getNumber<skills_t>(L, 2);
		const uint64_t tries = getNumber<uint64_t>(L, 3);
		pushBoolean(L, player->addOfflineTrainingTries(skillType, tries));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetOfflineTrainingSkill(lua_State* L) {
	// player:getOfflineTrainingSkill()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingSkill());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetOfflineTrainingSkill(lua_State* L) {
	// player:setOfflineTrainingSkill(skillId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const int8_t skillId = getNumber<int8_t>(L, 2);
		player->setOfflineTrainingSkill(skillId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerOpenStash(lua_State* L) {
	// player:openStash(isNpc)
	const auto &player = getUserdataShared<Player>(L, 1);
	const bool isNpc = getBoolean(L, 2, false);
	if (player) {
		player->sendOpenStash(isNpc);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int PlayerFunctions::luaPlayerGetItemCount(lua_State* L) {
	// player:getItemCount(itemId[, subType = -1])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const auto subType = getNumber<int32_t>(L, 3, -1);
	lua_pushnumber(L, player->getItemTypeCount(itemId, subType));
	return 1;
}

int PlayerFunctions::luaPlayerGetStashItemCount(lua_State* L) {
	// player:getStashItemCount(itemId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType &itemType = Item::items[itemId];
	if (itemType.id == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getStashItemCount(itemType.id));
	return 1;
}

int PlayerFunctions::luaPlayerGetItemById(lua_State* L) {
	// player:getItemById(itemId, deepSearch[, subType = -1])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	const bool deepSearch = getBoolean(L, 3);
	const auto subType = getNumber<int32_t>(L, 4, -1);

	const auto &item = g_game().findItemOfType(player, itemId, deepSearch, subType);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetVocation(lua_State* L) {
	// player:getVocation()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushUserdata<Vocation>(L, player->getVocation());
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetVocation(lua_State* L) {
	// player:setVocation(id or name or userdata)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Vocation> vocation;
	if (isNumber(L, 2)) {
		vocation = g_vocations().getVocation(getNumber<uint16_t>(L, 2));
	} else if (isString(L, 2)) {
		vocation = g_vocations().getVocation(g_vocations().getVocationId(getString(L, 2)));
	} else if (isUserdata(L, 2)) {
		vocation = getUserdataShared<Vocation>(L, 2);
	} else {
		vocation = nullptr;
	}

	if (!vocation) {
		pushBoolean(L, false);
		return 1;
	}

	player->setVocation(vocation->getId());
	player->sendSkills();
	player->sendStats();
	player->sendBasicData();
	player->wheel()->sendGiftOfLifeCooldown();
	g_game().reloadCreature(player);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerIsPromoted(lua_State* L) {
	// player:isPromoted()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->isPromoted());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSex(lua_State* L) {
	// player:getSex()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSex());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSex(lua_State* L) {
	// player:setSex(newSex)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const PlayerSex_t newSex = getNumber<PlayerSex_t>(L, 2);
		player->setSex(newSex);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPronoun(lua_State* L) {
	// player:getPronoun()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getPronoun());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetPronoun(lua_State* L) {
	// player:setPronoun(newPronoun)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const PlayerPronoun_t newPronoun = getNumber<PlayerPronoun_t>(L, 2);
		player->setPronoun(newPronoun);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetTown(lua_State* L) {
	// player:getTown()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushUserdata<Town>(L, player->getTown());
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetTown(lua_State* L) {
	// player:setTown(town)
	const auto &town = getUserdataShared<Town>(L, 2);
	if (!town) {
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setTown(town);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetGuild(lua_State* L) {
	// player:getGuild()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &guild = player->getGuild();
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Guild>(L, guild);
	setMetatable(L, -1, "Guild");
	return 1;
}

int PlayerFunctions::luaPlayerSetGuild(lua_State* L) {
	// player:setGuild(guild)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &guild = getUserdataShared<Guild>(L, 2);
	player->setGuild(guild);

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetGuildLevel(lua_State* L) {
	// player:getGuildLevel()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && player->getGuild()) {
		lua_pushnumber(L, player->getGuildRank()->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGuildLevel(lua_State* L) {
	// player:setGuildLevel(level)
	const uint8_t level = getNumber<uint8_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getGuild()) {
		lua_pushnil(L);
		return 1;
	}

	const auto &rank = player->getGuild()->getRankByLevel(level);
	if (!rank) {
		pushBoolean(L, false);
	} else {
		player->setGuildRank(rank);
		pushBoolean(L, true);
	}

	return 1;
}

int PlayerFunctions::luaPlayerGetGuildNick(lua_State* L) {
	// player:getGuildNick()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushString(L, player->getGuildNick());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGuildNick(lua_State* L) {
	// player:setGuildNick(nick)
	const std::string &nick = getString(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setGuildNick(nick);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetGroup(lua_State* L) {
	// player:getGroup()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushUserdata<Group>(L, player->getGroup());
		setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGroup(lua_State* L) {
	// player:setGroup(group)
	const auto &group = getUserdataShared<Group>(L, 2);
	if (!group) {
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setGroup(group);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetSpecialContainersAvailable(lua_State* L) {
	// player:setSpecialContainersAvailable(stashMenu, marketMenu, depotSearchMenu)
	const bool supplyStashMenu = getBoolean(L, 2, false);
	const bool marketMenu = getBoolean(L, 3, false);
	const bool depotSearchMenu = getBoolean(L, 4, false);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setSpecialMenuAvailable(supplyStashMenu, marketMenu, depotSearchMenu);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStamina(lua_State* L) {
	// player:getStamina()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getStaminaMinutes());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetStamina(lua_State* L) {
	// player:setStamina(stamina)
	const uint16_t stamina = getNumber<uint16_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->staminaMinutes = std::min<uint16_t>(2520, stamina);
		player->sendStats();
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSoul(lua_State* L) {
	// player:getSoul()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSoul());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddSoul(lua_State* L) {
	// player:addSoul(soulChange)
	const int32_t soulChange = getNumber<int32_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->changeSoul(soulChange);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetMaxSoul(lua_State* L) {
	// player:getMaxSoul()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && player->vocation) {
		lua_pushnumber(L, player->vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBankBalance(lua_State* L) {
	// player:getBankBalance()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBankBalance());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetBankBalance(lua_State* L) {
	// player:setBankBalance(bankBalance)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setBankBalance(getNumber<uint64_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetStorageValue(lua_State* L) {
	// player:getStorageValue(key)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t key = getNumber<uint32_t>(L, 2);
	lua_pushnumber(L, player->getStorageValue(key));
	return 1;
}

int PlayerFunctions::luaPlayerSetStorageValue(lua_State* L) {
	// player:setStorageValue(key, value)
	const int32_t value = getNumber<int32_t>(L, 3);
	const uint32_t key = getNumber<uint32_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		std::ostringstream ss;
		ss << "Accessing reserved range: " << key;
		reportErrorFunc(ss.str());
		pushBoolean(L, false);
		return 1;
	}

	if (key == 0) {
		reportErrorFunc("Storage key is nil");
		return 1;
	}

	if (player) {
		player->addStorageValue(key, value);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStorageValueByName(lua_State* L) {
	// player:getStorageValueByName(name)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	g_logger().warn("The function 'player:getStorageValueByName' is deprecated and will be removed in future versions, please use KV system");
	const auto name = getString(L, 2);
	lua_pushnumber(L, player->getStorageValueByName(name));
	return 1;
}

int PlayerFunctions::luaPlayerSetStorageValueByName(lua_State* L) {
	// player:setStorageValueByName(storageName, value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	g_logger().warn("The function 'player:setStorageValueByName' is deprecated and will be removed in future versions, please use KV system");
	const auto storageName = getString(L, 2);
	const int32_t value = getNumber<int32_t>(L, 3);

	player->addStorageValueByName(storageName, value);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddItem(lua_State* L) {
	// player:addItem(itemId, count = 1, canDropOnMap = true, subType = 1, slot = CONST_SLOT_WHEREEVER, tier = 0)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const auto count = getNumber<int32_t>(L, 3, 1);
	auto subType = getNumber<int32_t>(L, 5, 1);

	const ItemType &it = Item::items[itemId];

	int32_t itemCount = 1;
	const int parameters = lua_gettop(L);
	if (parameters >= 4) {
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = std::ceil(count / static_cast<float_t>(it.stackSize));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	const bool hasTable = itemCount > 1;
	if (hasTable) {
		lua_newtable(L);
	} else if (itemCount == 0) {
		lua_pushnil(L);
		return 1;
	}

	const bool canDropOnMap = getBoolean(L, 4, true);
	const auto slot = getNumber<Slots_t>(L, 6, CONST_SLOT_WHEREEVER);
	const auto tier = getNumber<uint8_t>(L, 7, 0);
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

		if (tier > 0) {
			item->setTier(tier);
		}

		ReturnValue ret = g_game().internalPlayerAddItem(player, item, canDropOnMap, slot);
		if (ret != RETURNVALUE_NOERROR) {
			if (!hasTable) {
				lua_pushnil(L);
			}

			player->sendCancelMessage(ret);
			return 1;
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

int PlayerFunctions::luaPlayerAddItemEx(lua_State* L) {
	// player:addItemEx(item[, canDropOnMap = false[, index = INDEX_WHEREEVER[, flags = 0]]])
	// player:addItemEx(item[, canDropOnMap = true[, slot = CONST_SLOT_WHEREEVER]])
	const auto &item = getUserdataShared<Item>(L, 2);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc("Item already has a parent");
		pushBoolean(L, false);
		return 1;
	}

	const bool canDropOnMap = getBoolean(L, 3, false);
	ReturnValue returnValue;
	if (canDropOnMap) {
		const auto slot = getNumber<Slots_t>(L, 4, CONST_SLOT_WHEREEVER);
		returnValue = g_game().internalPlayerAddItem(player, item, true, slot);
	} else {
		const auto index = getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
		const auto flags = getNumber<uint32_t>(L, 5, 0);
		returnValue = g_game().internalAddItem(player, item, index, flags);
	}

	if (returnValue == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, returnValue);
	return 1;
}

int PlayerFunctions::luaPlayerAddItemStash(lua_State* L) {
	// player:addItemStash(itemId, count = 1)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto itemId = getNumber<uint16_t>(L, 2);
	const auto count = getNumber<uint32_t>(L, 3, 1);

	player->addItemOnStash(itemId, count);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveStashItem(lua_State* L) {
	// player:removeStashItem(itemId, count)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType &itemType = Item::items[itemId];
	if (itemType.id == 0) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t count = getNumber<uint32_t>(L, 3);
	pushBoolean(L, player->withdrawItem(itemType.id, count));
	return 1;
}

int PlayerFunctions::luaPlayerRemoveItem(lua_State* L) {
	// player:removeItem(itemId, count[, subType = -1[, ignoreEquipped = false]])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const uint32_t count = getNumber<uint32_t>(L, 3);
	const auto subType = getNumber<int32_t>(L, 4, -1);
	const bool ignoreEquipped = getBoolean(L, 5, false);
	pushBoolean(L, player->removeItemOfType(itemId, count, subType, ignoreEquipped));
	return 1;
}

int PlayerFunctions::luaPlayerSendContainer(lua_State* L) {
	// player:sendContainer(container)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = getUserdataShared<Container>(L, 2);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	player->sendContainer(static_cast<uint8_t>(container->getID()), container, container->hasParent(), static_cast<uint8_t>(container->getFirstIndex()));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendUpdateContainer(lua_State* L) {
	// player:sendUpdateContainer(container)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = getUserdataShared<Container>(L, 2);
	if (!container) {
		reportErrorFunc("Container is nullptr");
		return 1;
	}

	player->onSendContainer(container);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetMoney(lua_State* L) {
	// player:getMoney()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMoney());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddMoney(lua_State* L) {
	// player:addMoney(money)
	const uint64_t money = getNumber<uint64_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		g_game().addMoney(player, money);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveMoney(lua_State* L) {
	// player:removeMoney(money[, flags = 0[, useBank = true]])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint64_t money = getNumber<uint64_t>(L, 2);
		const auto flags = getNumber<int32_t>(L, 3, 0);
		const bool useBank = getBoolean(L, 4, true);
		pushBoolean(L, g_game().removeMoney(player, money, flags, useBank));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerShowTextDialog(lua_State* L) {
	// player:showTextDialog(id or name or userdata[, text[, canWrite[, length]]])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	auto length = getNumber<int32_t>(L, 5, -1);
	const bool canWrite = getBoolean(L, 4, false);
	std::string text;

	const int parameters = lua_gettop(L);
	if (parameters >= 3) {
		text = getString(L, 3);
	}

	std::shared_ptr<Item> item;
	if (isNumber(L, 2)) {
		item = Item::CreateItem(getNumber<uint16_t>(L, 2));
	} else if (isString(L, 2)) {
		item = Item::CreateItem(Item::items.getItemIdByName(getString(L, 2)));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_t::Item) {
			pushBoolean(L, false);
			return 1;
		}

		item = getUserdataShared<Item>(L, 2);
	} else {
		item = nullptr;
	}

	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (length < 0) {
		length = Item::items[item->getID()].maxTextLen;
	}

	if (!text.empty()) {
		item->setAttribute(ItemAttribute_t::TEXT, text);
		length = std::max<int32_t>(text.size(), length);
	}

	item->setParent(player);
	player->setWriteItem(item, length);
	player->sendTextWindow(item, length, canWrite);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendTextMessage(lua_State* L) {
	// player:sendTextMessage(type, text[, position, primaryValue = 0, primaryColor = TEXTCOLOR_NONE[, secondaryValue = 0, secondaryColor = TEXTCOLOR_NONE]])
	// player:sendTextMessage(type, text, channelId)

	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const int parameters = lua_gettop(L);

	TextMessage message(getNumber<MessageClasses>(L, 2), getString(L, 3));
	if (parameters == 4) {
		const uint16_t channelId = getNumber<uint16_t>(L, 4);
		const auto &channel = g_chat().getChannel(player, channelId);
		if (!channel || !channel->hasUser(player)) {
			pushBoolean(L, false);
			return 1;
		}
		message.channelId = channelId;
	} else {
		if (parameters >= 6) {
			message.position = getPosition(L, 4);
			message.primary.value = getNumber<int32_t>(L, 5);
			message.primary.color = getNumber<TextColor_t>(L, 6);
		}

		if (parameters >= 8) {
			message.secondary.value = getNumber<int32_t>(L, 7);
			message.secondary.color = getNumber<TextColor_t>(L, 8);
		}
	}

	player->sendTextMessage(message);
	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerSendChannelMessage(lua_State* L) {
	// player:sendChannelMessage(author, text, type, channelId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint16_t channelId = getNumber<uint16_t>(L, 5);
	const SpeakClasses type = getNumber<SpeakClasses>(L, 4);
	const std::string &text = getString(L, 3);
	const std::string &author = getString(L, 2);
	player->sendChannelMessage(author, text, type, channelId);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendPrivateMessage(lua_State* L) {
	// player:sendPrivateMessage(speaker, text[, type])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &speaker = getUserdataShared<Player>(L, 2);
	const std::string &text = getString(L, 3);
	const auto type = getNumber<SpeakClasses>(L, 4, TALKTYPE_PRIVATE_FROM);
	player->sendPrivateMessage(speaker, type, text);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerChannelSay(lua_State* L) {
	// player:channelSay(speaker, type, text, channelId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &speaker = getCreature(L, 2);
	const SpeakClasses type = getNumber<SpeakClasses>(L, 3);
	const std::string &text = getString(L, 4);
	const uint16_t channelId = getNumber<uint16_t>(L, 5);
	player->sendToChannel(speaker, type, text, channelId);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerOpenChannel(lua_State* L) {
	// player:openChannel(channelId)
	const uint16_t channelId = getNumber<uint16_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		g_game().playerOpenChannel(player->getID(), channelId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetSlotItem(lua_State* L) {
	// player:getSlotItem(slot)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t slot = getNumber<uint32_t>(L, 2);
	const auto &thing = player->getThing(slot);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = thing->getItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetParty(lua_State* L) {
	// player:getParty()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &party = player->getParty();
	if (party) {
		pushUserdata<Party>(L, party);
		setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOutfit(lua_State* L) {
	// player:addOutfit(lookType or name, addon = 0)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		auto addon = getNumber<uint8_t>(L, 3, 0);
		if (lua_isnumber(L, 2)) {
			player->addOutfit(getNumber<uint16_t>(L, 2), addon);
		} else if (lua_isstring(L, 2)) {
			const std::string &outfitName = getString(L, 2);
			const auto &outfit = Outfits::getInstance().getOutfitByName(player->getSex(), outfitName);
			if (!outfit) {
				reportErrorFunc("Outfit not found");
				return 1;
			}

			player->addOutfit(outfit->lookType, addon);
		}

		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddOutfitAddon(lua_State* L) {
	// player:addOutfitAddon(lookType, addon)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = getNumber<uint16_t>(L, 2);
		const uint8_t addon = getNumber<uint8_t>(L, 3);
		player->addOutfit(lookType, addon);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveOutfit(lua_State* L) {
	// player:removeOutfit(lookType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = getNumber<uint16_t>(L, 2);
		pushBoolean(L, player->removeOutfit(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveOutfitAddon(lua_State* L) {
	// player:removeOutfitAddon(lookType, addon)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = getNumber<uint16_t>(L, 2);
		const uint8_t addon = getNumber<uint8_t>(L, 3);
		pushBoolean(L, player->removeOutfitAddon(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasOutfit(lua_State* L) {
	// player:hasOutfit(lookType[, addon = 0])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = getNumber<uint16_t>(L, 2);
		const auto addon = getNumber<uint8_t>(L, 3, 0);
		pushBoolean(L, player->canWear(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendOutfitWindow(lua_State* L) {
	// player:sendOutfitWindow()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->sendOutfitWindow();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddMount(lua_State* L) {
	// player:addMount(mountId or mountName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (isNumber(L, 2)) {
		mountId = getNumber<uint8_t>(L, 2);
	} else {
		const auto &mount = g_game().mounts->getMountByName(getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	pushBoolean(L, player->tameMount(mountId));
	return 1;
}

int PlayerFunctions::luaPlayerRemoveMount(lua_State* L) {
	// player:removeMount(mountId or mountName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (isNumber(L, 2)) {
		mountId = getNumber<uint8_t>(L, 2);
	} else {
		const auto &mount = g_game().mounts->getMountByName(getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	pushBoolean(L, player->untameMount(mountId));
	return 1;
}

int PlayerFunctions::luaPlayerHasMount(lua_State* L) {
	// player:hasMount(mountId or mountName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Mount> mount = nullptr;
	if (isNumber(L, 2)) {
		mount = g_game().mounts->getMountByID(getNumber<uint8_t>(L, 2));
	} else {
		mount = g_game().mounts->getMountByName(getString(L, 2));
	}

	if (mount) {
		pushBoolean(L, player->hasMount(mount));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddFamiliar(lua_State* L) {
	// player:addFamiliar(lookType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->addFamiliar(getNumber<uint16_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerRemoveFamiliar(lua_State* L) {
	// player:removeFamiliar(lookType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = getNumber<uint16_t>(L, 2);
		pushBoolean(L, player->removeFamiliar(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasFamiliar(lua_State* L) {
	// player:hasFamiliar(lookType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t lookType = getNumber<uint16_t>(L, 2);
		pushBoolean(L, player->canFamiliar(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetFamiliarLooktype(lua_State* L) {
	// player:setFamiliarLooktype(lookType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setFamiliarLooktype(getNumber<uint16_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetFamiliarLooktype(lua_State* L) {
	// player:getFamiliarLooktype()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->defaultOutfit.lookFamiliarsType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetPremiumDays(lua_State* L) {
	// player:getPremiumDays()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player && player->getAccount()) {
		lua_pushnumber(L, player->getAccount()->getPremiumRemainingDays());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddPremiumDays(lua_State* L) {
	// player:addPremiumDays(days)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		lua_pushnil(L);
		return 1;
	}

	const auto premiumDays = player->getAccount()->getPremiumRemainingDays();

	if (premiumDays == std::numeric_limits<uint16_t>::max()) {
		return 1;
	}

	const int32_t addDays = std::min<int32_t>(0xFFFE - premiumDays, getNumber<uint16_t>(L, 2));
	if (addDays <= 0) {
		return 1;
	}

	player->getAccount()->addPremiumDays(addDays);

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		return 1;
	}

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemovePremiumDays(lua_State* L) {
	// player:removePremiumDays(days)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		lua_pushnil(L);
		return 1;
	}

	const auto premiumDays = player->getAccount()->getPremiumRemainingDays();

	if (premiumDays == std::numeric_limits<uint16_t>::max()) {
		return 1;
	}

	const int32_t removeDays = std::min<int32_t>(0xFFFE - premiumDays, getNumber<uint16_t>(L, 2));
	if (removeDays <= 0) {
		return 1;
	}

	player->getAccount()->addPremiumDays(-removeDays);

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		return 1;
	}

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetTibiaCoins(lua_State* L) {
	// player:getTibiaCoins()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	auto [coins, result] = player->getAccount()->getCoins(CoinType::Normal);

	if (result == AccountErrors_t::Ok) {
		lua_pushnumber(L, coins);
	}

	return 1;
}

int PlayerFunctions::luaPlayerAddTibiaCoins(lua_State* L) {
	// player:addTibiaCoins(coins)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->addCoins(CoinType::Normal, getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		reportErrorFunc("Failed to add coins");
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		reportErrorFunc("Failed to save account");
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerRemoveTibiaCoins(lua_State* L) {
	// player:removeTibiaCoins(coins)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->removeCoins(CoinType::Normal, getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		reportErrorFunc("Failed to remove coins");
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		reportErrorFunc("Failed to save account");
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerGetTransferableCoins(lua_State* L) {
	// player:getTransferableCoins()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	auto [coins, result] = player->getAccount()->getCoins(CoinType::Transferable);

	if (result == AccountErrors_t::Ok) {
		lua_pushnumber(L, coins);
	}

	return 1;
}

int PlayerFunctions::luaPlayerAddTransferableCoins(lua_State* L) {
	// player:addTransferableCoins(coins)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->addCoins(CoinType::Transferable, getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		reportErrorFunc("failed to add transferable coins");
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		reportErrorFunc("failed to save account");
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerRemoveTransferableCoins(lua_State* L) {
	// player:removeTransferableCoins(coins)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player || !player->getAccount()) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (player->account->removeCoins(CoinType::Transferable, getNumber<uint32_t>(L, 2)) != AccountErrors_t::Ok) {
		reportErrorFunc("failed to remove transferable coins");
		lua_pushnil(L);
		return 1;
	}

	if (player->getAccount()->save() != AccountErrors_t::Ok) {
		reportErrorFunc("failed to save account");
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, true);

	return 1;
}

int PlayerFunctions::luaPlayerHasBlessing(lua_State* L) {
	// player:hasBlessing(blessing)
	const uint8_t blessing = getNumber<uint8_t>(L, 2);
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->hasBlessing(blessing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddBlessing(lua_State* L) {
	// player:addBlessing(blessing)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint8_t blessing = getNumber<uint8_t>(L, 2);
	const uint8_t count = getNumber<uint8_t>(L, 3);

	player->addBlessing(blessing, count);
	player->sendBlessStatus();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveBlessing(lua_State* L) {
	// player:removeBlessing(blessing)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const uint8_t blessing = getNumber<uint8_t>(L, 2);
	const uint8_t count = getNumber<uint8_t>(L, 3);

	if (!player->hasBlessing(blessing)) {
		pushBoolean(L, false);
		return 1;
	}

	player->removeBlessing(blessing, count);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetBlessingCount(lua_State* L) {
	// player:getBlessingCount(index[, storeCount = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	uint8_t index = getNumber<uint8_t>(L, 2);
	if (index == 0) {
		index = 1;
	}

	if (player) {
		lua_pushnumber(L, player->getBlessingCount(index, getBoolean(L, 3, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerCanLearnSpell(lua_State* L) {
	// player:canLearnSpell(spellName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string &spellName = getString(L, 2);
	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		reportErrorFunc("Spell \"" + spellName + "\" not found");
		pushBoolean(L, false);
		return 1;
	}

	if (player->hasFlag(PlayerFlags_t::IgnoreSpellCheck)) {
		pushBoolean(L, true);
		return 1;
	}

	const auto vocMap = spell->getVocMap();
	if (!vocMap.contains(player->getVocationId())) {
		pushBoolean(L, false);
	} else if (player->getLevel() < spell->getLevel()) {
		pushBoolean(L, false);
	} else if (player->getMagicLevel() < spell->getMagicLevel()) {
		pushBoolean(L, false);
	} else {
		pushBoolean(L, true);
	}
	return 1;
}

int PlayerFunctions::luaPlayerLearnSpell(lua_State* L) {
	// player:learnSpell(spellName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &spellName = getString(L, 2);
		player->learnInstantSpell(spellName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerForgetSpell(lua_State* L) {
	// player:forgetSpell(spellName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &spellName = getString(L, 2);
		player->forgetInstantSpell(spellName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasLearnedSpell(lua_State* L) {
	// player:hasLearnedSpell(spellName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &spellName = getString(L, 2);
		pushBoolean(L, player->hasLearnedInstantSpell(spellName));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendTutorial(lua_State* L) {
	// player:sendTutorial(tutorialId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint8_t tutorialId = getNumber<uint8_t>(L, 2);
		player->sendTutorial(tutorialId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerOpenImbuementWindow(lua_State* L) {
	// player:openImbuementWindow(item)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	const auto &item = getUserdataShared<Item>(L, 2);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	player->openImbuementWindow(item);
	return 1;
}

int PlayerFunctions::luaPlayerCloseImbuementWindow(lua_State* L) {
	// player:closeImbuementWindow()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	player->closeImbuementWindow();
	return 1;
}

int PlayerFunctions::luaPlayerAddMapMark(lua_State* L) {
	// player:addMapMark(position, type, description)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const Position &position = getPosition(L, 2);
		const uint8_t type = getNumber<uint8_t>(L, 3);
		const std::string &description = getString(L, 4);
		player->sendAddMarker(position, type, description);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSave(lua_State* L) {
	// player:save()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		if (!player->isOffline()) {
			player->loginPosition = player->getPosition();
		}
		pushBoolean(L, g_saveManager().savePlayer(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerPopupFYI(lua_State* L) {
	// player:popupFYI(message)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const std::string &message = getString(L, 2);
		player->sendFYIBox(message);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerIsPzLocked(lua_State* L) {
	// player:isPzLocked()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->isPzLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetClient(lua_State* L) {
	// player:getClient()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_createtable(L, 0, 2);
		setField(L, "version", player->getProtocolVersion());
		setField(L, "os", player->getOperatingSystem());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetHouse(lua_State* L) {
	// player:getHouse()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = g_game().map.houses.getHouseByPlayerId(player->getGUID());
	if (house) {
		pushUserdata<House>(L, house);
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSendHouseWindow(lua_State* L) {
	// player:sendHouseWindow(house, listId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = getUserdataShared<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t listId = getNumber<uint32_t>(L, 3);
	player->sendHouseWindow(house, listId);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSetEditHouse(lua_State* L) {
	// player:setEditHouse(house, listId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &house = getUserdataShared<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t listId = getNumber<uint32_t>(L, 3);
	player->setEditHouse(house, listId);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSetGhostMode(lua_State* L) {
	// player:setGhostMode(enabled)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const bool enabled = getBoolean(L, 2);
	if (player->isInGhostMode() == enabled) {
		pushBoolean(L, true);
		return 1;
	}

	player->switchGhostMode();

	const auto &tile = player->getTile();
	const Position &position = player->getPosition();

	for (const auto &spectator : Spectators().find<Player>(position, true)) {
		const auto &tmpPlayer = spectator->getPlayer();
		if (tmpPlayer != player && !tmpPlayer->isAccessPlayer()) {
			if (enabled) {
				tmpPlayer->sendRemoveTileThing(position, tile->getStackposOfCreature(tmpPlayer, player));
			} else {
				tmpPlayer->sendCreatureAppear(player, position, true);
			}
		} else {
			tmpPlayer->sendCreatureChangeVisible(player, !enabled);
		}
	}

	if (player->isInGhostMode()) {
		for (const auto &it : g_game().getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->vip()->notifyStatusChange(player, VipStatus_t::Offline);
			}
		}
	} else {
		for (const auto &it : g_game().getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->vip()->notifyStatusChange(player, player->vip()->getStatus());
			}
		}
	}
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetContainerId(lua_State* L) {
	// player:getContainerId(container)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = getUserdataShared<Container>(L, 2);
	if (container) {
		lua_pushnumber(L, player->getContainerID(container));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetContainerById(lua_State* L) {
	// player:getContainerById(id)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = player->getContainerByID(getNumber<uint8_t>(L, 2));
	if (container) {
		pushUserdata<Container>(L, container);
		setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetContainerIndex(lua_State* L) {
	// player:getContainerIndex(id)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getContainerIndex(getNumber<uint8_t>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetInstantSpells(lua_State* L) {
	// player:getInstantSpells()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::vector<std::shared_ptr<InstantSpell>> spells;
	for (const auto &[key, spell] : g_spells().getInstantSpells()) {
		if (spell->canCast(player)) {
			spells.push_back(spell);
		}
	}

	lua_createtable(L, spells.size(), 0);

	int index = 0;
	for (const auto &spell : spells) {
		pushInstantSpell(L, *spell);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PlayerFunctions::luaPlayerCanCast(lua_State* L) {
	// player:canCast(spell)
	const auto &player = getUserdataShared<Player>(L, 1);
	const auto &spell = getUserdataShared<InstantSpell>(L, 2);
	if (player && spell) {
		pushBoolean(L, spell->canCast(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasChaseMode(lua_State* L) {
	// player:hasChaseMode()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->chaseMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasSecureMode(lua_State* L) {
	// player:hasSecureMode()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->secureMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetFightMode(lua_State* L) {
	// player:getFightMode()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->fightMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBaseXpGain(lua_State* L) {
	// player:getBaseXpGain()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseXpGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetBaseXpGain(lua_State* L) {
	// player:setBaseXpGain(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setBaseXpGain(getNumber<uint16_t>(L, 2));
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetVoucherXpBoost(lua_State* L) {
	// player:getVoucherXpBoost()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getVoucherXpBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetVoucherXpBoost(lua_State* L) {
	// player:setVoucherXpBoost(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setVoucherXpBoost(getNumber<uint16_t>(L, 2));
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetGrindingXpBoost(lua_State* L) {
	// player:getGrindingXpBoost()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getGrindingXpBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetGrindingXpBoost(lua_State* L) {
	// player:setGrindingXpBoost(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setGrindingXpBoost(getNumber<uint16_t>(L, 2));
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetXpBoostPercent(lua_State* L) {
	// player:getXpBoostPercent()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getXpBoostPercent());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetXpBoostPercent(lua_State* L) {
	// player:setXpBoostPercent(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t percent = getNumber<uint16_t>(L, 2);
		player->setXpBoostPercent(percent);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetStaminaXpBoost(lua_State* L) {
	// player:getStaminaXpBoost()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getStaminaXpBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetStaminaXpBoost(lua_State* L) {
	// player:setStaminaXpBoost(value)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		player->setStaminaXpBoost(getNumber<uint16_t>(L, 2));
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetXpBoostTime(lua_State* L) {
	// player:setXpBoostTime(timeLeft)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		const uint16_t timeLeft = getNumber<uint16_t>(L, 2);
		player->setXpBoostTime(timeLeft);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetXpBoostTime(lua_State* L) {
	// player:getXpBoostTime()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getXpBoostTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetIdleTime(lua_State* L) {
	// player:getIdleTime()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getIdleTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetFreeBackpackSlots(lua_State* L) {
	// player:getFreeBackpackSlots()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
	}

	lua_pushnumber(L, std::max<uint16_t>(0, player->getFreeBackpackSlots()));
	return 1;
}

int PlayerFunctions::luaPlayerIsOffline(lua_State* L) {
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->isOffline());
	} else {
		pushBoolean(L, true);
	}

	return 1;
}

int PlayerFunctions::luaPlayerOpenMarket(lua_State* L) {
	// player:openMarket()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendMarketEnter(player->getLastDepotId());
	pushBoolean(L, true);
	return 1;
}

// Forge
int PlayerFunctions::luaPlayerOpenForge(lua_State* L) {
	// player:openForge()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendOpenForge();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerCloseForge(lua_State* L) {
	// player:closeForge()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->closeForgeWindow();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddForgeDusts(lua_State* L) {
	// player:addForgeDusts(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addForgeDusts(getNumber<uint64_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveForgeDusts(lua_State* L) {
	// player:removeForgeDusts(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->removeForgeDusts(getNumber<uint64_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeDusts(lua_State* L) {
	// player:getForgeDusts()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(player->getForgeDusts()));
	return 1;
}

int PlayerFunctions::luaPlayerSetForgeDusts(lua_State* L) {
	// player:setForgeDusts()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setForgeDusts(getNumber<uint64_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddForgeDustLevel(lua_State* L) {
	// player:addForgeDustLevel(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->addForgeDustLevel(getNumber<uint64_t>(L, 2, 1));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveForgeDustLevel(lua_State* L) {
	// player:removeForgeDustLevel(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->removeForgeDustLevel(getNumber<uint64_t>(L, 2, 1));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeDustLevel(lua_State* L) {
	// player:getForgeDustLevel()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, static_cast<lua_Number>(player->getForgeDustLevel()));
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeSlivers(lua_State* L) {
	// player:getForgeSlivers()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto [sliver, core] = player->getForgeSliversAndCores();
	lua_pushnumber(L, static_cast<lua_Number>(sliver));
	return 1;
}

int PlayerFunctions::luaPlayerGetForgeCores(lua_State* L) {
	// player:getForgeCores()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	auto [sliver, core] = player->getForgeSliversAndCores();
	lua_pushnumber(L, static_cast<lua_Number>(core));
	return 1;
}

int PlayerFunctions::luaPlayerSetFaction(lua_State* L) {
	// player:setFaction(factionId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const Faction_t factionId = getNumber<Faction_t>(L, 2);
	player->setFaction(factionId);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetFaction(lua_State* L) {
	// player:getFaction()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (player == nullptr) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->getFaction());
	return 1;
}

int PlayerFunctions::luaPlayerIsUIExhausted(lua_State* L) {
	// player:isUIExhausted()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const uint16_t time = getNumber<uint16_t>(L, 2);
	pushBoolean(L, player->isUIExhausted(time));
	return 1;
}

int PlayerFunctions::luaPlayerUpdateUIExhausted(lua_State* L) {
	// player:updateUIExhausted(exhaustionTime = 250)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->updateUIExhausted();
	pushBoolean(L, true);
	return 1;
}

// Bosstiary Cooldown Timer
int PlayerFunctions::luaPlayerBosstiaryCooldownTimer(lua_State* L) {
	// player:sendBosstiaryCooldownTimer()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->sendBosstiaryCooldownTimer();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetBosstiaryLevel(lua_State* L) {
	// player:getBosstiaryLevel(name)
	if (const auto &player = getUserdataShared<Player>(L, 1);
	    player) {
		const auto &mtype = g_monsters().getMonsterType(getString(L, 2));
		if (mtype) {
			const uint32_t bossId = mtype->info.raceid;
			if (bossId == 0) {
				lua_pushnil(L);
				return 0;
			}
			const auto level = g_ioBosstiary().getBossCurrentLevel(player, bossId);
			lua_pushnumber(L, level);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetBosstiaryKills(lua_State* L) {
	// player:getBosstiaryKills(name)
	if (const auto &player = getUserdataShared<Player>(L, 1);
	    player) {
		const auto &mtype = g_monsters().getMonsterType(getString(L, 2));
		if (mtype) {
			const uint32_t bossId = mtype->info.raceid;
			if (bossId == 0) {
				lua_pushnil(L);
				return 0;
			}
			const uint32_t currentKills = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));
			lua_pushnumber(L, currentKills);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerAddBosstiaryKill(lua_State* L) {
	// player:addBosstiaryKill(name[, amount = 1])
	if (const auto &player = getUserdataShared<Player>(L, 1);
	    player) {
		const auto &mtype = g_monsters().getMonsterType(getString(L, 2));
		if (mtype) {
			g_ioBosstiary().addBosstiaryKill(player, mtype, getNumber<uint32_t>(L, 3, 1));
			pushBoolean(L, true);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetBossPoints(lua_State* L) {
	// player:setBossPoints()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setBossPoints(getNumber<uint32_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSetRemoveBossTime(lua_State* L) {
	// player:setRemoveBossTime()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setRemoveBossTime(getNumber<uint8_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetSlotBossId(lua_State* L) {
	// player:getSlotBossId(slotId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const uint8_t slotId = getNumber<uint8_t>(L, 2);
	const auto bossId = player->getSlotBossId(slotId);
	lua_pushnumber(L, static_cast<lua_Number>(bossId));
	return 1;
}

int PlayerFunctions::luaPlayerGetBossBonus(lua_State* L) {
	// player:getBossBonus(slotId)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const uint8_t slotId = getNumber<uint8_t>(L, 2);
	const auto bossId = player->getSlotBossId(slotId);

	const uint32_t playerBossPoints = player->getBossPoints();
	const uint16_t currentBonus = g_ioBosstiary().calculateLootBonus(playerBossPoints);

	const auto bossLevel = g_ioBosstiary().getBossCurrentLevel(player, bossId);
	const uint16_t bonusBoss = currentBonus + (bossLevel == 3 ? 25 : 0);

	lua_pushnumber(L, static_cast<lua_Number>(bonusBoss));
	return 1;
}

int PlayerFunctions::luaPlayerSendSingleSoundEffect(lua_State* L) {
	// player:sendSingleSoundEffect(soundId[, actor = true])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const SoundEffect_t soundEffect = getNumber<SoundEffect_t>(L, 2);
	const bool actor = getBoolean(L, 3, true);

	player->sendSingleSoundEffect(player->getPosition(), soundEffect, actor ? SourceEffect_t::OWN : SourceEffect_t::GLOBAL);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendDoubleSoundEffect(lua_State* L) {
	// player:sendDoubleSoundEffect(mainSoundId, secondarySoundId[, actor = true])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const SoundEffect_t mainSoundEffect = getNumber<SoundEffect_t>(L, 2);
	const SoundEffect_t secondarySoundEffect = getNumber<SoundEffect_t>(L, 3);
	const bool actor = getBoolean(L, 4, true);

	player->sendDoubleSoundEffect(player->getPosition(), mainSoundEffect, actor ? SourceEffect_t::OWN : SourceEffect_t::GLOBAL, secondarySoundEffect, actor ? SourceEffect_t::OWN : SourceEffect_t::GLOBAL);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetName(lua_State* L) {
	// player:getName()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushString(L, player->getName());
	return 1;
}

int PlayerFunctions::luaPlayerChangeName(lua_State* L) {
	// player:changeName(newName)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}
	if (player->isOnline()) {
		player->removePlayer(true, true);
	}
	player->kv()->remove("namelock");
	const auto newName = getString(L, 2);
	player->setName(newName);
	g_saveManager().savePlayer(player);
	return 1;
}

int PlayerFunctions::luaPlayerHasGroupFlag(lua_State* L) {
	// player:hasGroupFlag(flag)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->hasFlag(getNumber<PlayerFlags_t>(L, 2)));
	return 1;
}

int PlayerFunctions::luaPlayerSetGroupFlag(lua_State* L) {
	// player:setGroupFlag(flag)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->setFlag(getNumber<PlayerFlags_t>(L, 2));
	return 1;
}

int PlayerFunctions::luaPlayerRemoveGroupFlag(lua_State* L) {
	// player:removeGroupFlag(flag)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	player->removeFlag(getNumber<PlayerFlags_t>(L, 2));
	return 1;
}

// Hazard system
int PlayerFunctions::luaPlayerAddHazardSystemPoints(lua_State* L) {
	// player:setHazardSystemPoints(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->setHazardSystemPoints(getNumber<int32_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetHazardSystemPoints(lua_State* L) {
	// player:getHazardSystemPoints()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	lua_pushnumber(L, player->getHazardSystemPoints());
	return 1;
}

int PlayerFunctions::luaPlayerSetLoyaltyBonus(lua_State* L) {
	// player:setLoyaltyBonus(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setLoyaltyBonus(getNumber<uint16_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetLoyaltyBonus(lua_State* L) {
	// player:getLoyaltyBonus()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getLoyaltyBonus());
	return 1;
}

int PlayerFunctions::luaPlayerGetLoyaltyPoints(lua_State* L) {
	// player:getLoyaltyPoints()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getLoyaltyPoints());
	return 1;
}

int PlayerFunctions::luaPlayerGetLoyaltyTitle(lua_State* L) {
	// player:getLoyaltyTitle()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	pushString(L, player->getLoyaltyTitle());
	return 1;
}

int PlayerFunctions::luaPlayerSetLoyaltyTitle(lua_State* L) {
	// player:setLoyaltyTitle(name)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setLoyaltyTitle(getString(L, 2));
	pushBoolean(L, true);
	return 1;
}

// Wheel of destiny system
int PlayerFunctions::luaPlayerInstantSkillWOD(lua_State* L) {
	// player:instantSkillWOD(name[, value])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string name = getString(L, 2);
	if (lua_gettop(L) == 2) {
		pushBoolean(L, player->wheel()->getInstant(name));
	} else {
		player->wheel()->setSpellInstant(name, getBoolean(L, 3));
		pushBoolean(L, true);
	}
	return 1;
}

int PlayerFunctions::luaPlayerUpgradeSpellWOD(lua_State* L) {
	// player:upgradeSpellsWOD([name[, add]])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		player->wheel()->resetUpgradedSpells();
		return 1;
	}

	const std::string name = getString(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, static_cast<lua_Number>(player->wheel()->getSpellUpgrade(name)));
		return 1;
	}

	const bool add = getBoolean(L, 3);
	if (add) {
		player->wheel()->upgradeSpell(name);
	} else {
		player->wheel()->downgradeSpell(name);
	}

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRevelationStageWOD(lua_State* L) {
	// player:revelationStageWOD([name[, set]])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		player->wheel()->resetUpgradedSpells();
		return 1;
	}

	const std::string name = getString(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, static_cast<lua_Number>(player->wheel()->getStage(name)));
		return 1;
	}

	const bool value = getNumber<uint8_t>(L, 3);
	player->wheel()->setSpellInstant(name, value);

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerReloadData(lua_State* L) {
	// player:reloadData()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendSkills();
	player->sendStats();
	player->sendBasicData();
	player->wheel()->sendGiftOfLifeCooldown();
	g_game().reloadCreature(player);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerOnThinkWheelOfDestiny(lua_State* L) {
	// player:onThinkWheelOfDestiny([force = false])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->wheel()->onThink(getBoolean(L, 2, false));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAvatarTimer(lua_State* L) {
	// player:avatarTimer([value])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(player->wheel()->getOnThinkTimer(WheelOnThink_t::AVATAR_SPELL)));
	} else {
		player->wheel()->setOnThinkTimer(WheelOnThink_t::AVATAR_SPELL, getNumber<int64_t>(L, 2));
		pushBoolean(L, true);
	}
	return 1;
}

int PlayerFunctions::luaPlayerGetWheelSpellAdditionalArea(lua_State* L) {
	// player:getWheelSpellAdditionalArea(spellname)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const auto spellName = getString(L, 2);
	if (spellName.empty()) {
		reportErrorFunc("Spell name is empty");
		pushBoolean(L, false);
		return 0;
	}

	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	pushBoolean(L, player->wheel()->getSpellAdditionalArea(spellName));
	return 1;
}

int PlayerFunctions::luaPlayerGetWheelSpellAdditionalTarget(lua_State* L) {
	// player:getWheelSpellAdditionalTarget(spellname)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const auto spellName = getString(L, 2);
	if (spellName.empty()) {
		reportErrorFunc("Spell name is empty");
		pushBoolean(L, false);
		return 0;
	}

	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->wheel()->getSpellAdditionalTarget(spellName));
	return 1;
}

int PlayerFunctions::luaPlayerGetWheelSpellAdditionalDuration(lua_State* L) {
	// player:getWheelSpellAdditionalDuration(spellname)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	const auto spellName = getString(L, 2);
	if (spellName.empty()) {
		reportErrorFunc("Spell name is empty");
		pushBoolean(L, false);
		return 0;
	}

	const auto &spell = g_spells().getInstantSpellByName(spellName);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 0;
	}

	lua_pushnumber(L, player->wheel()->getSpellAdditionalDuration(spellName));
	return 1;
}

int PlayerFunctions::luaPlayerUpdateConcoction(lua_State* L) {
	// player:updateConcoction(itemid, timeLeft)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	player->updateConcoction(getNumber<uint16_t>(L, 2), getNumber<uint16_t>(L, 3));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerClearSpellCooldowns(lua_State* L) {
	// player:clearSpellCooldowns()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	player->clearCooldowns();
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerIsVip(lua_State* L) {
	// player:isVip()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	pushBoolean(L, player->isVip());
	return 1;
}

int PlayerFunctions::luaPlayerGetVipDays(lua_State* L) {
	// player:getVipDays()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, player->getPremiumDays());
	return 1;
}

int PlayerFunctions::luaPlayerGetVipTime(lua_State* L) {
	// player:getVipTime()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushinteger(L, player->getPremiumLastDay());
	return 1;
}

int PlayerFunctions::luaPlayerKV(lua_State* L) {
	// player:kv()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushUserdata<KV>(L, player->kv());
	setMetatable(L, -1, "KV");
	return 1;
}

int PlayerFunctions::luaPlayerGetStoreInbox(lua_State* L) {
	// player:getStoreInbox()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (const auto &item = player->getStoreInbox()) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int PlayerFunctions::luaPlayerHasAchievement(lua_State* L) {
	// player:hasAchievement(id or name)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	uint16_t achievementId = 0;
	if (isNumber(L, 2)) {
		achievementId = getNumber<uint16_t>(L, 2);
	} else {
		achievementId = g_game().getAchievementByName(getString(L, 2)).id;
	}

	pushBoolean(L, player->achiev()->isUnlocked(achievementId));
	return 1;
}

int PlayerFunctions::luaPlayerAddAchievement(lua_State* L) {
	// player:addAchievement(id or name[, sendMessage = true])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	uint16_t achievementId = 0;
	if (isNumber(L, 2)) {
		achievementId = getNumber<uint16_t>(L, 2);
	} else {
		achievementId = g_game().getAchievementByName(getString(L, 2)).id;
	}

	const bool success = player->achiev()->add(achievementId, getBoolean(L, 3, true));
	if (success) {
		player->sendTakeScreenshot(SCREENSHOT_TYPE_ACHIEVEMENT);
	}

	pushBoolean(L, success);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveAchievement(lua_State* L) {
	// player:removeAchievement(id or name)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	uint16_t achievementId = 0;
	if (isNumber(L, 2)) {
		achievementId = getNumber<uint16_t>(L, 2);
	} else {
		achievementId = g_game().getAchievementByName(getString(L, 2)).id;
	}

	pushBoolean(L, player->achiev()->remove(achievementId));
	return 1;
}

int PlayerFunctions::luaPlayerGetAchievementPoints(lua_State* L) {
	// player:getAchievementPoints()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	lua_pushnumber(L, player->achiev()->getPoints());
	return 1;
}

int PlayerFunctions::luaPlayerAddAchievementPoints(lua_State* L) {
	// player:addAchievementPoints(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto points = getNumber<uint16_t>(L, 2);
	if (points > 0) {
		player->achiev()->addPoints(points);
	}
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveAchievementPoints(lua_State* L) {
	// player:removeAchievementPoints(amount)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto points = getNumber<uint16_t>(L, 2);
	if (points > 0) {
		player->achiev()->removePoints(points);
	}
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddBadge(lua_State* L) {
	// player:addBadge(id)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->badge()->add(getNumber<uint8_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerAddTitle(lua_State* L) {
	// player:addTitle(id)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	player->title()->manage(true, getNumber<uint8_t>(L, 2, 0));
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerGetTitles(lua_State* L) {
	// player:getTitles()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto playerTitles = player->title()->getUnlockedTitles();
	lua_createtable(L, static_cast<int>(playerTitles.size()), 0);

	int index = 0;
	for (const auto &title : playerTitles) {
		lua_createtable(L, 0, 3);
		setField(L, "id", title.first.m_id);
		setField(L, "name", player->title()->getNameBySex(player->getSex(), title.first.m_maleName, title.first.m_femaleName));
		setField(L, "description", title.first.m_description);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PlayerFunctions::luaPlayerSetCurrentTitle(lua_State* L) {
	// player:setCurrentTitle(id)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &title = g_game().getTitleById(getNumber<uint8_t>(L, 2, 0));
	if (title.m_id == 0) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
		return 1;
	}

	player->title()->setCurrentTitle(title.m_id);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerCreateTransactionSummary(lua_State* L) {
	// player:createTransactionSummary(type, amount[, id = 0])
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto type = getNumber<uint8_t>(L, 2, 0);
	if (type == 0) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
		return 1;
	}

	const auto amount = getNumber<uint16_t>(L, 3, 1);
	const auto id = getString(L, 4, "");

	player->cyclopedia()->updateStoreSummary(type, amount, id);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerTakeScreenshot(lua_State* L) {
	// player:takeScreenshot(screenshotType)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto screenshotType = getNumber<Screenshot_t>(L, 2);
	player->sendTakeScreenshot(screenshotType);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendIconBakragore(lua_State* L) {
	// player:sendIconBakragore()
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto iconType = getNumber<IconBakragore>(L, 2);
	player->sendIconBakragore(iconType);
	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerRemoveIconBakragore(lua_State* L) {
	// player:removeIconBakragore(iconType or nil for remove all bakragore icons)
	const auto &player = getUserdataShared<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto iconType = getNumber<IconBakragore>(L, 2, IconBakragore::None);
	if (iconType == IconBakragore::None) {
		player->removeBakragoreIcons();
	} else {
		player->removeBakragoreIcon(iconType);
	}

	pushBoolean(L, true);
	return 1;
}

int PlayerFunctions::luaPlayerSendCreatureAppear(lua_State* L) {
	auto player = getUserdataShared<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	bool isLogin = getBoolean(L, 2, false);
	player->sendCreatureAppear(player, player->getPosition(), isLogin);
	pushBoolean(L, true);
	return 1;
}
