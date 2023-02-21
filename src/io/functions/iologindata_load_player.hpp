/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_
#define SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_

#include "io/iologindata.h"

class IOLoginDataLoad : public IOLoginData {
	public:
		static bool preLoadPlayer(Player* player, const std::string &name);
		static bool loadPlayerFirst(Player* player, DBResult_ptr result);
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
		static void loadPlayerInventoryItems(Player* player, DBResult_ptr result);
		static void loadPlayerStoreInbox(Player* player, DBResult_ptr result);
		static void loadPlayerDepotItems(Player* player, DBResult_ptr result);
		static void loadRewardItems(Player* player);
		static void loadPlayerInboxItems(Player* player, DBResult_ptr result);
		static void loadPlayerStorageMap(Player* player, DBResult_ptr result);
		static void loadPlayerVip(Player* player, DBResult_ptr result);
		static void loadPlayerPreyClass(Player* player, DBResult_ptr result);
		static void loadPlayerTaskHuntingClass(Player* player, DBResult_ptr result);
		static void loadPlayerForgeHistory(Player* player, DBResult_ptr result);
		static void loadPlayerBosstiary(Player* player, DBResult_ptr result);
		static void loadPlayerInitializeSystem(Player* player, DBResult_ptr result);
		static void loadPlayerUpdateSystem(Player* player, DBResult_ptr result);

	private:
		static void bindRewardBag(Player* player, ItemMap &itemMap);
		static void insertItemsIntoRewardBag(const ItemMap &itemMap);

		using InventoryItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		using RewardItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		using DepotItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		using InboxItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;

		template <typename T>
		static void loadItemsBeats(T &container, DBResult_ptr result, Player &player) {
			do {
				uint32_t sid = result->getNumber<uint32_t>("sid");
				uint32_t pid = result->getNumber<uint32_t>("pid");
				uint16_t type = result->getNumber<uint16_t>("itemtype");
				uint16_t count = result->getNumber<uint16_t>("count");
				unsigned long attrSize;
				const char* attr = result->getStream("attributes", attrSize);
				PropStream propStream;
				propStream.init(attr, attrSize);
				Item* item = Item::CreateItem(type, count);
				if (item) {
					if (!item->unserializeAttr(propStream)) {
						SPDLOG_WARN("[IOLoginData::loadItems] - Failed to unserialize attributes of item {}, of player {}, from account id {}", item->getID(), player.getName(), player.getAccount());
        				savePlayer(&player);
					}
					std::pair<Item*, uint32_t> pair(item, pid);
					container[sid] = pair;
				}
			} while (result->next());
		}
};

#endif // SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_
