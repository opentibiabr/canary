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
#include "creatures/players/wheel/player_wheel.hpp"
#include "io/ioprey.h"
#include "security/argon.hpp"

bool IOLoginData::authenticateAccountPassword(const std::string &accountIdentifier, const std::string &password, account::Account* account) {
	if (account::ERROR_NO != account->LoadAccountDB(accountIdentifier)) {
		g_logger().error("{} {} doesn't match any account.", account->getProtocolCompat() ? "Username" : "Email", accountIdentifier);
		return false;
	}

	std::string accountPassword;
	account->GetPassword(&accountPassword);

	Argon2 argon2;
	if (!argon2.argon(password.c_str(), accountPassword)) {
		if (transformToSHA1(password) != accountPassword) {
			g_logger().error("Password '{}' doesn't match any account", accountPassword);
			return false;
		}
	}

	return true;
}

bool IOLoginData::authenticateAccountSession(const std::string &sessionId, account::Account* account) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `account_id`, `expires` FROM `account_sessions` WHERE `id` = " << db.escapeString(transformToSHA1(sessionId));
	DBResult_ptr result = Database::getInstance().storeQuery(query.str());
	if (!result) {
		g_logger().error("Session id {} not found in the database", sessionId);
		return false;
	}
	uint32_t expires = result->getNumber<uint32_t>("expires");
	if (expires < getTimeNow()) {
		g_logger().error("Session id {} found, but it is expired", sessionId);
		return false;
	}
	uint32_t accountId = result->getNumber<uint32_t>("account_id");
	if (account::ERROR_NO != account->LoadAccountDB(accountId)) {
		g_logger().error("Session id {} found account id {}, but it doesn't match any account.", sessionId, accountId);
		return false;
	}

	return true;
}

bool IOLoginData::gameWorldAuthentication(const std::string &accountIdentifier, const std::string &sessionOrPassword, std::string &characterName, uint32_t* accountId, bool oldProtocol) {
	account::Account account;
	account.setProtocolCompat(oldProtocol);
	std::string authType = g_configManager().getString(AUTH_TYPE);

	if (authType == "session") {
		if (!IOLoginData::authenticateAccountSession(sessionOrPassword, &account)) {
			return false;
		}
	} else { // authType == "password"
		if (!IOLoginData::authenticateAccountPassword(accountIdentifier, sessionOrPassword, &account)) {
			return false;
		}
	}

	account::Player player;
	if (account::ERROR_NO != account.GetAccountPlayer(&player, characterName)) {
		g_logger().error("Player not found or deleted for account.");
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
	static phmap::flat_hash_map<uint32_t, bool> updateOnline;
	if (login && updateOnline.find(guid) != updateOnline.end() || guid <= 0) {
		return;
	}

	std::ostringstream query;
	if (login) {
		query << "INSERT INTO `players_online` VALUES (" << guid << ')';
		updateOnline[guid] = true;
	} else {
		query << "DELETE FROM `players_online` WHERE `player_id` = " << guid;
		updateOnline.erase(guid);
	}
	Database::getInstance().executeQuery(query.str());
}

// The boolean "disable" will desactivate the loading of information that is not relevant to the preload, for example, forge, bosstiary, etc. None of this we need to access if the player is offline
bool IOLoginData::loadPlayerById(Player* player, uint32_t id, bool disable /* = true*/) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `players` WHERE `id` = " << id;
	return loadPlayer(player, db.storeQuery(query.str()), disable);
}

bool IOLoginData::loadPlayerByName(Player* player, const std::string &name, bool disable /* = true*/) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `players` WHERE `name` = " << db.escapeString(name);
	return loadPlayer(player, db.storeQuery(query.str()), disable);
}

bool IOLoginData::loadPlayer(Player* player, DBResult_ptr result, bool disable /* = false*/) {
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
	IOLoginDataLoad::loadPlayerStoreInbox(player, result);

	// load depot items
	IOLoginDataLoad::loadPlayerDepotItems(player, result);

	// load reward items
	IOLoginDataLoad::loadRewardItems(player);

	// load inbox items
	IOLoginDataLoad::loadPlayerInboxItems(player, result);

	// load storage map
	IOLoginDataLoad::loadPlayerStorageMap(player, result);

	// We will not load the information from here on down, as they are functions that are not needed for the player preload
	if (disable) {
		return true;
	}

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

	IOLoginDataLoad::loadPlayerInitializeSystem(player, result);
	IOLoginDataLoad::loadPlayerUpdateSystem(player, result);
	return true;
}

