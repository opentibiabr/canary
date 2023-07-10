/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/functions/iologindata_load_player.hpp"

void IOLoginDataLoad::loadPlayerForgeHistory(Player* player, DBResult_ptr result) {
	std::ostringstream query;
	query << "SELECT * FROM `forge_history` WHERE `player_id` = " << player->getGUID();
	if (result = Database::getInstance().storeQuery(query.str())) {
		do {
			auto actionEnum = magic_enum::enum_value<ForgeConversion_t>(result->getNumber<uint16_t>("action_type"));
			ForgeHistory history;
			history.actionType = actionEnum;
			history.description = result->getString("description");
			history.createdAt = result->getNumber<time_t>("done_at");
			history.success = result->getNumber<bool>("is_success");
			player->setForgeHistory(history);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadRewardItems(Player* player) {
	ItemMap itemMap;
	std::ostringstream query;
	query.str(std::string());
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_rewards` WHERE `player_id` = "
		  << player->getGUID() << " ORDER BY `pid`, `sid` ASC";
	if (auto result = Database::getInstance().storeQuery(query.str())) {
		IOLoginData::loadItems(itemMap, result, *player);
		bindRewardBag(player, itemMap);
		insertItemsIntoRewardBag(itemMap);
	}
}

void IOLoginDataLoad::bindRewardBag(Player* player, IOLoginData::ItemMap &itemMap) {
	for (auto &[id, itemPair] : itemMap) {
		const auto [item, pid] = itemPair;
		if (pid == 0) {
			auto reward = player->getReward(item->getAttribute<uint64_t>(ItemAttribute_t::DATE), true);
			if (reward) {
				itemPair = std::pair<Item*, int32_t>(reward->getItem(), player->getRewardChest()->getID());
			}
		} else {
			break;
		}
	}
}

void IOLoginDataLoad::insertItemsIntoRewardBag(const IOLoginData::ItemMap &itemMap) {
	for (const auto &it : std::views::reverse(itemMap)) {
		const std::pair<Item*, int32_t> &pair = it.second;
		Item* item = pair.first;
		int32_t pid = pair.second;
		if (pid == 0) {
			break;
		}

		ItemMap::const_iterator it2 = itemMap.find(pid);
		if (it2 == itemMap.end()) {
			continue;
		}

		Container* container = it2->second.first->getContainer();
		if (container) {
			container->internalAddThing(item);
		}
	}
}

void IOLoginDataLoad::loadPlayerBosstiary(Player* player, DBResult_ptr result) {
	std::ostringstream query;
	query << "SELECT * FROM `player_bosstiary` WHERE `player_id` = " << player->getGUID();
	if (result = Database::getInstance().storeQuery(query.str())) {
		do {
			player->setSlotBossId(1, result->getNumber<uint16_t>("bossIdSlotOne"));
			player->setSlotBossId(2, result->getNumber<uint16_t>("bossIdSlotTwo"));
			player->setRemoveBossTime(result->getU8FromString(result->getString("removeTimes"), __FUNCTION__));
		} while (result->next());
	}
}
