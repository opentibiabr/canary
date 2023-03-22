/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_IO_IOLOGINDATA_H_
#define SRC_IO_IOLOGINDATA_H_

#include "creatures/players/account/account.hpp"
#include "creatures/players/player.h"
#include "database/database.h"

using ItemBlockList = std::list<std::pair<int32_t, Item*>>;

class IOLoginData {
	public:
		static bool authenticateAccountPassword(const std::string &email, const std::string &password, account::Account* account);
		static bool gameWorldAuthentication(const std::string &accountName, const std::string &password, std::string &characterName, uint32_t* accountId);
		static account::AccountType getAccountType(uint32_t accountId);
		static void setAccountType(uint32_t accountId, account::AccountType accountType);
		static void updateOnlineStatus(uint32_t guid, bool login);
		static bool preloadPlayer(Player* player, const std::string &name);

		static bool loadPlayerById(Player* player, uint32_t id);
		static bool loadPlayerByName(Player* player, const std::string &name);
		static bool loadPlayer(Player* player, DBResult_ptr result);
		static bool savePlayer(Player* player);
		static uint32_t getGuidByName(const std::string &name);
		static bool getGuidByNameEx(uint32_t &guid, bool &specialVip, std::string &name);
		static std::string getNameByGuid(uint32_t guid);
		static bool formatPlayerName(std::string &name);
		static void increaseBankBalance(uint32_t guid, uint64_t bankBalance);
		static bool hasBiddedOnHouse(uint32_t guid);

		static std::forward_list<VIPEntry> getVIPEntries(uint32_t accountId);
		static void addVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify);
		static void editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify);
		static void removeVIPEntry(uint32_t accountId, uint32_t guid);

		static void addPremiumDays(uint32_t accountId, int32_t addDays);
		static void removePremiumDays(uint32_t accountId, int32_t removeDays);

	protected:
		using ItemMap = std::map<uint32_t, std::pair<Item*, uint32_t>>;
		static void loadItems(ItemMap &itemMap, DBResult_ptr result, Player &player);
		static bool saveItems(const Player* player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &stream);
};

#endif // SRC_IO_IOLOGINDATA_H_