bool IOLoginData::saveItems(const Player* player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &propWriteStream) {
	Database &db = Database::getInstance();

	std::ostringstream ss;

	using ContainerBlock = std::pair<Container*, int32_t>;
	std::list<ContainerBlock> queue;

	int32_t runningId = 100;

	const auto &openContainers = player->getOpenContainers();
	for (const auto &it : itemList) {
		int32_t pid = it.first;
		Item* item = it.second;
		++runningId;

		if (Container* container = item->getContainer()) {
			if (container->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER) > 0) {
				container->setAttribute(ItemAttribute_t::OPENCONTAINER, 0);
			}

			if (!openContainers.empty()) {
				for (const auto &its : openContainers) {
					auto openContainer = its.second;
					auto opcontainer = openContainer.container;

					if (opcontainer == container) {
						container->setAttribute(ItemAttribute_t::OPENCONTAINER, ((int)its.first) + 1);
						break;
					}
				}
			}

			queue.emplace_back(container, runningId);
		}

		propWriteStream.clear();
		item->serializeAttr(propWriteStream);

		size_t attributesSize;
		const char* attributes = propWriteStream.getStream(attributesSize);

		ss << player->getGUID() << ',' << pid << ',' << runningId << ',' << item->getID() << ',' << item->getSubType() << ',' << db.escapeBlob(attributes, attributesSize);
		if (!query_insert.addRow(ss)) {
			return false;
		}
	}

	while (!queue.empty()) {
		const ContainerBlock &cb = queue.front();
		Container* container = cb.first;
		int32_t parentId = cb.second;
		queue.pop_front();

		for (Item* item : container->getItemList()) {
			++runningId;

			Container* subContainer = item->getContainer();
			if (subContainer) {
				queue.emplace_back(subContainer, runningId);
				if (subContainer->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER) > 0) {
					subContainer->setAttribute(ItemAttribute_t::OPENCONTAINER, 0);
				}

				if (!openContainers.empty()) {
					for (const auto &it : openContainers) {
						auto openContainer = it.second;
						auto opcontainer = openContainer.container;

						if (opcontainer == subContainer) {
							subContainer->setAttribute(ItemAttribute_t::OPENCONTAINER, (it.first) + 1);
							break;
						}
					}
				}
			}

			propWriteStream.clear();
			item->serializeAttr(propWriteStream);

			size_t attributesSize;
			const char* attributes = propWriteStream.getStream(attributesSize);

			ss << player->getGUID() << ',' << parentId << ',' << runningId << ',' << item->getID() << ',' << item->getSubType() << ',' << db.escapeBlob(attributes, attributesSize);
			if (!query_insert.addRow(ss)) {
				return false;
			}
		}
	}
	return query_insert.execute();
}

bool IOLoginData::savePlayer(Player* player) {
	bool success = DBTransaction::executeWithinTransaction([player]() {
		return savePlayerGuard(player);
	});

	if (!success) {
		g_logger().error("[{}] Error occurred saving player", __FUNCTION__);
	}

	return success;
}

