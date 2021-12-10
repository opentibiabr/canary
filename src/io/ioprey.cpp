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

#include "otpch.h"

#include "declarations.hpp"
#include "creatures/monsters/monster.h"
#include "creatures/players/player.h"
#include "config/configmanager.h"
#include "game/game.h"
#include "io/ioprey.h"

extern Game g_game;
extern Monsters g_monsters;
extern ConfigManager g_config;
extern IOPrey g_prey;

// Prey class
PreySlot::PreySlot(PreySlot_t id) :
									id(id) {
		eraseBonus();
		reloadBonusValue();
		reloadBonusType();
}

void PreySlot::reloadBonusType()
{
	if (bonusRarity == 10) {
		PreyBonus_t bonus_tmp = bonus;
		while (bonus_tmp == bonus) {
			bonus = static_cast<PreyBonus_t>(normal_random(PreyBonus_First, PreyBonus_Last));
		}
		return;
	}

	bonus = static_cast<PreyBonus_t>(normal_random(PreyBonus_First, PreyBonus_Last));
}

void PreySlot::reloadBonusValue()
{
	uint16_t minBonusPercent = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_PERCENT_MIN));
	uint16_t maxBonusPercent = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_PERCENT_MAX));
	uint16_t stagePercent = std::floor((maxBonusPercent - minBonusPercent) / 8);
	if (bonusRarity >= 9) {
		bonusRarity = 10;
	} else {
		bonusRarity = normal_random(bonusRarity + 1, 10);
	}

	bonusPercentage = stagePercent * bonusRarity;
	if (bonusPercentage > maxBonusPercent) {
		bonusPercentage = maxBonusPercent;
	} else if (bonusPercentage < minBonusPercent) {
		bonusPercentage = minBonusPercent;
	}
}

void PreySlot::reloadMonsterGrid(std::vector<uint16_t> blackList, uint32_t level)
{
	raceIdList.clear();

	if (!g_config.getBoolean(PREY_ENABLED)) {
		return;
	}

	// Disabling prey system if the server have less then 36 registered monsters on bestiary because:
	// - Impossible to generate random lists without duplications on slots.
	// - Stress the server with unnecessary loops.
	std::map<uint16_t, std::string> bestiary = g_game.getBestiaryList();
	if (bestiary.size() < 36) {
		return;
	}

	uint8_t stageOne, stageTwo, stageThree, stageFour;
	uint32_t levelStage = std::floor(level / 100);
	if (levelStage == 0) { // From level 0 to 99
		stageOne = 3;
		stageTwo = 3;
		stageThree = 2;
		stageFour = 1;
	} else if (levelStage <= 2) { // From level 100 to 299
		stageOne = 1;
		stageTwo = 3;
		stageThree = 3;
		stageFour = 2;
	} else if (levelStage <= 4) { // From level 300 to 499
		stageOne = 1;
		stageTwo = 2;
		stageThree = 3;
		stageFour = 3;
	} else { // From level 500 to ...
		stageOne = 1;
		stageTwo = 1;
		stageThree = 3;
		stageFour = 4;
	}

	uint8_t tries = 0;
	size_t maxIndex = bestiary.size() - 1;
	while (raceIdList.size() < 9) {
		uint16_t raceId = (*(std::next(bestiary.begin(), normal_random(0, maxIndex)))).first;
		tries++;

		if (std::count(blackList.begin(), blackList.end(), raceId) != 0) {
			continue;
		}

		blackList.push_back(raceId);
		MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(raceId);
		if (!mtype || mtype->info.experience == 0) {
			continue;
		} else if (stageOne != 0 && mtype->info.bestiaryStars <= 1) {
			raceIdList.push_back(raceId);
			--stageOne;
		} else if (stageTwo != 0 && mtype->info.bestiaryStars == 2) {
			raceIdList.push_back(raceId);
			--stageTwo;
		} else if (stageThree != 0 && mtype->info.bestiaryStars == 3) {
			raceIdList.push_back(raceId);
			--stageThree;
		} else if (stageFour != 0 && mtype->info.bestiaryStars >= 4) {
			raceIdList.push_back(raceId);
			--stageFour;
		} else if (tries >= 10) {
			raceIdList.push_back(raceId);
			tries = 0;
		}
	}
}

