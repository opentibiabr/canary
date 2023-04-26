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

bool IOLoginData::preloadPlayer(Player* player, const std::string &name) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id`, `account_id`, `group_id`, `deletion`, (SELECT `type` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `account_type`";
	if (!g_configManager().getBoolean(FREE_PREMIUM)) {
		query << ", (SELECT `premdays` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `premium_days`";
	}
	query << " FROM `players` WHERE `name` = " << db.escapeString(name);
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	if (result->getNumber<uint64_t>("deletion") != 0) {
		return false;
	}

	player->setGUID(result->getNumber<uint32_t>("id"));
	Group* group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"));
	if (!group) {
		SPDLOG_ERROR("Player {} has group id {} which doesn't exist", player->name, result->getNumber<uint16_t>("group_id"));
		return false;
	}
	player->setGroup(group);
	player->accountNumber = result->getNumber<uint32_t>("account_id");
	player->accountType = static_cast<account::AccountType>(result->getNumber<uint16_t>("account_type"));
	if (!g_configManager().getBoolean(FREE_PREMIUM)) {
		player->premiumDays = result->getNumber<uint16_t>("premium_days");
	} else {
		player->premiumDays = std::numeric_limits<uint16_t>::max();
	}
	return true;
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

	Database &db = Database::getInstance();

	uint32_t accountId = result->getNumber<uint32_t>("account_id");
	account::Account acc;
	acc.SetDatabaseInterface(&db);
	acc.LoadAccountDB(accountId);

	player->setGUID(result->getNumber<uint32_t>("id"));
	player->name = result->getString("name");
	acc.GetID(&(player->accountNumber));
	acc.GetAccountType(&(player->accountType));

	if (g_configManager().getBoolean(FREE_PREMIUM)) {
		player->premiumDays = std::numeric_limits<uint16_t>::max();
	} else {
		acc.GetPremiumRemaningDays(&(player->premiumDays));
	}

	acc.GetCoins(&(player->coinBalance));

	Group* group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"));
	if (!group) {
		SPDLOG_ERROR("Player {} has group id {} which doesn't exist", player->name, result->getNumber<uint16_t>("group_id"));
		return false;
	}
	player->setGroup(group);

	player->setBankBalance(result->getNumber<uint64_t>("balance"));

	player->quickLootFallbackToMainContainer = result->getNumber<bool>("quickloot_fallback");

	player->setSex(static_cast<PlayerSex_t>(result->getNumber<uint16_t>("sex")));
	player->level = std::max<uint32_t>(1, result->getNumber<uint32_t>("level"));

	uint64_t experience = result->getNumber<uint64_t>("experience");

	uint64_t currExpCount = Player::getExpForLevel(player->level);
	uint64_t nextExpCount = Player::getExpForLevel(player->level + 1);
	if (experience < currExpCount || experience > nextExpCount) {
		experience = currExpCount;
	}

	player->experience = experience;

	if (currExpCount < nextExpCount) {
		player->levelPercent = Player::getPercentLevel(player->experience - currExpCount, nextExpCount - currExpCount);
	} else {
		player->levelPercent = 0;
	}

	player->soul = result->getNumber<uint16_t>("soul");
	player->capacity = result->getNumber<uint32_t>("cap") * 100;
	for (int i = 1; i <= 8; i++) {
		std::ostringstream ss;
		ss << "blessings" << i;
		player->addBlessing(i, result->getNumber<uint16_t>(ss.str()));
	}

	unsigned long attrSize;
	const char* attr = result->getStream("conditions", attrSize);
	PropStream propStream;
	propStream.init(attr, attrSize);

	Condition* condition = Condition::createCondition(propStream);
	while (condition) {
		if (condition->unserialize(propStream)) {
			player->storedConditionList.push_front(condition);
		} else {
			delete condition;
		}
		condition = Condition::createCondition(propStream);
	}

	if (!player->setVocation(result->getNumber<uint16_t>("vocation"))) {
		SPDLOG_ERROR("Player {} has vocation id {} which doesn't exist", player->name, result->getNumber<uint16_t>("vocation"));
		return false;
	}

	player->mana = result->getNumber<uint32_t>("mana");
	player->manaMax = result->getNumber<uint32_t>("manamax");
	player->magLevel = result->getNumber<uint32_t>("maglevel");

	uint64_t nextManaCount = player->vocation->getReqMana(player->magLevel + 1);
	uint64_t manaSpent = result->getNumber<uint64_t>("manaspent");
	if (manaSpent > nextManaCount) {
		manaSpent = 0;
	}

	player->manaSpent = manaSpent;
	player->magLevelPercent = Player::getPercentLevel(player->manaSpent, nextManaCount);

	player->health = result->getNumber<int32_t>("health");
	player->healthMax = result->getNumber<int32_t>("healthmax");

	player->defaultOutfit.lookType = result->getNumber<uint16_t>("looktype");
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && player->defaultOutfit.lookType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookType)) {
		SPDLOG_WARN("[IOLoginData::loadPlayer] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", player->defaultOutfit.lookType);
		return false;
	}
	player->defaultOutfit.lookHead = result->getNumber<uint16_t>("lookhead");
	player->defaultOutfit.lookBody = result->getNumber<uint16_t>("lookbody");
	player->defaultOutfit.lookLegs = result->getNumber<uint16_t>("looklegs");
	player->defaultOutfit.lookFeet = result->getNumber<uint16_t>("lookfeet");
	player->defaultOutfit.lookAddons = result->getNumber<uint16_t>("lookaddons");
	player->defaultOutfit.lookMountHead = result->getNumber<uint16_t>("lookmounthead");
	player->defaultOutfit.lookMountBody = result->getNumber<uint16_t>("lookmountbody");
	player->defaultOutfit.lookMountLegs = result->getNumber<uint16_t>("lookmountlegs");
	player->defaultOutfit.lookMountFeet = result->getNumber<uint16_t>("lookmountfeet");
	player->defaultOutfit.lookFamiliarsType = result->getNumber<uint16_t>("lookfamiliarstype");
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && player->defaultOutfit.lookFamiliarsType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookFamiliarsType)) {
		SPDLOG_WARN("[IOLoginData::loadPlayer] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", player->defaultOutfit.lookFamiliarsType);
		return false;
	}
	player->isDailyReward = result->getNumber<uint16_t>("isreward");
	player->currentOutfit = player->defaultOutfit;

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		const time_t skullSeconds = result->getNumber<time_t>("skulltime") - time(nullptr);
		if (skullSeconds > 0) {
			// ensure that we round up the number of ticks
			player->skullTicks = (skullSeconds + 2);

			uint16_t skull = result->getNumber<uint16_t>("skull");
			if (skull == SKULL_RED) {
				player->skull = SKULL_RED;
			} else if (skull == SKULL_BLACK) {
				player->skull = SKULL_BLACK;
			}
		}
	}

	player->loginPosition.x = result->getNumber<uint16_t>("posx");
	player->loginPosition.y = result->getNumber<uint16_t>("posy");
	player->loginPosition.z = result->getNumber<uint16_t>("posz");

	player->addPreyCards(result->getNumber<uint64_t>("prey_wildcard"));
	player->addTaskHuntingPoints(result->getNumber<uint64_t>("task_points"));
	player->addForgeDusts(result->getNumber<uint64_t>("forge_dusts"));
	player->addForgeDustLevel(result->getNumber<uint64_t>("forge_dust_level"));
	player->setRandomMount(result->getNumber<uint16_t>("randomize_mount"));
	player->addBossPoints(result->getNumber<uint32_t>("boss_points"));

	player->lastLoginSaved = result->getNumber<time_t>("lastlogin");
	player->lastLogout = result->getNumber<time_t>("lastlogout");

	player->offlineTrainingTime = result->getNumber<int32_t>("offlinetraining_time") * 1000;
	auto skill = result->getInt8FromString(result->getString("offlinetraining_skill"), __FUNCTION__);
	player->setOfflineTrainingSkill(skill);

	Town* town = g_game().map.towns.getTown(result->getNumber<uint32_t>("town_id"));
	if (!town) {
		SPDLOG_ERROR("Player {} has town id {} which doesn't exist", player->name, result->getNumber<uint16_t>("town_id"));
		return false;
	}

	player->town = town;

	const Position &loginPos = player->loginPosition;
	if (loginPos.x == 0 && loginPos.y == 0 && loginPos.z == 0) {
		player->loginPosition = player->getTemplePosition();
	}

	player->staminaMinutes = result->getNumber<uint16_t>("stamina");
	player->setStoreXpBoost(result->getNumber<uint16_t>("xpboost_value"));
	player->setExpBoostStamina(result->getNumber<uint16_t>("xpboost_stamina"));

	static const std::string skillNames[] = { "skill_fist", "skill_club", "skill_sword", "skill_axe", "skill_dist", "skill_shielding", "skill_fishing", "skill_critical_hit_chance", "skill_critical_hit_damage", "skill_life_leech_chance", "skill_life_leech_amount", "skill_mana_leech_chance", "skill_mana_leech_amount" };
	static const std::string skillNameTries[] = { "skill_fist_tries", "skill_club_tries", "skill_sword_tries", "skill_axe_tries", "skill_dist_tries", "skill_shielding_tries", "skill_fishing_tries", "skill_critical_hit_chance_tries", "skill_critical_hit_damage_tries", "skill_life_leech_chance_tries", "skill_life_leech_amount_tries", "skill_mana_leech_chance_tries", "skill_mana_leech_amount_tries" };
	static constexpr size_t size = sizeof(skillNames) / sizeof(std::string);
	for (uint8_t i = 0; i < size; ++i) {
		uint16_t skillLevel = result->getNumber<uint16_t>(skillNames[i]);
		uint64_t skillTries = result->getNumber<uint64_t>(skillNameTries[i]);
		uint64_t nextSkillTries = player->vocation->getReqSkillTries(i, skillLevel + 1);
		if (skillTries > nextSkillTries) {
			skillTries = 0;
		}

		player->skills[i].level = skillLevel;
		player->skills[i].tries = skillTries;
		player->skills[i].percent = Player::getPercentLevel(skillTries, nextSkillTries);
	}

	player->setManaShield(result->getNumber<uint16_t>("manashield"));
	player->setMaxManaShield(result->getNumber<uint16_t>("max_manashield"));

	std::ostringstream query;
	query << "SELECT `guild_id`, `rank_id`, `nick` FROM `guild_membership` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		uint32_t guildId = result->getNumber<uint32_t>("guild_id");
		uint32_t playerRankId = result->getNumber<uint32_t>("rank_id");
		player->guildNick = result->getString("nick");

		Guild* guild = g_game().getGuild(guildId);
		if (!guild) {
			guild = IOGuild::loadGuild(guildId);
			g_game().addGuild(guild);
		}

		if (guild) {
			player->guild = guild;
			GuildRank_ptr rank = guild->getRankById(playerRankId);
			if (!rank) {
				query.str(std::string());
				query << "SELECT `id`, `name`, `level` FROM `guild_ranks` WHERE `id` = " << playerRankId;

				if ((result = db.storeQuery(query.str()))) {
					guild->addRank(result->getNumber<uint32_t>("id"), result->getString("name"), result->getNumber<uint16_t>("level"));
				}

				rank = guild->getRankById(playerRankId);
				if (!rank) {
					player->guild = nullptr;
				}
			}

			player->guildRank = rank;

			IOGuild::getWarList(guildId, player->guildWarVector);

			query.str(std::string());
			query << "SELECT COUNT(*) AS `members` FROM `guild_membership` WHERE `guild_id` = " << guildId;
			if ((result = db.storeQuery(query.str()))) {
				guild->setMemberCount(result->getNumber<uint32_t>("members"));
			}
		}
	}

	// Stash load items
	query.str(std::string());
	query << "SELECT `item_count`, `item_id`  FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addItemOnStash(result->getNumber<uint16_t>("item_id"), result->getNumber<uint32_t>("item_count"));
		} while (result->next());
	}

	// Bestiary charms
	query.str(std::string());
	query << "SELECT * FROM `player_charms` WHERE `player_guid` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		player->charmPoints = result->getNumber<uint32_t>("charm_points");
		player->charmExpansion = result->getNumber<bool>("charm_expansion");
		player->charmRuneWound = result->getNumber<uint16_t>("rune_wound");
		player->charmRuneEnflame = result->getNumber<uint16_t>("rune_enflame");
		player->charmRunePoison = result->getNumber<uint16_t>("rune_poison");
		player->charmRuneFreeze = result->getNumber<uint16_t>("rune_freeze");
		player->charmRuneZap = result->getNumber<uint16_t>("rune_zap");
		player->charmRuneCurse = result->getNumber<uint16_t>("rune_curse");
		player->charmRuneCripple = result->getNumber<uint16_t>("rune_cripple");
		player->charmRuneParry = result->getNumber<uint16_t>("rune_parry");
		player->charmRuneDodge = result->getNumber<uint16_t>("rune_dodge");
		player->charmRuneAdrenaline = result->getNumber<uint16_t>("rune_adrenaline");
		player->charmRuneNumb = result->getNumber<uint16_t>("rune_numb");
		player->charmRuneCleanse = result->getNumber<uint16_t>("rune_cleanse");
		player->charmRuneBless = result->getNumber<uint16_t>("rune_bless");
		player->charmRuneScavenge = result->getNumber<uint16_t>("rune_scavenge");
		player->charmRuneGut = result->getNumber<uint16_t>("rune_gut");
		player->charmRuneLowBlow = result->getNumber<uint16_t>("rune_low_blow");
		player->charmRuneDivine = result->getNumber<uint16_t>("rune_divine");
		player->charmRuneVamp = result->getNumber<uint16_t>("rune_vamp");
		player->charmRuneVoid = result->getNumber<uint16_t>("rune_void");
		player->UsedRunesBit = result->getNumber<int32_t>("UsedRunesBit");
		player->UnlockedRunesBit = result->getNumber<int32_t>("UnlockedRunesBit");

		unsigned long attrBestSize;
		const char* Bestattr = result->getStream("tracker list", attrBestSize);
		PropStream propBestStream;
		propBestStream.init(Bestattr, attrBestSize);

		uint16_t raceid_t;
		while (propBestStream.read<uint16_t>(raceid_t)) {
			MonsterType* tmp_tt = g_monsters().getMonsterTypeByRaceId(raceid_t);
			if (tmp_tt) {
				player->addBestiaryTrackerList(tmp_tt);
			}
		}

	} else {
		query.str(std::string());
		query << "INSERT INTO `player_charms` (`player_guid`) VALUES (" << player->getGUID() << ')';
		Database::getInstance().executeQuery(query.str());
	}

	query.str(std::string());
	query << "SELECT `player_id`, `name` FROM `player_spells` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->learnedInstantSpellList.emplace_front(result->getString("name"));
		} while (result->next());
	}

	// load inventory items
	ItemMap itemMap;

	query.str(std::string());
	query << "SELECT `player_id`, `time`, `target`, `unavenged` FROM `player_kills` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			time_t killTime = result->getNumber<time_t>("time");
			if ((time(nullptr) - killTime) <= g_configManager().getNumber(FRAG_TIME)) {
				player->unjustifiedKills.emplace_back(result->getNumber<uint32_t>("target"), killTime, result->getNumber<bool>("unavenged"));
			}
		} while (result->next());
	}

	query.str(std::string());
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_items` WHERE `player_id` = " << player->getGUID() << " ORDER BY `sid` DESC";

	std::vector<std::pair<uint8_t, Container*>> openContainersList;

	if ((result = db.storeQuery(query.str()))) {
		loadItems(itemMap, result, *player);

		for (ItemMap::const_reverse_iterator it = itemMap.rbegin(), end = itemMap.rend(); it != end; ++it) {
			const std::pair<Item*, int32_t> &pair = it->second;
			Item* item = pair.first;
			if (!item) {
				continue;
			}

			int32_t pid = pair.second;

			if (pid >= CONST_SLOT_FIRST && pid <= CONST_SLOT_LAST) {
				player->internalAddThing(pid, item);
				item->startDecaying();
			} else {
				ItemMap::const_iterator it2 = itemMap.find(pid);
				if (it2 == itemMap.end()) {
					continue;
				}

				Container* container = it2->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					item->startDecaying();
				}
			}

			Container* itemContainer = item->getContainer();
			if (itemContainer) {
				auto cid = item->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER);
				if (cid > 0) {
					openContainersList.emplace_back(std::make_pair(cid, itemContainer));
				}
				if (item->hasAttribute(ItemAttribute_t::QUICKLOOTCONTAINER)) {
					auto flags = item->getAttribute<int64_t>(ItemAttribute_t::QUICKLOOTCONTAINER);
					for (uint8_t category = OBJECTCATEGORY_FIRST; category <= OBJECTCATEGORY_LAST; category++) {
						if (hasBitSet(1 << category, flags)) {
							player->setLootContainer((ObjectCategory_t)category, itemContainer, true);
						}
					}
				}
			}
		}
	}

	std::sort(openContainersList.begin(), openContainersList.end(), [](const std::pair<uint8_t, Container*> &left, const std::pair<uint8_t, Container*> &right) {
		return left.first < right.first;
	});

	for (auto &it : openContainersList) {
		player->addContainer(it.first - 1, it.second);
		player->onSendContainer(it.second);
	}

	// Store Inbox
	if (!player->inventory[CONST_SLOT_STORE_INBOX]) {
		player->internalAddThing(CONST_SLOT_STORE_INBOX, Item::CreateItem(ITEM_STORE_INBOX));
	}

	IOLoginDataLoad::loadRewardItems(player);

	// load depot items
	itemMap.clear();
	query.str(std::string());
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_depotitems` WHERE `player_id` = " << player->getGUID() << " ORDER BY `sid` DESC";
	if ((result = db.storeQuery(query.str()))) {
		loadItems(itemMap, result, *player);

		for (ItemMap::const_reverse_iterator it = itemMap.rbegin(), end = itemMap.rend(); it != end; ++it) {
			const std::pair<Item*, int32_t> &pair = it->second;
			Item* item = pair.first;

			int32_t pid = pair.second;
			if (pid >= 0 && pid < 100) {
				DepotChest* depotChest = player->getDepotChest(pid, true);
				if (depotChest) {
					depotChest->internalAddThing(item);
					item->startDecaying();
				}
			} else {
				ItemMap::const_iterator it2 = itemMap.find(pid);
				if (it2 == itemMap.end()) {
					continue;
				}

				Container* container = it2->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					item->startDecaying();
				}
			}
		}
	}

	// load inbox items
	itemMap.clear();
	query.str(std::string());
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_inboxitems` WHERE `player_id` = " << player->getGUID() << " ORDER BY `sid` DESC";
	if ((result = db.storeQuery(query.str()))) {
		loadItems(itemMap, result, *player);

		for (ItemMap::const_reverse_iterator it = itemMap.rbegin(), end = itemMap.rend(); it != end; ++it) {
			const std::pair<Item*, int32_t> &pair = it->second;
			Item* item = pair.first;
			int32_t pid = pair.second;

			if (pid >= 0 && pid < 100) {
				player->getInbox()->internalAddThing(item);
				item->startDecaying();
			} else {
				ItemMap::const_iterator it2 = itemMap.find(pid);

				if (it2 == itemMap.end()) {
					continue;
				}

				Container* container = it2->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					item->startDecaying();
				}
			}
		}
	}

	// load storage map
	query.str(std::string());
	query << "SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addStorageValue(result->getNumber<uint32_t>("key"), result->getNumber<int32_t>("value"), true);
		} while (result->next());
	}

	// load vip
	query.str(std::string());
	query << "SELECT `player_id` FROM `account_viplist` WHERE `account_id` = " << player->getAccount();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addVIPInternal(result->getNumber<uint32_t>("player_id"));
		} while (result->next());
	}

	// Load prey class
	if (g_configManager().getBoolean(PREY_ENABLED)) {
		query.str(std::string());
		query << "SELECT * FROM `player_prey` WHERE `player_id` = " << player->getGUID();
		if (result = db.storeQuery(query.str())) {
			do {
				auto slot = new PreySlot(static_cast<PreySlot_t>(result->getNumber<uint16_t>("slot")));
				PreyDataState_t state = static_cast<PreyDataState_t>(result->getNumber<uint16_t>("state"));
				if (slot->id == PreySlot_Two && state == PreyDataState_Locked) {
					if (!player->isPremium()) {
						slot->state = PreyDataState_Locked;
					} else {
						slot->state = PreyDataState_Selection;
					}
				} else {
					slot->state = state;
				}
				slot->selectedRaceId = result->getNumber<uint16_t>("raceid");
				slot->option = static_cast<PreyOption_t>(result->getNumber<uint16_t>("option"));
				slot->bonus = static_cast<PreyBonus_t>(result->getNumber<uint16_t>("bonus_type"));
				slot->bonusRarity = static_cast<uint8_t>(result->getNumber<uint16_t>("bonus_rarity"));
				slot->bonusPercentage = result->getNumber<uint16_t>("bonus_percentage");
				slot->bonusTimeLeft = result->getNumber<uint16_t>("bonus_time");
				slot->freeRerollTimeStamp = result->getNumber<int64_t>("free_reroll");

				unsigned long preySize;
				const char* preyStream = result->getStream("monster_list", preySize);
				PropStream propPreyStream;
				propPreyStream.init(preyStream, preySize);

				uint16_t raceId;
				while (propPreyStream.read<uint16_t>(raceId)) {
					slot->raceIdList.push_back(raceId);
				}

				player->setPreySlotClass(slot);
			} while (result->next());
		}
	}

	IOLoginDataLoad::loadPlayerForgeHistory(player, result);
	IOLoginDataLoad::loadPlayerBosstiary(player, result);

	// Load task hunting class
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		query.str(std::string());
		query << "SELECT * FROM `player_taskhunt` WHERE `player_id` = " << player->getGUID();
		if (result = db.storeQuery(query.str())) {
			do {
				auto slot = new TaskHuntingSlot(static_cast<PreySlot_t>(result->getNumber<uint16_t>("slot")));
				PreyTaskDataState_t state = static_cast<PreyTaskDataState_t>(result->getNumber<uint16_t>("state"));
				if (slot->id == PreySlot_Two && state == PreyTaskDataState_Locked) {
					if (!player->isPremium()) {
						slot->state = PreyTaskDataState_Locked;
					} else {
						slot->state = PreyTaskDataState_Selection;
					}
				} else {
					slot->state = state;
				}
				slot->selectedRaceId = result->getNumber<uint16_t>("raceid");
				slot->upgrade = result->getNumber<bool>("upgrade");
				slot->rarity = static_cast<uint8_t>(result->getNumber<uint16_t>("rarity"));
				slot->currentKills = result->getNumber<uint16_t>("kills");
				slot->disabledUntilTimeStamp = result->getNumber<int64_t>("disabled_time");
				slot->freeRerollTimeStamp = result->getNumber<int64_t>("free_reroll");

				unsigned long taskHuntSize;
				const char* taskHuntStream = result->getStream("monster_list", taskHuntSize);
				PropStream propTaskHuntStream;
				propTaskHuntStream.init(taskHuntStream, taskHuntSize);

				uint16_t raceId;
				while (propTaskHuntStream.read<uint16_t>(raceId)) {
					slot->raceIdList.push_back(raceId);
				}

				if (slot->state == PreyTaskDataState_Inactive && slot->disabledUntilTimeStamp < OTSYS_TIME()) {
					slot->state = PreyTaskDataState_Selection;
				}

				player->setTaskHuntingSlotClass(slot);
			} while (result->next());
		}
	}

	player->initializePrey();
	player->initializeTaskHunting();
	player->updateBaseSpeed();
	player->updateInventoryWeight();
	player->updateItemsLight(true);
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
	if (player->getHealth() <= 0) {
		player->changeHealth(1);
	}
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `save` FROM `players` WHERE `id` = " << player->getGUID();
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		SPDLOG_WARN("[IOLoginData::savePlayer] - Error for select result query from player: {}", player->getName());
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

	DBTransaction transaction;
	if (!transaction.begin()) {
		return false;
	}

	if (!db.executeQuery(query.str())) {
		return false;
	}

	// Stash save items
	query.str(std::string());
	query << "DELETE FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	db.executeQuery(query.str());
	for (auto it : player->getStashItems()) {
		query.str(std::string());
		query << "INSERT INTO `player_stash` (`player_id`,`item_id`,`item_count`) VALUES (";
		query << player->getGUID() << ", ";
		query << it.first << ", ";
		query << it.second << ")";
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
	for (MonsterType* trackedType : player->getBestiaryTrackerList()) {
		propBestiaryStream.write<uint16_t>(trackedType->info.raceid);
	}
	size_t trackerSize;
	const char* trackerList = propBestiaryStream.getStream(trackerSize);
	query << " `tracker list` = " << db.escapeBlob(trackerList, trackerSize);
	query << " WHERE `player_guid` = " << player->getGUID();

	if (!db.executeQuery(query.str())) {
		SPDLOG_WARN("[IOLoginData::savePlayer] - Error saving bestiary data from player: {}", player->getName());
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
		SPDLOG_WARN("[IOLoginData::savePlayer] - Error delete query 'player_items' from player: {}", player->getName());
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
		SPDLOG_WARN("[IOLoginData::savePlayer] - Failed for save items from player: {}", player->getName());
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
		SPDLOG_ERROR("[{}] failed to save reward items");
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
		query.str(std::string());
		query << "DELETE FROM `player_prey` WHERE `player_id` = " << player->getGUID();
		if (!db.executeQuery(query.str())) {
			return false;
		}

		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			PreySlot* slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
			if (slot) {
				query.str(std::string());
				query << "INSERT INTO `player_prey` (`player_id`, `slot`, `state`, `raceid`, `option`, `bonus_type`, `bonus_rarity`, `bonus_percentage`, `bonus_time`, `free_reroll`, `monster_list`) VALUES (";
				query << player->getGUID() << ", ";
				query << static_cast<uint16_t>(slot->id) << ", ";
				query << static_cast<uint16_t>(slot->state) << ", ";
				query << slot->selectedRaceId << ", ";
				query << static_cast<uint16_t>(slot->option) << ", ";
				query << static_cast<uint16_t>(slot->bonus) << ", ";
				query << static_cast<uint16_t>(slot->bonusRarity) << ", ";
				query << slot->bonusPercentage << ", ";
				query << slot->bonusTimeLeft << ", ";
				query << slot->freeRerollTimeStamp << ", ";

				PropWriteStream propPreyStream;
				std::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&propPreyStream](uint16_t raceId) {
					propPreyStream.write<uint16_t>(raceId);
				});

				size_t preySize;
				const char* preyList = propPreyStream.getStream(preySize);
				query << db.escapeBlob(preyList, static_cast<uint32_t>(preySize)) << ")";

				if (!db.executeQuery(query.str())) {
					SPDLOG_WARN("[IOLoginData::savePlayer] - Error saving prey slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}

	// Save task hunting class
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		query.str(std::string());
		query << "DELETE FROM `player_taskhunt` WHERE `player_id` = " << player->getGUID();
		if (!db.executeQuery(query.str())) {
			return false;
		}

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

				if (!db.executeQuery(query.str())) {
					SPDLOG_WARN("[IOLoginData::savePlayer] - Error saving task hunting slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}

	IOLoginDataSave::savePlayerForgeHistory(player);
	IOLoginDataSave::savePlayerBosstiary(player);

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
	return transaction.commit();
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
				SPDLOG_WARN("[IOLoginData::loadItems] - Failed to unserialize attributes of item {}, of player {}, from account id {}", item->getID(), player.getName(), player.getAccount());
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
	query << "UPDATE `accounts` SET `premdays` = `premdays` + " << addDays << " WHERE `id` = " << accountId;
	Database::getInstance().executeQuery(query.str());
}

void IOLoginData::removePremiumDays(uint32_t accountId, int32_t removeDays) {
	std::ostringstream query;
	query << "UPDATE `accounts` SET `premdays` = `premdays` - " << removeDays << " WHERE `id` = " << accountId;
	Database::getInstance().executeQuery(query.str());
}
