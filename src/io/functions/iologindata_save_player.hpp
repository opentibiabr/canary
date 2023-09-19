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

class IOLoginDataSave : public IOLoginData {
public:
	static bool savePlayerFirst(std::shared_ptr<Player> player);
	static bool savePlayerStash(std::shared_ptr<Player> player);
	static bool savePlayerSpells(std::shared_ptr<Player> player);
	static bool savePlayerKills(std::shared_ptr<Player> player);
	static bool savePlayerBestiarySystem(std::shared_ptr<Player> player);
	static bool savePlayerItem(std::shared_ptr<Player> player);
	static bool savePlayerDepotItems(std::shared_ptr<Player> player);
	static bool saveRewardItems(std::shared_ptr<Player> player);
	static bool savePlayerInbox(std::shared_ptr<Player> player);
	static bool savePlayerPreyClass(std::shared_ptr<Player> player);
	static bool savePlayerTaskHuntingClass(std::shared_ptr<Player> player);
	static bool savePlayerForgeHistory(std::shared_ptr<Player> player);
	static bool savePlayerBosstiary(std::shared_ptr<Player> player);
	static bool savePlayerStorage(std::shared_ptr<Player> palyer);

protected:
	using ItemBlockList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;
	using ItemDepotList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;
	using ItemRewardList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;
	using ItemInboxList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;

	static bool saveItems(std::shared_ptr<Player> player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &stream);
};