// Task hunting class
TaskHuntingSlot::TaskHuntingSlot(PreySlot_t id) :
												id(id) {
	upgrade = false;
	state = PreyTaskDataState_Selection;
	selectedRaceId = 0;
	currentKills = 0;
	rarity = 1;
}

void TaskHuntingSlot::reloadMonsterGrid(std::vector<uint16_t> blackList, uint32_t level)
{
	raceIdList.clear();

	if (!g_config.getBoolean(TASK_HUNTING_ENABLED)) {
		return;
	}

	// Disabling task hunting system if the server have less then 36 registered monsters on bestiary because:
	// - Impossible to generate random lists without duplications on slots.
	// - Stress the server with unnecessary loops.
	std::map<uint16_t, std::string> bestiary = g_game.getBestiaryList();
	if (bestiary.size() < 36) {
		return;
	}

	uint8_t stageOne, stageTwo, stageThree, stageFour;
	uint32_t levelStage = std::floor(level / 100);
	if (levelStage == 0) { // From level 0 to 99
		stageOne = 3;
		stageTwo = 3;
		stageThree = 2;
		stageFour = 1;
	} else if (levelStage <= 2) { // From level 100 to 299
		stageOne = 1;
		stageTwo = 3;
		stageThree = 3;
		stageFour = 2;
	} else if (levelStage <= 4) { // From level 300 to 499
		stageOne = 1;
		stageTwo = 2;
		stageThree = 3;
		stageFour = 3;
	} else { // From level 500 to ...
		stageOne = 1;
		stageTwo = 1;
		stageThree = 3;
		stageFour = 4;
	}

	uint8_t tries = 0;
	size_t maxIndex = bestiary.size() - 1;
	while (raceIdList.size() < 9) {
		uint16_t raceId = (*(std::next(bestiary.begin(), normal_random(0, maxIndex)))).first;
		tries++;

		if (std::count(blackList.begin(), blackList.end(), raceId) != 0) {
			continue;
		}

		blackList.push_back(raceId);
		MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(raceId);
		if (!mtype || mtype->info.experience == 0) {
			continue;
		} else if (stageOne != 0 && mtype->info.bestiaryStars <= 1) {
			raceIdList.push_back(raceId);
			--stageOne;
		} else if (stageTwo != 0 && mtype->info.bestiaryStars == 2) {
			raceIdList.push_back(raceId);
			--stageTwo;
		} else if (stageThree != 0 && mtype->info.bestiaryStars == 3) {
			raceIdList.push_back(raceId);
			--stageThree;
		} else if (stageFour != 0 && mtype->info.bestiaryStars >= 4) {
			raceIdList.push_back(raceId);
			--stageFour;
		} else if (tries >= 10) {
			raceIdList.push_back(raceId);
			tries = 0;
		}
	}
}

void TaskHuntingSlot::reloadReward()
{
	if (!g_config.getBoolean(TASK_HUNTING_ENABLED)) {
		return;
	}

	if (rarity >= 4) {
		rarity = 5;
		return;
	}

	uint8_t chance;
	if (rarity == 0) {
		chance = normal_random(0, 100);
	} else if (rarity == 1) {
		chance = normal_random(0, 70);
	} else if (rarity == 2) {
		chance = normal_random(0, 45);
	} else if (rarity == 3) {
		chance = normal_random(0, 20);
	} else {
		return;
	}

	if (chance <= 5) {
		rarity = 5;
	} else if (chance <= 20) {
		rarity = 4;
	} else if (chance <= 45) {
		rarity = 3;
	} else if (chance <= 70) {
		rarity = 2;
	} else {
		rarity = 1;
	}
}

