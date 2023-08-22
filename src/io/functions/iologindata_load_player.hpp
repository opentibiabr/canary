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
		static bool loadPlayerFirst(Player* player, DBResult_ptr result);
		static bool preLoadPlayer(Player* player, const std::string &name);
		static void loadPlayerExperience(Player* player, DBResult_ptr result);
		static void loadPlayerBlessings(Player* player, DBResult_ptr result);
		static void loadPlayerConditions(const Player* player, DBResult_ptr result);
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
		using InventoryItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		using RewardItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		using DepotItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		using InboxItemsMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;

		static void bindRewardBag(Player* player, RewardItemsMap &rewardItemsMap);
		static void insertItemsIntoRewardBag(const RewardItemsMap &rewardItemsMap);

		template <typename T>
		static void loadItems(T &container, DBResult_ptr result, Player &player) {
			try {
				do {
					uint32_t sid = result->getNumber<uint32_t>("sid");
					uint32_t pid = result->getNumber<uint32_t>("pid");
					uint16_t type = result->getNumber<uint16_t>("itemtype");
					uint16_t count = result->getNumber<uint16_t>("count");
					unsigned long attrSize;
					const char* attr = result->getStream("attributes", attrSize);
					PropStream propStream;
					propStream.init(attr, attrSize);

					try {
						Item* item = Item::CreateItem(type, count);
						if (item) {
							if (!item->unserializeAttr(propStream)) {
								g_logger().warn("[IOLoginData::loadItems] - Falha ao desserializar os atributos do item {}, do jogador {}, da conta id {}", item->getID(), player.getName(), player.getAccount());
								savePlayer(&player);
								g_logger().info("[IOLoginData::loadItems] - Deletando item defeituoso: {}", item->getID());
								delete item; // Delete o item defeituoso
								continue;
							}
							std::pair<Item*, uint32_t> pair(item, pid);
							container[sid] = pair;
						} else {
							g_logger().warn("[IOLoginData::loadItems] - Falha ao criar o item do tipo {} para o jogador {}, da conta id {}", type, player.getName(), player.getAccount());
						}
					} catch (const std::exception &e) {
						g_logger().warn("[IOLoginData::loadItems] - Exceção durante a criação ou desserialização do item: {}", e.what());
						continue;
					}
				} while (result->next());
			} catch (const std::exception &e) {
				g_logger().error("[IOLoginData::loadItems] - Exceção geral durante o carregamento do item: {}", e.what());
			}
		}
};

#endif // SRC_IO_FUNCTIONS_IOLOGINDATALOAD_HPP_
