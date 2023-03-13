/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/iologindata.h"
#include "io/functions/iologindata_load_player.hpp"
#include "io/functions/iologindata_save_player.hpp"
#include "game/game.h"
#include "creatures/monsters/monster.h"
#include "io/ioprey.h"

bool IOLoginData::authenticateAccountPassword(const std::string &email, const std::string &password, account::Account* account) {
	if (account::ERROR_NO != account->LoadAccountDB(email)) {
		SPDLOG_ERROR("Email {} doesn't match any account.", email);
		return false;
	}

	std::string accountPassword;
	account->GetPassword(&accountPassword);
	if (transformToSHA1(password) != accountPassword) {
		SPDLOG_ERROR("Password '{}' doesn't match any account", transformToSHA1(password));
		return false;
	}

	return true;
}

bool IOLoginData::gameWorldAuthentication(const std::string &email, const std::string &password, std::string &characterName, uint32_t* accountId) {
	account::Account account;
	if (!IOLoginData::authenticateAccountPassword(email, password, &account)) {
		return false;
	}

	account::Player player;
	if (account::ERROR_NO != account.GetAccountPlayer(&player, characterName)) {
		SPDLOG_ERROR("Player not found or deleted for account.");
		return false;
	}

	account.GetID(accountId);

	return true;
}

account::AccountType IOLoginData::getAccountType(uint32_t accountId) {
	std::ostringstream query;
	query << "SELECT `type` FROM `accounts` WHERE `id` = " << accountId;
	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return account::ACCOUNT_TYPE_NORMAL;
	}
	return static_cast<account::AccountType>(result->getNumber<uint16_t>("type"));
}

void IOLoginData::setAccountType(uint32_t accountId, account::AccountType accountType) {
	std::ostringstream query;
	query << "UPDATE `accounts` SET `type` = " << static_cast<uint16_t>(accountType) << " WHERE `id` = " << accountId;
	Database::getInstance().executeQuery(query.str());
}

void IOLoginData::updateOnlineStatus(uint32_t guid, bool login) {
	if (g_configManager().getBoolean(ALLOW_CLONES)) {
		return;
	}

	std::ostringstream query;
	if (login) {
		query << "INSERT INTO `players_online` VALUES (" << guid << ')';
	} else {
		query << "DELETE FROM `players_online` WHERE `player_id` = " << guid;
	}
	Database::getInstance().executeQuery(query.str());
}

bool IOLoginData::loadPlayerById(Player* player, uint32_t id) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `players` WHERE `id` = " << id;
	return loadPlayer(player, db.storeQuery(query.str()));
}

bool IOLoginData::loadPlayerByName(Player* player, const std::string &name) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `players` WHERE `name` = " << db.escapeString(name);
	return loadPlayer(player, db.storeQuery(query.str()));
}

bool IOLoginData::loadPlayer(Player* player, DBResult_ptr result) {
	if (!result || !player) {
		return false;
	}

	IOLoginDataLoad::loadPlayerFirst(player, result);

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

	// load forge history
	IOLoginDataLoad::loadPlayerForgeHistory(player, result);

	// load bosstiary
	IOLoginDataLoad::loadPlayerBosstiary(player, result);

	IOLoginDataLoad::loadPlayerInitializeSystem(player);
	IOLoginDataLoad::loadPlayerUpdateSystem(player);
	return true;
}

bool IOLoginData::savePlayer(Player* player) {
	uint64_t savingTime = OTSYS_TIME();

	// First, an UPDATE query to write the player itself
	IOLoginDataSave::savePlayerFirst(player);

	// stash saving
	IOLoginDataSave::savePlayerStash(player);

	// learned spells
	IOLoginDataSave::savePlayerSpells(player);

	// player kills
	IOLoginDataSave::savePlayerKills(player);

	// player bestiary charms and Bestiary tracker
	IOLoginDataSave::savePlayerBestiarySystem(player);

	// item saving
	IOLoginDataSave::savePlayerItem(player);

	// save depot items
	IOLoginDataSave::savePlayerDepotItems(player);

	// save reward items
	IOLoginDataSave::saveRewardItems(player);

	// save inbox items
	IOLoginDataSave::savePlayerInbox(player);

	// save prey class
	IOLoginDataSave::savePlayerPreyClass(player);

	// save task hunting class
	IOLoginDataSave::savePlayerTaskHuntingClass(player);

	// save forge history
	IOLoginDataSave::savePlayerForgeHistory(player);

	// save forge history
	IOLoginDataSave::savePlayerBosstiary(player);

	// save storage
	IOLoginDataSave::savePlayerStorage(player);

	SPDLOG_INFO("{}: (Saved in {}ms)", player->getName(), OTSYS_TIME() - savingTime);
	return true;
}

std::string IOLoginData::getNameByGuid(uint32_t guid) {
	std::ostringstream query;
	query << "SELECT `name` FROM `players` WHERE `id` = " << guid;
	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		return std::string();
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

bool IOLoginData::hasBiddedOnHouse(uint32_t guid) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id` FROM `houses` WHERE `highest_bidder` = " << guid << " LIMIT 1";
	return db.storeQuery(query.str()).get() != nullptr;
}

std::forward_list<VIPEntry> IOLoginData::getVIPEntries(uint32_t accountId) {
	std::forward_list<VIPEntry> entries;

	std::ostringstream query;
	query << "SELECT `player_id`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `name`, `description`, `icon`, `notify` FROM `account_viplist` WHERE `account_id` = " << accountId;

	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (result) {
		do {
			entries.emplace_front(
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
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "INSERT INTO `account_viplist` (`account_id`, `player_id`, `description`, `icon`, `notify`) VALUES (" << accountId << ',' << guid << ',' << db.escapeString(description) << ',' << icon << ',' << notify << ')';
	db.executeQuery(query.str());
}

void IOLoginData::editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "UPDATE `account_viplist` SET `description` = " << db.escapeString(description) << ", `icon` = " << icon << ", `notify` = " << notify << " WHERE `account_id` = " << accountId << " AND `player_id` = " << guid;
	db.executeQuery(query.str());
}

void IOLoginData::removeVIPEntry(uint32_t accountId, uint32_t guid) {
	std::ostringstream query;
	query << "DELETE FROM `account_viplist` WHERE `account_id` = " << accountId << " AND `player_id` = " << guid;
	Database::getInstance().executeQuery(query.str());
}

void IOLoginData::addPremiumDays(uint32_t accountId, int32_t addDays) {
	std::ostringstream query;
	query << "UPDATE `accounts` SET `premdays` = `premdays` + " << addDays << " WHERE `id` = " << accountId;
	Database::getInstance().executeQuery(query.str());
}

void IOLoginData::removePremiumDays(uint32_t accountId, int32_t removeDays) {
	std::ostringstream query;
	query << "UPDATE `accounts` SET `premdays` = `premdays` - " << removeDays << " WHERE `id` = " << accountId;
	Database::getInstance().executeQuery(query.str());
}