// Prey/Task hunting global class
bool IOPrey::CheckPlayerPreys(Player* player)
{
	if (!player) {
		return false;
	}

	uint8_t activeSlots = 0;
	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		PreySlot* slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
		if (slot && slot->isOccupied()) {
			activeSlots++;
			if ((EVENT_PREYINTERVAL / 1000) >= slot->bonusTimeLeft) {
				if (slot->option == PreyOption_AutomaticReroll) {
					if (player->usePreyCards(static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_REROLL_PRICE)))) {
						slot->reloadBonusValue();
						slot->reloadBonusType();
						slot->bonusTimeLeft = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_TIME));
						player->sendTextMessage(MESSAGE_STATUS, "Your prey bonus type and time has been succesfully reseted.");
						player->reloadPreySlot(static_cast<PreySlot_t>(slotId));
						continue;
					}

					player->sendTextMessage(MESSAGE_STATUS, "You don't have enought prey cards to enable automatic reroll when your slot expire.");
				} else if (slot->option == PreyOption_Locked) {
					if (player->usePreyCards(static_cast<uint16_t>(g_config.getNumber(PREY_SELECTION_LIST_PRICE)))) {
						slot->bonusTimeLeft = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_TIME));
						player->sendTextMessage(MESSAGE_STATUS, "Your prey bonus time has been succesfully reseted.");
						player->reloadPreySlot(static_cast<PreySlot_t>(slotId));
						continue;
					}

					player->sendTextMessage(MESSAGE_STATUS, "You don't have enought prey cards to lock monster and bonus when the slot expire.");
				} else {
					player->sendTextMessage(MESSAGE_STATUS, "Your prey bonus has expired.");
				}

				--activeSlots;
				slot->eraseBonus();
				player->reloadPreySlot(static_cast<PreySlot_t>(slotId));
			} else {
				slot->bonusTimeLeft -= EVENT_PREYINTERVAL / 1000;
				player->sendPreyTimeLeft(slot);
			}
		}
	}

	return activeSlots != 0;
}

