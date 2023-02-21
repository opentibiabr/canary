/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_IO__FUNCTIONS_IOLOGINDATASAVE_HPP_
#define SRC_IO__FUNCTIONS_IOLOGINDATASAVE_HPP_

#include "io/iologindata.h"

class IOLoginDataSave : public IOLoginData {
	public:
		static bool savePlayerFirst(Player* player);
		static bool savePlayerStash(Player* player);
		static bool savePlayerSpells(Player* player);
		static bool savePlayerKills(Player* player);
		static bool savePlayerBestiarySystem(Player* player);
		static bool savePlayerItem(Player* player);
		static bool savePlayerDepotItems(Player* player);
		static bool saveRewardItems(Player* player);
		static bool savePlayerInbox(Player* player);
		static bool savePlayerPreyClass(Player* player);
		static bool savePlayerTaskHuntingClass(Player* player);
		static bool savePlayerForgeHistory(Player* player);
		static bool savePlayerBosstiary(const Player* player);
		static bool savePlayerStorage(Player* palyer);

	protected:
		using ItemBlockList = std::list<std::pair<int32_t, Item*>>;
		using ItemDepotList = std::list<std::pair<int32_t, Item*>>;
		using ItemRewardList = std::list<std::pair<int32_t, Item*>>;
		using ItemInboxList = std::list<std::pair<int32_t, Item*>>;

		static bool saveItems(const Player* player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &stream);
};

#endif // SRC_IO__FUNCTIONS_IOLOGINDATASAVE_HPP_
