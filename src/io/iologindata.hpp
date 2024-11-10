/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Player;
class Item;
class DBResult;

struct VIPEntry;
struct VIPGroupEntry;

using ItemBlockList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;

class IOLoginData {
public:
	static bool gameWorldAuthentication(const std::string &accountDescriptor, const std::string &sessionOrPassword, std::string &characterName, uint32_t &accountId, bool oldProcotol, const uint32_t ip);
	static uint8_t getAccountType(uint32_t accountId);
	static bool loadPlayerById(const std::shared_ptr<Player> &player, uint32_t id, bool disableIrrelevantInfo = true);
	static bool loadPlayerByName(const std::shared_ptr<Player> &player, const std::string &name, bool disableIrrelevantInfo = true);
	static bool loadPlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<DBResult> &result, bool disableIrrelevantInfo = false);
	static bool savePlayer(const std::shared_ptr<Player> &player);
	static uint32_t getGuidByName(const std::string &name);
	static bool getGuidByNameEx(uint32_t &guid, bool &specialVip, std::string &name);
	static std::string getNameByGuid(uint32_t guid);
	static bool formatPlayerName(std::string &name);
	static void increaseBankBalance(uint32_t guid, uint64_t bankBalance);
	static bool hasBiddedOnHouse(uint32_t guid);

	static std::vector<VIPEntry> getVIPEntries(uint32_t accountId);
	static void addVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify);
	static void editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify);
	static void removeVIPEntry(uint32_t accountId, uint32_t guid);

	static std::vector<VIPGroupEntry> getVIPGroupEntries(uint32_t accountId, uint32_t guid);
	static void addVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable);
	static void editVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable);
	static void removeVIPGroupEntry(uint8_t groupId, uint32_t accountId);
	static void addGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid);
	static void removeGuidVIPGroupEntry(uint32_t accountId, uint32_t guid);

private:
	static bool savePlayerGuard(const std::shared_ptr<Player> &player);
};
