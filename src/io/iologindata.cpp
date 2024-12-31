/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/iologindata.hpp"

#include "account/account.hpp"
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "io/functions/iologindata_load_player.hpp"
#include "io/functions/iologindata_save_player.hpp"
#include "game/game.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/player.hpp"
#include "lib/metrics/metrics.hpp"
#include "enums/account_type.hpp"
#include "enums/account_errors.hpp"

bool IOLoginData::gameWorldAuthentication(const std::string &accountDescriptor, const std::string &password, std::string &characterName, uint32_t &accountId, bool oldProtocol, const uint32_t ip) {
	Account account(accountDescriptor);
	account.setProtocolCompat(oldProtocol);

	if (AccountErrors_t::Ok != account.load()) {
		g_logger().error("Couldn't load account [{}].", account.getDescriptor());
		return false;
	}

	if (g_configManager().getString(AUTH_TYPE) == "session") {
		if (!account.authenticate()) {
			return false;
		}
	} else {
		if (!account.authenticate(password)) {
			return false;
		}
	}

	if (!g_accountRepository().getCharacterByAccountIdAndName(account.getID(), characterName)) {
		g_logger().warn("IP [{}] trying to connect into another account character", convertIPToString(ip));
		return false;
	}

	if (AccountErrors_t::Ok != account.load()) {
		g_logger().error("Failed to load account [{}]", accountDescriptor);
		return false;
	}

	auto [players, result] = account.getAccountPlayers();
	if (AccountErrors_t::Ok != result) {
		g_logger().error("Failed to load account [{}] players", accountDescriptor);
		return false;
	}

	if (players[characterName] != 0) {
		g_logger().error("Account [{}] player [{}] not found or deleted.", accountDescriptor, characterName);
		return false;
	}

	accountId = account.getID();

	return true;
}

uint8_t IOLoginData::getAccountType(uint32_t accountId) {
	std::ostringstream query;
	query << "SELECT `type` FROM `accounts` WHERE `id` = " << accountId;
	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return ACCOUNT_TYPE_NORMAL;
	}

	return result->getNumber<uint8_t>("type");
}

// The boolean "disableIrrelevantInfo" will deactivate the loading of information that is not relevant to the preload, for example, forge, bosstiary, etc. None of this we need to access if the player is offline
bool IOLoginData::loadPlayerById(const std::shared_ptr<Player> &player, uint32_t id, bool disableIrrelevantInfo /* = true*/) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `players` WHERE `id` = " << id;
	return loadPlayer(player, db.storeQuery(query.str()), disableIrrelevantInfo);
}

bool IOLoginData::loadPlayerByName(const std::shared_ptr<Player> &player, const std::string &name, bool disableIrrelevantInfo /* = true*/) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `players` WHERE `name` = " << db.escapeString(name);
	return loadPlayer(player, db.storeQuery(query.str()), disableIrrelevantInfo);
}

bool IOLoginData::loadPlayer(const std::shared_ptr<Player> &player, const DBResult_ptr &result, bool disableIrrelevantInfo /* = false*/) {
	if (!result || !player) {
		std::string nullptrType = !result ? "Result" : "Player";
		g_logger().warn("[{}] - {} is nullptr", __FUNCTION__, nullptrType);
		return false;
	}

	try {
		// First
		IOLoginDataLoad::loadPlayerBasicInfo(player, result);

		// Experience load
		IOLoginDataLoad::loadPlayerExperience(player, result);

		// Blessings load
		IOLoginDataLoad::loadPlayerBlessings(player, result);

		// load conditions
		IOLoginDataLoad::loadPlayerConditions(player, result);

		// load default outfit
		IOLoginDataLoad::loadPlayerDefaultOutfit(player, result);

		// skull system load
		IOLoginDataLoad::loadPlayerSkullSystem(player, result);

		// skill load
		IOLoginDataLoad::loadPlayerSkill(player, result);

		// kills load
		IOLoginDataLoad::loadPlayerKills(player, result);

		// guild load
		IOLoginDataLoad::loadPlayerGuild(player, result);

		// stash load items
		IOLoginDataLoad::loadPlayerStashItems(player, result);

		// bestiary charms
		IOLoginDataLoad::loadPlayerBestiaryCharms(player, result);

		// load inventory items
		IOLoginDataLoad::loadPlayerInventoryItems(player, result);

		// store Inbox
		IOLoginDataLoad::loadPlayerStoreInbox(player);

		// load depot items
		IOLoginDataLoad::loadPlayerDepotItems(player, result);

		// load reward items
		IOLoginDataLoad::loadRewardItems(player);

		// load inbox items
		IOLoginDataLoad::loadPlayerInboxItems(player, result);

		// load storage map
		IOLoginDataLoad::loadPlayerStorageMap(player, result);

		// load vip
		IOLoginDataLoad::loadPlayerVip(player, result);

		// load prey class
		IOLoginDataLoad::loadPlayerPreyClass(player, result);

		// Load task hunting class
		IOLoginDataLoad::loadPlayerTaskHuntingClass(player, result);

		// Load instant spells list
		IOLoginDataLoad::loadPlayerInstantSpellList(player, result);

		if (disableIrrelevantInfo) {
			return true;
		}

		// load forge history
		IOLoginDataLoad::loadPlayerForgeHistory(player, result);

		// load bosstiary
		IOLoginDataLoad::loadPlayerBosstiary(player, result);

		IOLoginDataLoad::loadPlayerInitializeSystem(player);
		IOLoginDataLoad::loadPlayerUpdateSystem(player);

		return true;
	} catch (const std::system_error &error) {
		g_logger().warn("[{}] Error while load player: {}", __FUNCTION__, error.what());
		return false;
	} catch (const std::exception &e) {
		g_logger().warn("[{}] Error while load player: {}", __FUNCTION__, e.what());
		return false;
	}
}