void IOPrey::ParsePreyAction(Player* player, PreySlot_t slotId, PreyAction_t action, PreyOption_t option, int8_t index, uint16_t raceId)
{
	if (!player) {
		return;
	}

	PreySlot* slot = player->getPreySlotById(slotId);
	if (!slot) {
		return;
	}

	if (slot->state == PreyDataState_Locked) {
		player->sendMessageDialog("To unlock this prey slot first you must buy it on store.");
		return;
	}

	if (action == PreyAction_ListReroll) {
		if (slot->freeRerollTimeStamp > OTSYS_TIME() && !g_game.removeMoney(player, player->getPreyRerollPrice(), 0, true)) {
			player->sendMessageDialog("You don't have enought money to reroll the prey slot.");
			return;
		} else if (slot->freeRerollTimeStamp <= OTSYS_TIME()) {
			slot->freeRerollTimeStamp = static_cast<int64_t>(OTSYS_TIME() + g_config.getNumber(PREY_FREE_REROLL_TIME) * 1000);
		}

		slot->eraseBonus();
		slot->state = PreyDataState_Selection;
		slot->reloadMonsterGrid(player->getPreyBlackList(), player->getLevel());
	} else if (action == PreyAction_ListAll_Cards) {
		if (!player->usePreyCards(static_cast<uint16_t>(g_config.getNumber(PREY_SELECTION_LIST_PRICE)))) {
			player->sendMessageDialog("You don't have enought prey cards to choose a monsters on the list.");
			return;
		}

		slot->bonusTimeLeft = 0;
		slot->selectedRaceId = 0;
		slot->state = PreyDataState_ListSelection;
	} else if (action == PreyAction_ListAll_Selection) {
		if (slot->isOccupied()) {
			player->sendMessageDialog("You already have an active monster on this prey slot.");
			return;
		} else if (!slot->canSelect() || slot->state != PreyDataState_ListSelection) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the prey window.");
			return;
		} else if (player->getPreyWithMonster(raceId)) {
			player->sendMessageDialog("This creature is already selected on another slot.");
			return;
		}

		slot->state = PreyDataState_Active;
		slot->selectedRaceId = raceId;
		slot->removeMonsterType(raceId);
		slot->bonusTimeLeft = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_TIME));
		g_game.initializePreyCounter(player->getGUID());
	} else if (action == PreyAction_BonusReroll) {
		if (!slot->isOccupied()) {
			player->sendMessageDialog("You don't have any active monster on this prey slot.");
			return;
		} else if (!player->usePreyCards(static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_REROLL_PRICE)))) {
			player->sendMessageDialog("You don't have enought prey cards to reroll this prey slot bonus type.");
			return;
		}

		slot->reloadBonusValue();
		slot->reloadBonusType();
		slot->bonusTimeLeft = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_TIME));
	} else if (action == PreyAction_MonsterSelection) {
		if (slot->isOccupied()) {
			player->sendMessageDialog("You already have an active monster on this prey slot.");
			return;
		} else if (!slot->canSelect() || index == -1 || (index + 1) > slot->raceIdList.size()) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the prey window.");
			return;
		} else if (player->getPreyWithMonster(slot->raceIdList[index])) {
			player->sendMessageDialog("This creature is already selected on another slot.");
			return;
		}

		slot->reloadBonusValue();
		slot->reloadBonusType();
		slot->state = PreyDataState_Active;
		slot->selectedRaceId = slot->raceIdList[index];
		slot->removeMonsterType(slot->selectedRaceId);
		slot->bonusTimeLeft = static_cast<uint16_t>(g_config.getNumber(PREY_BONUS_TIME));
		g_game.initializePreyCounter(player->getGUID());
	} else if (action == PreyAction_Option) {
		if (option == PreyOption_AutomaticReroll && player->getPreyCards() < static_cast<uint64_t>(g_config.getNumber(PREY_BONUS_REROLL_PRICE))) {
			player->sendMessageDialog("You don't have enought prey cards to enable automatic reroll when your slot expire.");
			return;
		} else if (option == PreyOption_Locked && player->getPreyCards() < static_cast<uint64_t>(g_config.getNumber(PREY_SELECTION_LIST_PRICE))) {
				player->sendMessageDialog("You don't have enought prey cards to lock monster and bonus when the slot expire.");
				return;
		}

		slot->option = option;
	} else {
		SPDLOG_WARN("[IOPrey::ParsePreyAction] - Unknown prey action: {}", action);
		return;
	}

	player->reloadPreySlot(slotId);
}