bool IOLoginData::savePlayerGuard(Player* player) {
	if (player->getHealth() <= 0) {
		player->changeHealth(1);
	}
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `save` FROM `players` WHERE `id` = " << player->getGUID();
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		g_logger().warn("[IOLoginData::savePlayer] - Error for select result query from player: {}", player->getName());
		return false;
	}

	if (result->getNumber<uint16_t>("save") == 0) {
		query.str(std::string());
		query << "UPDATE `players` SET `lastlogin` = " << player->lastLoginSaved << ", `lastip` = " << player->lastIP << " WHERE `id` = " << player->getGUID();
		return db.executeQuery(query.str());
	}

	// First, an UPDATE query to write the player itself
	query.str(std::string());
	query << "UPDATE `players` SET ";
	query << "`level` = " << player->level << ',';
	query << "`group_id` = " << player->group->id << ',';
	query << "`vocation` = " << player->getVocationId() << ',';
	query << "`health` = " << player->health << ',';
	query << "`healthmax` = " << player->healthMax << ',';
	query << "`experience` = " << player->experience << ',';
	query << "`lookbody` = " << static_cast<uint32_t>(player->defaultOutfit.lookBody) << ',';
	query << "`lookfeet` = " << static_cast<uint32_t>(player->defaultOutfit.lookFeet) << ',';
	query << "`lookhead` = " << static_cast<uint32_t>(player->defaultOutfit.lookHead) << ',';
	query << "`looklegs` = " << static_cast<uint32_t>(player->defaultOutfit.lookLegs) << ',';
	query << "`looktype` = " << player->defaultOutfit.lookType << ',';
	query << "`lookaddons` = " << static_cast<uint32_t>(player->defaultOutfit.lookAddons) << ',';
	query << "`lookmountbody` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountBody) << ',';
	query << "`lookmountfeet` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountFeet) << ',';
	query << "`lookmounthead` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountHead) << ',';
	query << "`lookmountlegs` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountLegs) << ',';
	query << "`lookfamiliarstype` = " << player->defaultOutfit.lookFamiliarsType << ',';
	query << "`isreward` = " << static_cast<uint16_t>(player->isDailyReward) << ',';
	query << "`maglevel` = " << player->magLevel << ',';
	query << "`mana` = " << player->mana << ',';
	query << "`manamax` = " << player->manaMax << ',';
	query << "`manaspent` = " << player->manaSpent << ',';
	query << "`soul` = " << static_cast<uint16_t>(player->soul) << ',';
	query << "`town_id` = " << player->town->getID() << ',';

	const Position &loginPosition = player->getLoginPosition();
	query << "`posx` = " << loginPosition.getX() << ',';
	query << "`posy` = " << loginPosition.getY() << ',';
	query << "`posz` = " << loginPosition.getZ() << ',';

	query << "`prey_wildcard` = " << player->getPreyCards() << ',';
	query << "`task_points` = " << player->getTaskHuntingPoints() << ',';
	query << "`boss_points` = " << player->getBossPoints() << ',';
	query << "`forge_dusts` = " << player->getForgeDusts() << ',';
	query << "`forge_dust_level` = " << player->getForgeDustLevel() << ',';
	query << "`randomize_mount` = " << static_cast<uint16_t>(player->isRandomMounted()) << ',';

	query << "`cap` = " << (player->capacity / 100) << ',';
	query << "`sex` = " << static_cast<uint16_t>(player->sex) << ',';

	if (player->lastLoginSaved != 0) {
		query << "`lastlogin` = " << player->lastLoginSaved << ',';
	}

	if (player->lastIP != 0) {
		query << "`lastip` = " << player->lastIP << ',';
	}

	// serialize conditions
	PropWriteStream propWriteStream;
	for (Condition* condition : player->conditions) {
		if (condition->isPersistent()) {
			condition->serialize(propWriteStream);
			propWriteStream.write<uint8_t>(CONDITIONATTR_END);
		}
	}

	size_t attributesSize;
	const char* attributes = propWriteStream.getStream(attributesSize);

	query << "`conditions` = " << db.escapeBlob(attributes, attributesSize) << ',';

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		int64_t skullTime = 0;

		if (player->skullTicks > 0) {
			skullTime = time(nullptr) + player->skullTicks;
		}

		query << "`skulltime` = " << skullTime << ',';

		Skulls_t skull = SKULL_NONE;
		if (player->skull == SKULL_RED) {
			skull = SKULL_RED;
		} else if (player->skull == SKULL_BLACK) {
			skull = SKULL_BLACK;
		}
		query << "`skull` = " << static_cast<int64_t>(skull) << ',';
	}

	query << "`lastlogout` = " << player->getLastLogout() << ',';
	query << "`balance` = " << player->bankBalance << ',';
	query << "`offlinetraining_time` = " << player->getOfflineTrainingTime() / 1000 << ',';
	query << "`offlinetraining_skill` = " << std::to_string(player->getOfflineTrainingSkill()) << ',';
	query << "`stamina` = " << player->getStaminaMinutes() << ',';
	query << "`skill_fist` = " << player->skills[SKILL_FIST].level << ',';
	query << "`skill_fist_tries` = " << player->skills[SKILL_FIST].tries << ',';
	query << "`skill_club` = " << player->skills[SKILL_CLUB].level << ',';
	query << "`skill_club_tries` = " << player->skills[SKILL_CLUB].tries << ',';
	query << "`skill_sword` = " << player->skills[SKILL_SWORD].level << ',';
	query << "`skill_sword_tries` = " << player->skills[SKILL_SWORD].tries << ',';
	query << "`skill_axe` = " << player->skills[SKILL_AXE].level << ',';
	query << "`skill_axe_tries` = " << player->skills[SKILL_AXE].tries << ',';
	query << "`skill_dist` = " << player->skills[SKILL_DISTANCE].level << ',';
	query << "`skill_dist_tries` = " << player->skills[SKILL_DISTANCE].tries << ',';
	query << "`skill_shielding` = " << player->skills[SKILL_SHIELD].level << ',';
	query << "`skill_shielding_tries` = " << player->skills[SKILL_SHIELD].tries << ',';
	query << "`skill_fishing` = " << player->skills[SKILL_FISHING].level << ',';
	query << "`skill_fishing_tries` = " << player->skills[SKILL_FISHING].tries << ',';
	query << "`skill_critical_hit_chance` = " << player->skills[SKILL_CRITICAL_HIT_CHANCE].level << ',';
	query << "`skill_critical_hit_chance_tries` = " << player->skills[SKILL_CRITICAL_HIT_CHANCE].tries << ',';
	query << "`skill_critical_hit_damage` = " << player->skills[SKILL_CRITICAL_HIT_DAMAGE].level << ',';
	query << "`skill_critical_hit_damage_tries` = " << player->skills[SKILL_CRITICAL_HIT_DAMAGE].tries << ',';
	query << "`skill_life_leech_chance` = " << player->skills[SKILL_LIFE_LEECH_CHANCE].level << ',';
	query << "`skill_life_leech_chance_tries` = " << player->skills[SKILL_LIFE_LEECH_CHANCE].tries << ',';
	query << "`skill_life_leech_amount` = " << player->skills[SKILL_LIFE_LEECH_AMOUNT].level << ',';
	query << "`skill_life_leech_amount_tries` = " << player->skills[SKILL_LIFE_LEECH_AMOUNT].tries << ',';
	query << "`skill_mana_leech_chance` = " << player->skills[SKILL_MANA_LEECH_CHANCE].level << ',';
	query << "`skill_mana_leech_chance_tries` = " << player->skills[SKILL_MANA_LEECH_CHANCE].tries << ',';
	query << "`skill_mana_leech_amount` = " << player->skills[SKILL_MANA_LEECH_AMOUNT].level << ',';
	query << "`skill_mana_leech_amount_tries` = " << player->skills[SKILL_MANA_LEECH_AMOUNT].tries << ',';
	query << "`manashield` = " << player->getManaShield() << ',';
	query << "`max_manashield` = " << player->getMaxManaShield() << ',';
	query << "`xpboost_value` = " << player->getStoreXpBoost() << ',';
	query << "`xpboost_stamina` = " << player->getExpBoostStamina() << ',';
	query << "`quickloot_fallback` = " << (player->quickLootFallbackToMainContainer ? 1 : 0) << ',';

	if (!player->isOffline()) {
		query << "`onlinetime` = `onlinetime` + " << (time(nullptr) - player->lastLoginSaved) << ',';
	}
	for (int i = 1; i <= 8; i++) {
		query << "`blessings" << i << "`"
			  << " = " << static_cast<uint32_t>(player->getBlessingCount(i)) << ((i == 8) ? ' ' : ',');
	}
	query << " WHERE `id` = " << player->getGUID();

	if (!db.executeQuery(query.str())) {
		return false;
	}

	// First, delete all items from the player's stash
	query.str(std::string());
	query << "DELETE FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	db.executeQuery(query.str());

	// Then, insert the current items in the stash
	for (auto it : player->getStashItems()) {
		query.str(std::string());
		query << "INSERT INTO `player_stash` (`player_id`,`item_id`,`item_count`) VALUES ("
			  << player->getGUID() << ", "
			  << it.first << ", "
			  << it.second << ")";
		db.executeQuery(query.str());
	}

	// learned spells
	query.str(std::string());
	query << "DELETE FROM `player_spells` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str(std::string());

	DBInsert spellsQuery("INSERT INTO `player_spells` (`player_id`, `name` ) VALUES ");
	for (const std::string &spellName : player->learnedInstantSpellList) {
		query << player->getGUID() << ',' << db.escapeString(spellName);
		if (!spellsQuery.addRow(query)) {
			return false;
		}
	}

	if (!spellsQuery.execute()) {
		return false;
	}

	// player kills
	query.str(std::string());
	query << "DELETE FROM `player_kills` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	// player bestiary charms
	query.str(std::string());
	query << "UPDATE `player_charms` SET ";
	query << "`charm_points` = " << player->charmPoints << ',';
	query << "`charm_expansion` = " << ((player->charmExpansion) ? 1 : 0) << ',';
	query << "`rune_wound` = " << player->charmRuneWound << ',';
	query << "`rune_enflame` = " << player->charmRuneEnflame << ',';
	query << "`rune_poison` = " << player->charmRunePoison << ',';
	query << "`rune_freeze` = " << player->charmRuneFreeze << ',';
	query << "`rune_zap` = " << player->charmRuneZap << ',';
	query << "`rune_curse` = " << player->charmRuneCurse << ',';
	query << "`rune_cripple` = " << player->charmRuneCripple << ',';
	query << "`rune_parry` = " << player->charmRuneParry << ',';
	query << "`rune_dodge` = " << player->charmRuneDodge << ',';
	query << "`rune_adrenaline` = " << player->charmRuneAdrenaline << ',';
	query << "`rune_numb` = " << player->charmRuneNumb << ',';
	query << "`rune_cleanse` = " << player->charmRuneCleanse << ',';
	query << "`rune_bless` = " << player->charmRuneBless << ',';
	query << "`rune_scavenge` = " << player->charmRuneScavenge << ',';
	query << "`rune_gut` = " << player->charmRuneGut << ',';
	query << "`rune_low_blow` = " << player->charmRuneLowBlow << ',';
	query << "`rune_divine` = " << player->charmRuneDivine << ',';
	query << "`rune_vamp` = " << player->charmRuneVamp << ',';
	query << "`rune_void` = " << player->charmRuneVoid << ',';
	query << "`UsedRunesBit` = " << player->UsedRunesBit << ',';
	query << "`UnlockedRunesBit` = " << player->UnlockedRunesBit << ',';

	// Bestiary tracker
	PropWriteStream propBestiaryStream;
	for (const auto &trackedType : player->getBestiaryTrackerList()) {
		propBestiaryStream.write<uint16_t>(trackedType->info.raceid);
	}
	size_t trackerSize;
	const char* trackerList = propBestiaryStream.getStream(trackerSize);
	query << " `tracker list` = " << db.escapeBlob(trackerList, trackerSize);
	query << " WHERE `player_guid` = " << player->getGUID();

	if (!db.executeQuery(query.str())) {
		g_logger().warn("[IOLoginData::savePlayer] - Error saving bestiary data from player: {}", player->getName());
		return false;
	}

	query.str(std::string());

	DBInsert killsQuery("INSERT INTO `player_kills` (`player_id`, `target`, `time`, `unavenged`) VALUES");
	for (const auto &kill : player->unjustifiedKills) {
		query << player->getGUID() << ',' << kill.target << ',' << kill.time << ',' << kill.unavenged;
		if (!killsQuery.addRow(query)) {
			return false;
		}
	}

	if (!killsQuery.execute()) {
		return false;
	}

	// item saving
	query << "DELETE FROM `player_items` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		g_logger().warn("[IOLoginData::savePlayer] - Error delete query 'player_items' from player: {}", player->getName());
		return false;
	}

	DBInsert itemsQuery("INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");

	ItemBlockList itemList;
	for (int32_t slotId = CONST_SLOT_FIRST; slotId <= CONST_SLOT_LAST; ++slotId) {
		Item* item = player->inventory[slotId];
		if (item) {
			itemList.emplace_back(slotId, item);
		}
	}

	if (!saveItems(player, itemList, itemsQuery, propWriteStream)) {
		g_logger().warn("[IOLoginData::savePlayer] - Failed for save items from player: {}", player->getName());
		return false;
	}

	if (player->lastDepotId != -1) {
		// save depot items
		query.str(std::string());
		query << "DELETE FROM `player_depotitems` WHERE `player_id` = " << player->getGUID();

		if (!db.executeQuery(query.str())) {
			return false;
		}

		DBInsert depotQuery("INSERT INTO `player_depotitems` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");
		itemList.clear();

		for (const auto &it : player->depotChests) {
			DepotChest* depotChest = it.second;
			for (Item* item : depotChest->getItemList()) {
				itemList.emplace_back(it.first, item);
			}
		}

		if (!saveItems(player, itemList, depotQuery, propWriteStream)) {
			return false;
		}
	}

	if (!IOLoginDataSave::saveRewardItems(player)) {
		g_logger().error("[{}] failed to save reward items");
		return false;
	}

	// save inbox items
	query.str(std::string());
	query << "DELETE FROM `player_inboxitems` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	DBInsert inboxQuery("INSERT INTO `player_inboxitems` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");
	itemList.clear();

	for (Item* item : player->getInbox()->getItemList()) {
		itemList.emplace_back(0, item);
	}

	if (!saveItems(player, itemList, inboxQuery, propWriteStream)) {
		return false;
	}

	// Save prey class
	if (g_configManager().getBoolean(PREY_ENABLED)) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			PreySlot* slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
			if (slot) {
				query.str(std::string());
				query << "INSERT INTO player_prey (`player_id`, `slot`, `state`, `raceid`, `option`, `bonus_type`, `bonus_rarity`, `bonus_percentage`, `bonus_time`, `free_reroll`, `monster_list`) "
					  << "VALUES (" << player->getGUID() << ", "
					  << static_cast<uint16_t>(slot->id) << ", "
					  << static_cast<uint16_t>(slot->state) << ", "
					  << slot->selectedRaceId << ", "
					  << static_cast<uint16_t>(slot->option) << ", "
					  << static_cast<uint16_t>(slot->bonus) << ", "
					  << static_cast<uint16_t>(slot->bonusRarity) << ", "
					  << slot->bonusPercentage << ", "
					  << slot->bonusTimeLeft << ", "
					  << slot->freeRerollTimeStamp << ", ";

				PropWriteStream propPreyStream;
				std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&propPreyStream](uint16_t raceId) {
					propPreyStream.write<uint16_t>(raceId);
				});

				size_t preySize;
				const char* preyList = propPreyStream.getStream(preySize);
				query << db.escapeBlob(preyList, static_cast<uint32_t>(preySize)) << ")";

				query << " ON DUPLICATE KEY UPDATE "
					  << "`state` = VALUES(`state`), "
					  << "`raceid` = VALUES(`raceid`), "
					  << "`option` = VALUES(`option`), "
					  << "`bonus_type` = VALUES(`bonus_type`), "
					  << "`bonus_rarity` = VALUES(`bonus_rarity`), "
					  << "`bonus_percentage` = VALUES(`bonus_percentage`), "
					  << "`bonus_time` = VALUES(`bonus_time`), "
					  << "`free_reroll` = VALUES(`free_reroll`), "
					  << "`monster_list` = VALUES(`monster_list`)";

				if (!db.executeQuery(query.str())) {
					g_logger().warn("[IOLoginData::savePlayer] - Error saving prey slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}

	// Save task hunting class
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			TaskHuntingSlot* slot = player->getTaskHuntingSlotById(static_cast<PreySlot_t>(slotId));
			if (slot) {
				query.str(std::string());
				query << "INSERT INTO `player_taskhunt` (`player_id`, `slot`, `state`, `raceid`, `upgrade`, `rarity`, `kills`, `disabled_time`, `free_reroll`, `monster_list`) VALUES (";
				query << player->getGUID() << ", ";
				query << static_cast<uint16_t>(slot->id) << ", ";
				query << static_cast<uint16_t>(slot->state) << ", ";
				query << slot->selectedRaceId << ", ";
				query << (slot->upgrade ? 1 : 0) << ", ";
				query << static_cast<uint16_t>(slot->rarity) << ", ";
				query << slot->currentKills << ", ";
				query << slot->disabledUntilTimeStamp << ", ";
				query << slot->freeRerollTimeStamp << ", ";

				PropWriteStream propTaskHuntingStream;
				std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&propTaskHuntingStream](uint16_t raceId) {
					propTaskHuntingStream.write<uint16_t>(raceId);
				});

				size_t taskHuntingSize;
				const char* taskHuntingList = propTaskHuntingStream.getStream(taskHuntingSize);
				query << db.escapeBlob(taskHuntingList, static_cast<uint32_t>(taskHuntingSize)) << ")";

				query << " ON DUPLICATE KEY UPDATE "
					  << "`state` = VALUES(`state`), "
					  << "`raceid` = VALUES(`raceid`), "
					  << "`upgrade` = VALUES(`upgrade`), "
					  << "`rarity` = VALUES(`rarity`), "
					  << "`kills` = VALUES(`kills`), "
					  << "`disabled_time` = VALUES(`disabled_time`), "
					  << "`free_reroll` = VALUES(`free_reroll`), "
					  << "`monster_list` = VALUES(`monster_list`)";

				if (!db.executeQuery(query.str())) {
					g_logger().warn("[IOLoginData::savePlayer] - Error saving task hunting slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}

	IOLoginDataSave::savePlayerForgeHistory(player);
	IOLoginDataSave::savePlayerBosstiary(player);

	if (!player->wheel()->saveDBPlayerSlotPointsOnLogout()) {
		g_logger().warn("Failed to save player wheel info to player: {}", player->getName());
		return false;
	}

	query.str(std::string());
	query << "DELETE FROM `player_storage` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str(std::string());

	DBInsert storageQuery("INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES ");
	player->genReservedStorageRange();

	for (const auto &it : player->storageMap) {
		query << player->getGUID() << ',' << it.first << ',' << it.second;
		if (!storageQuery.addRow(query)) {
			return false;
		}
	}

	if (!storageQuery.execute()) {
		return false;
	}

	// End the transaction
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

void IOLoginData::loadItems(ItemMap &itemMap, DBResult_ptr result, Player &player) {
	do {
		uint32_t sid = result->getNumber<uint32_t>("sid");
		uint32_t pid = result->getNumber<uint32_t>("pid");
		uint16_t type = result->getNumber<uint16_t>("itemtype");
		uint16_t count = result->getNumber<uint16_t>("count");

		unsigned long attrSize;
		const char* attr = result->getStream("attributes", attrSize);

		PropStream propStream;
		propStream.init(attr, attrSize);

		Item* item = Item::CreateItem(type, count);
		if (item) {
			if (!item->unserializeAttr(propStream)) {
				g_logger().warn("[IOLoginData::loadItems] - Failed to unserialize attributes of item {}, of player {}, from account id {}", item->getID(), player.getName(), player.getAccount());
				savePlayer(&player);
			}

			std::pair<Item*, uint32_t> pair(item, pid);
			itemMap[sid] = pair;
		}
	} while (result->next());
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
	query << "UPDATE `accounts` SET"
		  << "`premdays` = `premdays` + " << addDays
		  << ", `premdays_purchased` = `premdays_purchased` + " << addDays
		  << ", `lastday` = " << getTimeNow()
		  << " WHERE `id` = " << accountId;

	Database::getInstance().executeQuery(query.str());
}

void IOLoginData::removePremiumDays(uint32_t accountId, int32_t removeDays) {
	std::ostringstream query;
	query << "UPDATE `accounts` SET `premdays` = `premdays` - " << removeDays << " WHERE `id` = " << accountId;
	Database::getInstance().executeQuery(query.str());
}