bool IOLoginData::savePlayer(const std::shared_ptr<Player> &player) {
	try {
		bool success = DBTransaction::executeWithinTransaction([player]() {
			return savePlayerGuard(player);
		});

		if (!success) {
			g_logger().error("[{}] Error occurred saving player", __FUNCTION__);
		}

		return success;
	} catch (const DatabaseException &e) {
		g_logger().error("[{}] Exception occurred: {}", __FUNCTION__, e.what());
	}

	return false;
}

bool IOLoginData::savePlayerGuard(const std::shared_ptr<Player> &player) {
	if (!player) {
		throw DatabaseException("Player nullptr in function: " + std::string(__FUNCTION__));
	}

	if (!IOLoginDataSave::savePlayerFirst(player)) {
		throw DatabaseException("[" + std::string(__FUNCTION__) + "] - Failed to save player first: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerStash(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerFirst] - Failed to save player stash: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerSpells(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerSpells] - Failed to save player spells: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerKills(player)) {
		throw DatabaseException("IOLoginDataSave::savePlayerKills] - Failed to save player kills: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerBestiarySystem(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerBestiarySystem] - Failed to save player bestiary system: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerItem(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerItem] - Failed to save player item: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerDepotItems(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerDepotItems] - Failed to save player depot items: " + player->getName());
	}

	if (!IOLoginDataSave::saveRewardItems(player)) {
		throw DatabaseException("[IOLoginDataSave::saveRewardItems] - Failed to save player reward items: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerInbox(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerInbox] - Failed to save player inbox: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerPreyClass(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerPreyClass] - Failed to save player prey class: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerTaskHuntingClass(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerTaskHuntingClass] - Failed to save player task hunting class: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerForgeHistory(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerForgeHistory] - Failed to save player forge history: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerBosstiary(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerBosstiary] - Failed to save player bosstiary: " + player->getName());
	}

	if (!player->wheel()->saveDBPlayerSlotPointsOnLogout()) {
		throw DatabaseException("[PlayerWheel::saveDBPlayerSlotPointsOnLogout] - Failed to save player wheel info: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerStorage(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerStorage] - Failed to save player storage: " + player->getName());
	}

	return true;
}

std::string IOLoginData::getNameByGuid(uint32_t guid) {
	std::ostringstream query;
	query << "SELECT `name` FROM `players` WHERE `id` = " << guid;
	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return {};
	}
	return result->getString("name");
}