void IOPrey::ParseTaskHuntingAction(Player* player, PreySlot_t slotId, PreyTaskAction_t action, bool upgrade, uint16_t raceId)
{
	if (!player) {
		return;
	}

	TaskHuntingSlot* slot = player->getTaskHuntingSlotById(slotId);
	if (!slot) {
		return;
	}

	if (slot->state == PreyTaskDataState_Locked) {
		player->sendMessageDialog("To unlock this task hunting slot first you must buy it on store.");
		return;
	}

	if (action == PreyTaskAction_ListReroll) {
		if (slot->disabledUntilTimeStamp >= OTSYS_TIME()) {
			player->sendMessageDialog("You need to wait to select a new creature on task.");
			return;
		} else if (slot->freeRerollTimeStamp > OTSYS_TIME() && !g_game.removeMoney(player, player->getTaskHuntingRerollPrice(), 0, true)) {
			player->sendMessageDialog("You don't have enought money to reroll the task hunting slot.");
			return;
		} else if (slot->freeRerollTimeStamp <= OTSYS_TIME()) {
			slot->freeRerollTimeStamp = static_cast<int64_t>(OTSYS_TIME() + g_config.getNumber(TASK_HUNTING_FREE_REROLL_TIME) * 1000);
		}

		slot->eraseTask();
		slot->reloadReward();
		slot->state = PreyTaskDataState_Selection;
		slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
	} else if (action == PreyTaskAction_RewardsReroll) {
		if (!player->usePreyCards(static_cast<uint16_t>(g_config.getNumber(TASK_HUNTING_BONUS_REROLL_PRICE)))) {
			player->sendMessageDialog("You don't have enought prey cards to reroll you task reward rarity.");
			return;
		}

		slot->reloadReward();
	} else if (action == PreyTaskAction_ListAll_Cards) {
		if (slot->disabledUntilTimeStamp >= OTSYS_TIME()) {
			player->sendMessageDialog("You need to wait to select a new creature on task.");
			return;
		} else if (!player->usePreyCards(static_cast<uint16_t>(g_config.getNumber(TASK_HUNTING_SELECTION_LIST_PRICE)))) {
			player->sendMessageDialog("You don't have enought prey cards to choose a creature on list for you task hunting slot.");
			return;
		}

		slot->selectedRaceId = 0;
		slot->state = PreyTaskDataState_ListSelection;
	} else if (action == PreyTaskAction_MonsterSelection) {
		if (slot->disabledUntilTimeStamp >= OTSYS_TIME()) {
			player->sendMessageDialog("You need to wait to select a new creature on task.");
			return;
		} else if (!slot->canSelect()) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the task window.");
			return;
		} else if (slot->isOccupied()) {
			player->sendMessageDialog("You already have an active monster on this task hunting slot.");
			return;
		} else if (slot->state == PreyTaskDataState_Selection && !slot->isCreatureOnList(raceId)) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the task window.");
			return;
		} else if (player->getTaskHuntingWithCreature(raceId)) {
			player->sendMessageDialog("This creature is already selected on another slot.");
			return;
		}

		MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(raceId);
		if (!mtype) {
			return;
		}

		slot->currentKills = 0;
		slot->selectedRaceId = raceId;
		slot->removeMonsterType(raceId);
		slot->state = PreyTaskDataState_Active;
		slot->upgrade = upgrade && player->isCreatureUnlockedOnTaskHunting(mtype);
	} else if (action == PreyTaskAction_Cancel) {
		if (!g_game.removeMoney(player, player->getTaskHuntingCancelPrice(), 0, true)) {
			player->sendMessageDialog("You don't have enought money to cancel your current task hunting.");
			return;
		}

		slot->eraseTask();
		slot->reloadReward();
		slot->state = PreyTaskDataState_Selection;
	} else if (action == PreyTaskAction_Claim) {
		if (!slot->isOccupied()) {
			player->sendMessageDialog("You cannot claim your task reward with an empty task hunting slot.");
			return;
		}

		TaskHuntingOption* option = GetTaskRewardOption(slot);
		if (!option) {
			player->sendMessageDialog("There was an error while processing you task hunting reward. Please try reopening the window.");
			return;
		}

		uint16_t reward;
		uint8_t boostChange = normal_random(0, 100);
		if (slot->rarity >= 4 && boostChange <= 5) {
			boostChange = 20;
		} else if (slot->rarity >= 4 && boostChange <= 10) {
			boostChange = 15;
		} else {
			boostChange = 10;
		}

		if (slot->upgrade && slot->currentKills >= option->secondKills) {
			reward = option->secondReward;
		} else if (!slot->upgrade && slot->currentKills >= option->firstKills) {
			reward = option->firstReward;
		} else {
			player->sendMessageDialog("There was an error while processing you task hunting reward. Please try reopening the window.");
			return;
		}

		std::ostringstream ss;
		reward = std::ceil((reward * boostChange) / 10);
		ss << "You succesfully claimed your hunting task and received " << reward;
		if (boostChange == 20) {
			ss << " hunting task points including a 100% bonus!!";
		} else if (boostChange == 15) {
			ss << " hunting task points including a 50% bonus!";
		} else {
			ss << " hunting task points with no bonus.";
		}

		slot->eraseTask();
		slot->reloadReward();
		slot->state = PreyTaskDataState_Selection;
		player->addTaskHuntingPoints(reward);
		player->sendTextMessage(MESSAGE_STATUS, ss.str());
		slot->disabledUntilTimeStamp = static_cast<int64_t>(OTSYS_TIME() + g_config.getNumber(TASK_HUNTING_LIMIT_EXHAUST) * 1000);
	} else {
		SPDLOG_WARN("[IOPrey::ParseTaskHuntingAction] - Unknown task action: {}", action);
		return;
	}

	player->reloadTaskSlot(slotId);
}

