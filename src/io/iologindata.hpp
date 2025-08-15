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

	/**
	 * @brief Loads data components that are only relevant when the player is online.
	 *
	 * This function is responsible for initializing systems that are not needed when the player is offline,
	 * such as the forge history, bosstiary, and various runtime systems.
	 *
	 * If the player is offline, this function returns early and avoids loading these systems.
	 * This helps optimize memory usage and prevents unnecessary initialization of unused features.
	 *
	 * @param player A shared pointer to the Player instance. Must not be nullptr.
	 * @param result The database result containing the player's data.
	 */
	static void loadOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<DBResult> &result);

	static bool savePlayer(const std::shared_ptr<Player> &player);

	/**
	 * @brief Saves data components that are only relevant when the player is online.
	 *
	 * This function is responsible for persisting player-related systems that are only loaded
	 * when the player is online, such as the forge history, bosstiary progress, and wheel data.
	 *
	 * If the player is offline, this function will return immediately without performing any save operations.
	 * This prevents overwriting existing database values with empty or uninitialized data that may result
	 * from partial player loading (common during offline operations).
	 *
	 * @note This function throws DatabaseException if any of the internal save operations fail.
	 * It should be called after all always-loaded data has been saved.
	 *
	 * @param player A shared pointer to the Player instance. Must not be nullptr.
	 */
	static void saveOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player);
	static uint32_t getGuidByName(const std::string &name);
	static bool getGuidByNameEx(uint32_t &guid, bool &specialVip, std::string &name);
	static std::string getNameByGuid(uint32_t guid);
	static bool formatPlayerName(std::string &name);
	static void increaseBankBalance(uint32_t guid, uint64_t bankBalance);

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