uint32_t IOLoginData::getGuidByName(const std::string &name) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id` FROM `players` WHERE `name` = " << db.escapeString(name);
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return 0;
	}
	return result->getNumber<uint32_t>("id");
}

bool IOLoginData::getGuidByNameEx(uint32_t &guid, bool &specialVip, std::string &name) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `name`, `id`, `group_id`, `account_id` FROM `players` WHERE `name` = " << db.escapeString(name);
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	name = result->getString("name");
	guid = result->getNumber<uint32_t>("id");
	if (auto group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"))) {
		specialVip = group->flags[Groups::getFlagNumber(PlayerFlags_t::SpecialVIP)];
	} else {
		specialVip = false;
	}
	return true;
}

bool IOLoginData::formatPlayerName(std::string &name) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `name` FROM `players` WHERE `name` = " << db.escapeString(name);

	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	name = result->getString("name");
	return true;
}

void IOLoginData::increaseBankBalance(uint32_t guid, uint64_t bankBalance) {
	std::ostringstream query;
	query << "UPDATE `players` SET `balance` = `balance` + " << bankBalance << " WHERE `id` = " << guid;
	Database::getInstance().executeQuery(query.str());
}

std::vector<VIPEntry> IOLoginData::getVIPEntries(uint32_t accountId) {
	std::string query = fmt::format("SELECT `player_id`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `name`, `description`, `icon`, `notify` FROM `account_viplist` WHERE `account_id` = {}", accountId);
	std::vector<VIPEntry> entries;

	if (const auto &result = Database::getInstance().storeQuery(query)) {
		entries.reserve(result->countResults());
		do {
			entries.emplace_back(
				result->getNumber<uint32_t>("player_id"),
				result->getString("name"),
				result->getString("description"),
				result->getNumber<uint32_t>("icon"),
				result->getNumber<uint16_t>("notify") != 0
			);
		} while (result->next());
	}

	return entries;
}

void IOLoginData::addVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	std::string query = fmt::format("INSERT INTO `account_viplist` (`account_id`, `player_id`, `description`, `icon`, `notify`) VALUES ({}, {}, {}, {}, {})", accountId, guid, g_database().escapeString(description), icon, notify);
	if (!g_database().executeQuery(query)) {
		g_logger().error("Failed to add VIP entry for account {}. QUERY: {}", accountId, query.c_str());
	}
}

void IOLoginData::editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	std::string query = fmt::format("UPDATE `account_viplist` SET `description` = {}, `icon` = {}, `notify` = {} WHERE `account_id` = {} AND `player_id` = {}", g_database().escapeString(description), icon, notify, accountId, guid);
	if (!g_database().executeQuery(query)) {
		g_logger().error("Failed to edit VIP entry for account {}. QUERY: {}", accountId, query.c_str());
	}
}

void IOLoginData::removeVIPEntry(uint32_t accountId, uint32_t guid) {
	std::string query = fmt::format("DELETE FROM `account_viplist` WHERE `account_id` = {} AND `player_id` = {}", accountId, guid);
	g_database().executeQuery(query);
}

std::vector<VIPGroupEntry> IOLoginData::getVIPGroupEntries(uint32_t accountId, uint32_t guid) {
	std::string query = fmt::format("SELECT `id`, `name`, `customizable` FROM `account_vipgroups` WHERE `account_id` = {}", accountId);

	std::vector<VIPGroupEntry> entries;

	if (const auto &result = g_database().storeQuery(query)) {
		entries.reserve(result->countResults());

		do {
			entries.emplace_back(
				result->getNumber<uint8_t>("id"),
				result->getString("name"),
				result->getNumber<uint8_t>("customizable") == 0 ? false : true
			);
		} while (result->next());
	}
	return entries;
}

void IOLoginData::addVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
	std::string query = fmt::format("INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`) VALUES ({}, {}, {}, {})", groupId, accountId, g_database().escapeString(groupName), customizable);
	if (!g_database().executeQuery(query)) {
		g_logger().error("Failed to add VIP Group entry for account {} and group {}. QUERY: {}", accountId, groupId, query.c_str());
	}
}

void IOLoginData::editVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
	std::string query = fmt::format("UPDATE `account_vipgroups` SET `name` = {}, `customizable` = {} WHERE `id` = {} AND `account_id` = {}", g_database().escapeString(groupName), customizable, groupId, accountId);
	if (!g_database().executeQuery(query)) {
		g_logger().error("Failed to update VIP Group entry for account {} and group {}. QUERY: {}", accountId, groupId, query.c_str());
	}
}

void IOLoginData::removeVIPGroupEntry(uint8_t groupId, uint32_t accountId) {
	std::string query = fmt::format("DELETE FROM `account_vipgroups` WHERE `id` = {} AND `account_id` = {}", groupId, accountId);
	g_database().executeQuery(query);
}

void IOLoginData::addGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid) {
	std::string query = fmt::format("INSERT INTO `account_vipgrouplist` (`account_id`, `player_id`, `vipgroup_id`) VALUES ({}, {}, {})", accountId, guid, groupId);
	if (!g_database().executeQuery(query)) {
		g_logger().error("Failed to add guid VIP Group entry for account {}, player {} and group {}. QUERY: {}", accountId, guid, groupId, query.c_str());
	}
}

void IOLoginData::removeGuidVIPGroupEntry(uint32_t accountId, uint32_t guid) {
	std::string query = fmt::format("DELETE FROM `account_vipgrouplist` WHERE `account_id` = {} AND `player_id` = {}", accountId, guid);
	g_database().executeQuery(query);
}