void IOPrey::InitializeTaskHuntOptions()
{
	if (!g_config.getBoolean(TASK_HUNTING_ENABLED)) {
		return;
	}

	// Move it to config.lua
	uint8_t killStage = 25;											// Kill stage is the multiplier for kills and rewards on task hunting.

	uint8_t limitOfStars = 5;										// This is hardcoded on client but i'm saving it in case that they change it in the future.
	uint16_t kills = killStage;
	for (uint8_t difficulty = PreyTaskDifficult_First; difficulty <= PreyTaskDifficult_Last; ++difficulty) {	// Difficulties of creatures on bestiary.
		uint16_t reward = std::round((10 * kills) / killStage);
		for (uint8_t star = 1; star <= limitOfStars; ++star) { 		// Amount of task stars on task hunting.
			TaskHuntingOption* option = new TaskHuntingOption();
			option->difficult = static_cast<PreyTaskDifficult_t>(difficulty);
			option->rarity = star;

			option->firstKills = kills;
			option->firstReward = reward;

			option->secondKills = kills * 2;
			option->secondReward = reward * 2;

			taskOption.push_back(option);

			reward = std::round((reward * (115 + (difficulty * limitOfStars))) / 100);
		}

		kills *= 4;
	}

	baseDataMessage.addByte(0xBA);
	std::map<uint16_t, std::string> bestiaryList = g_game.getBestiaryList();
	baseDataMessage.add<uint16_t>(bestiaryList.size());
	for (auto it = bestiaryList.begin(); it != bestiaryList.end(); ++it) {
		MonsterType* mtype = g_monsters.getMonsterType((*it).second);
		if (!mtype) {
			return;
		}

		baseDataMessage.add<uint16_t>(mtype->info.raceid);
		if (mtype->info.bestiaryStars <= 1) {
			baseDataMessage.addByte(0x01);
		} else if (mtype->info.bestiaryStars <= 3) {
			baseDataMessage.addByte(0x02);
		} else {
			baseDataMessage.addByte(0x03);
		}
	}

	baseDataMessage.addByte(taskOption.size());
	for (auto it = taskOption.begin(); it != taskOption.end(); ++it) {
		TaskHuntingOption* option = *it;
		if (!option) {
			return;
		}

		baseDataMessage.addByte(static_cast<uint8_t>(option->difficult));
		baseDataMessage.addByte(option->rarity);
		baseDataMessage.add<uint16_t>(option->firstKills);
		baseDataMessage.add<uint16_t>(option->firstReward);
		baseDataMessage.add<uint16_t>(option->secondKills);
		baseDataMessage.add<uint16_t>(option->secondReward);
	}
}

TaskHuntingOption* IOPrey::GetTaskRewardOption(TaskHuntingSlot* slot)
{
	if (!slot) {
		return nullptr;
	}

	MonsterType* mtype = g_monsters.getMonsterTypeByRaceId(slot->selectedRaceId);
	if (!mtype) {
		return nullptr;
	}

	PreyTaskDifficult_t difficult;
	if (mtype->info.bestiaryStars <= 1) {
		difficult = PreyTaskDifficult_Easy;
	} else if (mtype->info.bestiaryStars <= 3) {
		difficult = PreyTaskDifficult_Medium;
	} else {
		difficult = PreyTaskDifficult_Hard;
	}

	auto it = std::find_if(taskOption.begin(), taskOption.end(), [difficult, slot](TaskHuntingOption* it) {
		return it->difficult == difficult && it->rarity == slot->rarity;
	});

	if (it != taskOption.end()) {
		return *it;
	}

	return nullptr;
}
