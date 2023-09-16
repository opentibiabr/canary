/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "io/iologindata.hpp"

class IOLoginDataLoad : public IOLoginData {
public:
	static bool loadPlayerFirst(Player* player, DBResult_ptr result);
	static bool preLoadPlayer(Player* player, const std::string &name);
	static void loadPlayerExperience(Player* player, DBResult_ptr result);
	static void loadPlayerBlessings(Player* player, DBResult_ptr result);
	static void loadPlayerConditions(Player* player, DBResult_ptr result);
	static void loadPlayerDefaultOutfit(Player* player, DBResult_ptr result);
	static void loadPlayerSkullSystem(Player* player, DBResult_ptr result);
	static void loadPlayerSkill(Player* player, DBResult_ptr result);
	static void loadPlayerKills(Player* player, DBResult_ptr result);
	static void loadPlayerGuild(Player* player, DBResult_ptr result);
	static void loadPlayerStashItems(Player* player, DBResult_ptr result);
	static void loadPlayerBestiaryCharms(Player* player, DBResult_ptr result);
	static void loadPlayerInstantSpellList(Player* player, DBResult_ptr result);
	static void loadPlayerInventoryItems(Player* player, DBResult_ptr result);
	static void loadPlayerStoreInbox(Player* player);
	static void loadPlayerDepotItems(Player* player, DBResult_ptr result);
	static void loadRewardItems(Player* player);
	static void loadPlayerInboxItems(Player* player, DBResult_ptr result);
	static void loadPlayerStorageMap(Player* player, DBResult_ptr result);
	static void loadPlayerVip(Player* player, DBResult_ptr result);
	static void loadPlayerPreyClass(Player* player, DBResult_ptr result);
	static void loadPlayerTaskHuntingClass(Player* player, DBResult_ptr result);
	static void loadPlayerForgeHistory(Player* player, DBResult_ptr result);
	static void loadPlayerBosstiary(Player* player, DBResult_ptr result);
	static void loadPlayerInitializeSystem(Player* player);
	static void loadPlayerUpdateSystem(Player* player);

private:
	using ItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;

	static void bindRewardBag(Player* player, ItemsMap &rewardItemsMap);
	static void insertItemsIntoRewardBag(const ItemsMap &rewardItemsMap);

	static void loadItems(ItemsMap &itemsMap, DBResult_ptr result, Player &player);
};
