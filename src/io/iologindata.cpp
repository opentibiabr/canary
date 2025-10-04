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
#include "io/account_vip_repository.hpp"
#include "io/functions/iologindata_load_player.hpp"
#include "io/functions/iologindata_save_player.hpp"
#include "game/game.hpp"
#include "creatures/monsters/monster.hpp"
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
		if (!IOLoginDataLoad::loadPlayerBasicInfo(player, result)) {
			g_logger().warn("[{}] - Failed to load player basic info", __FUNCTION__);
			return false;
		}

		// Experience load
		IOLoginDataLoad::loadPlayerExperience(player, result);

		// Blessings load
		IOLoginDataLoad::loadPlayerBlessings(player, result);

		// load conditions
		IOLoginDataLoad::loadPlayerConditions(player, result);

		// load animus mastery
		IOLoginDataLoad::loadPlayerAnimusMastery(player, result);

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
		IOLoginDataLoad::loadPlayerStorageMap(player);

		// load vip
		IOLoginDataLoad::loadPlayerVip(player, result);

		// load prey class
		IOLoginDataLoad::loadPlayerPreyClass(player, result);

		// Load task hunting class
		IOLoginDataLoad::loadPlayerTaskHuntingClass(player, result);

		// Load instant spells list
		IOLoginDataLoad::loadPlayerInstantSpellList(player, result);

		if (!disableIrrelevantInfo) {
			// Load additional data only if the player is online (e.g., forge, bosstiary)
			loadOnlyDataForOnlinePlayer(player, result);
		}

		return true;
	} catch (const std::system_error &error) {
		g_logger().warn("[{}] Error while load player: {}", __FUNCTION__, error.what());
		return false;
	} catch (const std::exception &e) {
		g_logger().warn("[{}] Error while load player: {}", __FUNCTION__, e.what());
		return false;
	}
}

void IOLoginData::loadOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	IOLoginDataLoad::loadPlayerForgeHistory(player, result);
	IOLoginDataLoad::loadPlayerBosstiary(player, result);
	IOLoginDataLoad::loadPlayerInitializeSystem(player);
	IOLoginDataLoad::loadPlayerUpdateSystem(player);
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

	// Saves data components that are only valid if the player is online.
	// Skips execution entirely if the player is offline to avoid overwriting unloaded data.
	saveOnlyDataForOnlinePlayer(player);

	return true;
}

void IOLoginData::saveOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player) {
	if (player->isOffline()) {
		return;
	}

	if (!IOLoginDataSave::savePlayerForgeHistory(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerForgeHistory] - Failed to save player forge history: " + player->getName());
	}

	if (!IOLoginDataSave::savePlayerBosstiary(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerBosstiary] - Failed to save player bosstiary: " + player->getName());
	}

	if (!player->wheel().saveDBPlayerSlotPointsOnLogout()) {
		throw DatabaseException("[PlayerWheel::saveDBPlayerSlotPointsOnLogout] - Failed to save player wheel info: " + player->getName());
	}

	player->wheel().saveRevealedGems();
	player->wheel().saveActiveGems();
	player->wheel().saveKVModGrades();
	player->wheel().saveKVScrolls();

	if (!IOLoginDataSave::savePlayerStorage(player)) {
		throw DatabaseException("[IOLoginDataSave::savePlayerStorage] - Failed to save player storage: " + player->getName());
	}
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
	return g_accountVipRepository().getEntries(accountId);
}

void IOLoginData::addVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	if (!g_accountVipRepository().addEntry(accountId, guid, description, icon, notify)) {
		g_logger().error("Failed to add VIP entry for account {}.", accountId);
	}
}

void IOLoginData::editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
	if (!g_accountVipRepository().editEntry(accountId, guid, description, icon, notify)) {
		g_logger().error("Failed to edit VIP entry for account {}.", accountId);
	}
}

void IOLoginData::removeVIPEntry(uint32_t accountId, uint32_t guid) {
	g_accountVipRepository().removeEntry(accountId, guid);
}

std::vector<VIPGroupEntry> IOLoginData::getVIPGroupEntries(uint32_t accountId, uint32_t guid) {
	return g_accountVipRepository().getGroups(accountId);
}

void IOLoginData::addVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
	if (!g_accountVipRepository().addGroup(groupId, accountId, groupName, customizable)) {
		g_logger().error("Failed to add VIP Group entry for account {} and group {}.", accountId, groupId);
	}
}

void IOLoginData::editVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
	if (!g_accountVipRepository().editGroup(groupId, accountId, groupName, customizable)) {
		g_logger().error("Failed to update VIP Group entry for account {} and group {}.", accountId, groupId);
	}
}

void IOLoginData::removeVIPGroupEntry(uint8_t groupId, uint32_t accountId) {
	g_accountVipRepository().removeGroup(groupId, accountId);
}

void IOLoginData::addGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid) {
	if (!g_accountVipRepository().addGuidToGroup(groupId, accountId, guid)) {
		g_logger().error("Failed to add guid VIP Group entry for account {}, player {} and group {}.", accountId, guid, groupId);
	}
}

void IOLoginData::removeGuidVIPGroupEntry(uint32_t accountId, uint32_t guid) {
	g_accountVipRepository().removeGuidFromGroup(accountId, guid);
}
