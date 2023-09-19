/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "account/account.hpp"
#include "creatures/players/player.hpp"
#include "database/database.hpp"

using ItemBlockList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;

class IOLoginData {
public:
	static bool gameWorldAuthentication(const std::string &accountDescriptor, const std::string &sessionOrPassword, std::string &characterName, uint32_t &accountId, bool oldProcotol);
	static account::AccountType getAccountType(uint32_t accountId);
	static void updateOnlineStatus(uint32_t guid, bool login);
	static bool loadPlayerById(std::shared_ptr<Player> player, uint32_t id, bool disable = true);
	static bool loadPlayerByName(std::shared_ptr<Player> player, const std::string &name, bool disable = true);
	static bool loadPlayer(std::shared_ptr<Player> player, DBResult_ptr result, bool disable = true);
	static bool savePlayer(std::shared_ptr<Player> player);
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

private:
	static bool savePlayerGuard(std::shared_ptr<Player> player);
};
