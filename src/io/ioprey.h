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

#ifndef SRC_IO_IOPREY_H_
#define SRC_IO_IOPREY_H_

#include "server/network/protocol/protocolgame.h"

enum PreySlot_t : uint8_t {
	PreySlot_One = 0,
	PreySlot_Two = 1,
	PreySlot_Three = 2,

	PreySlot_First = PreySlot_One,
	PreySlot_Last = PreySlot_Three
};

enum PreyDataState_t : uint8_t {
	PreyDataState_Locked = 0,
	PreyDataState_Inactive = 1,
	PreyDataState_Active = 2,
	PreyDataState_Selection = 3,
	PreyDataState_SelectionChangeMonster = 4,
	PreyDataState_ListSelection = 5,
	PreyDataState_WildcardSelection = 6
};

enum PreyBonus_t : uint8_t {
	PreyBonus_Damage = 0,
	PreyBonus_Defense = 1,
	PreyBonus_Experience = 2,
	PreyBonus_Loot = 3,
	PreyBonus_None = 4, // Do not send this to client

	PreyBonus_First = PreyBonus_Damage,
	PreyBonus_Last = PreyBonus_Loot
};

enum PreyOption_t : uint8_t {	
	PreyOption_None = 0,
	PreyOption_AutomaticReroll = 1,
	PreyOption_Locked = 2
};

enum PreyAction_t : uint8_t {
	PreyAction_ListReroll = 0,
	PreyAction_BonusReroll = 1,
	PreyAction_MonsterSelection = 2,
	PreyAction_ListAll_Cards = 3,
	PreyAction_ListAll_Selection = 4,
	PreyAction_Option = 5
};

enum PreyTaskDataState_t : uint8_t {
	PreyTaskDataState_Locked = 0,
	PreyTaskDataState_Inactive = 1,
	PreyTaskDataState_Selection = 2,
	PreyTaskDataState_ListSelection = 3,
	PreyTaskDataState_Active = 4,
	PreyTaskDataState_Completed = 5
};

enum PreyTaskAction_t : uint8_t {
	PreyTaskAction_ListReroll = 0,
	PreyTaskAction_RewardsReroll = 1,
	PreyTaskAction_ListAll_Cards = 2,
	PreyTaskAction_MonsterSelection = 3,
	PreyTaskAction_Cancel = 4,
	PreyTaskAction_Claim = 5
};

enum PreyTaskDifficult_t : uint8_t {
	PreyTaskDifficult_None = 0,
	PreyTaskDifficult_Easy = 1,
	PreyTaskDifficult_Medium = 2,
	PreyTaskDifficult_Hard = 3,

	PreyTaskDifficult_First = PreyTaskDifficult_Easy,
	PreyTaskDifficult_Last = PreyTaskDifficult_Hard
};

class NetworkMessage;

class PreySlot
{
 public:
	PreySlot() = default;
	explicit PreySlot(PreySlot_t id);
	virtual ~PreySlot() = default;

	bool isOccupied() const {
		return selectedRaceId != 0 && bonusTimeLeft > 0;
	}

	bool canSelect() const {
		return (state == PreyDataState_Selection || state == PreyDataState_SelectionChangeMonster || state == PreyDataState_ListSelection || state == PreyDataState_Inactive);
	}

	void eraseBonus(bool maintainBonus = false) {
		if (!maintainBonus) {
			bonus = PreyBonus_None;
			bonusPercentage = 5;
			bonusRarity = 1;
		}
		state = PreyDataState_Selection;
		option = PreyOption_None;
		selectedRaceId = 0;
		bonusTimeLeft = 0;
	}

	void removeMonsterType(uint16_t raceId) {
		raceIdList.erase(std::remove(raceIdList.begin(), raceIdList.end(), raceId), raceIdList.end());
	}

	void reloadBonusType();
	void reloadBonusValue();
	void reloadMonsterGrid(std::vector<uint16_t> blackList, uint32_t level);

	PreySlot_t id = PreySlot_First;
	PreyBonus_t bonus = PreyBonus_None;
	PreyDataState_t state = PreyDataState_Locked;
	PreyOption_t option = PreyOption_None;

	std::vector<uint16_t> raceIdList;

	uint8_t bonusRarity = 1;

	uint16_t selectedRaceId = 0;
	uint16_t bonusPercentage = 0;
	uint16_t bonusTimeLeft = 0;

	int64_t freeRerollTimeStamp = 0;
};

class TaskHuntingSlot
{
 public:
	TaskHuntingSlot() = default;
	explicit TaskHuntingSlot(PreySlot_t id);
	virtual ~TaskHuntingSlot() = default;

	bool isOccupied() const {
		return selectedRaceId != 0;
	}

	bool canSelect() const {
		return (state == PreyTaskDataState_Selection || state == PreyTaskDataState_ListSelection);
	}

	void eraseTask() {
		upgrade = false;
		state = PreyTaskDataState_Selection;
		selectedRaceId = 0;
		currentKills = 0;
		rarity = 1;
	}

	void removeMonsterType(uint16_t raceId) {
		raceIdList.erase(std::remove(raceIdList.begin(), raceIdList.end(), raceId), raceIdList.end());
	}

	bool isCreatureOnList(uint16_t raceId) const {
		auto it = std::find_if(raceIdList.begin(), raceIdList.end(), [raceId](uint16_t it) {
			return it == raceId;
		});

		return it != raceIdList.end();
	}

	void reloadReward();
	void reloadMonsterGrid(std::vector<uint16_t> blackList, uint32_t level);

	PreySlot_t id = PreySlot_First;
	PreyTaskDataState_t state = PreyTaskDataState_Inactive;

	bool upgrade = false;

	uint8_t rarity = 1;

	uint16_t selectedRaceId = 0;
	uint16_t currentKills = 0;

	int64_t disabledUntilTimeStamp = 0;
	int64_t freeRerollTimeStamp = 0;

	std::vector<uint16_t> raceIdList;
};

class TaskHuntingOption
{
 public:
	TaskHuntingOption() = default;
	virtual ~TaskHuntingOption() = default;

	PreyTaskDifficult_t difficult = PreyTaskDifficult_None;
	uint8_t rarity = 1;

	uint16_t firstKills = 0;
	uint16_t secondKills = 0;

	uint16_t firstReward = 0;
	uint16_t secondReward = 0;
};

class IOPrey
{
public:
	IOPrey() = default;

	// non-copyable
	IOPrey(IOPrey const&) = delete;
	void operator=(IOPrey const&) = delete;

	static IOPrey& getInstance() {
		// Guaranteed to be destroyed
		static IOPrey instance;
		// Instantiated on first use
		return instance;
	}

	void CheckPlayerPreys(Player* player, uint8_t amount) const;
	void ParsePreyAction(Player* player, PreySlot_t slotId, PreyAction_t action, PreyOption_t option, int8_t index, uint16_t raceId) const;

	void ParseTaskHuntingAction(Player* player, PreySlot_t slotId, PreyTaskAction_t action, bool upgrade, uint16_t raceId) const;

	void InitializeTaskHuntOptions();
	TaskHuntingOption* GetTaskRewardOption(const TaskHuntingSlot* slot) const;

	std::vector<TaskHuntingOption*> GetTaskOptions() const {
		return taskOption;
	}

	NetworkMessage GetTaskHuntingBaseDate() const {
		return baseDataMessage;
	}

	NetworkMessage baseDataMessage;
	std::vector<TaskHuntingOption*> taskOption;
};

constexpr auto g_ioprey = &IOPrey::getInstance;

#endif  // SRC_IO_IOPREY_H_
