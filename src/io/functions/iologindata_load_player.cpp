/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/functions/iologindata_load_player.hpp"

#include "database/database.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "game/game.hpp"
#include "enums/object_category.hpp"
#include "enums/account_coins.hpp"
#include "enums/account_errors.hpp"
#include "utils/tools.hpp"

void IOLoginDataLoad::loadItems(ItemsMap &itemsMap, DBResult_ptr result, const std::shared_ptr<Player> &player) {
	try {
		do {
			uint32_t sid = result->getU32("sid");
			uint32_t pid = result->getU32("pid");
			uint16_t type = result->getU16("itemtype");
			uint16_t count = result->getU16("count");
			auto attributes = result->getStream("attributes");
			PropStream propStream(attributes);
			try {
				std::shared_ptr<Item> item = Item::CreateItem(type, count);
				if (item) {
					if (!item->unserializeAttr(propStream)) {
						g_logger().warn("[{}] - Failed to deserialize item attributes {}, from player {}, from account id {}", __FUNCTION__, item->getID(), player->getName(), player->getAccountId());
						continue;
					}
					itemsMap[sid] = std::make_pair(item, pid);
				} else {
					g_logger().warn("[{}] - Failed to create item of type {} for player {}, from account id {}", __FUNCTION__, type, player->getName(), player->getAccountId());
				}
			} catch (const std::exception &e) {
				g_logger().warn("[{}] - Exception during the creation or deserialization of the item: {}", __FUNCTION__, e.what());
				continue;
			}
		} while (result->next());
	} catch (const std::exception &e) {
		g_logger().error("[{}] - General exception during item loading: {}", __FUNCTION__, e.what());
	}
}

bool IOLoginDataLoad::preLoadPlayer(std::shared_ptr<Player> player, const std::string &name) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id`, `account_id`, `group_id`, `deletion` FROM `players` WHERE `name` = " << db.escapeString(name);
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	if (result->getU64("deletion") != 0) {
		return false;
	}

	player->setGUID(result->getU32("id"));
	const auto &group = g_game().groups.getGroup(result->getU16("group_id"));
	if (!group) {
		g_logger().error("Player {} has group id {} which doesn't exist", player->name, result->getU16("group_id"));
		return false;
	}
	player->setGroup(group);

	auto accountId = result->getU32("account_id");
	if (!player->setAccount(accountId)) {
		g_logger().error("Player {} has account id {} which doesn't exist", player->name, accountId);
		return false;
	}

	auto [coins, error] = player->account->getCoins(enumToValue(CoinType::Normal));
	if (error != enumToValue(AccountErrors_t::Ok)) {
		g_logger().error("Failed to get coins for player {}, error {}", player->name, static_cast<uint8_t>(error));
		return false;
	}

	player->coinBalance = coins;

	auto [transferableCoins, errorT] = player->account->getCoins(enumToValue(CoinType::Transferable));
	if (errorT != enumToValue(AccountErrors_t::Ok)) {
		g_logger().error("Failed to get transferable coins for player {}, error {}", player->name, static_cast<uint8_t>(errorT));
		return false;
	}

	player->coinTransferableBalance = transferableCoins;

	uint32_t premiumDays = player->getAccount()->getPremiumRemainingDays();
	uint32_t premiumDaysPurchased = player->getAccount()->getPremiumDaysPurchased();

	player->loyaltyPoints = player->getAccount()->getAccountAgeInDays() * g_configManager().getNumber(LOYALTY_POINTS_PER_CREATION_DAY, __FUNCTION__)
		+ (premiumDaysPurchased - premiumDays) * g_configManager().getNumber(LOYALTY_POINTS_PER_PREMIUM_DAY_SPENT, __FUNCTION__)
		+ premiumDaysPurchased * g_configManager().getNumber(LOYALTY_POINTS_PER_PREMIUM_DAY_PURCHASED, __FUNCTION__);

	return true;
}

bool IOLoginDataLoad::loadPlayerFirst(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return false;
	}

	player->setGUID(result->getU32("id"));
	player->name = result->getString("name");

	if (!player->getAccount()) {
		player->setAccount(result->getU32("account_id"));
	}

	const auto &group = g_game().groups.getGroup(result->getU16("group_id"));
	if (!group) {
		g_logger().error("Player {} has group id {} which doesn't exist", player->name, result->getU16("group_id"));
		return false;
	}
	player->setGroup(group);

	if (!player->setVocation(result->getU16("vocation"))) {
		g_logger().error("Player {} has vocation id {} which doesn't exist", player->name, result->getU16("vocation"));
		return false;
	}

	player->setBankBalance(result->getU64("balance"));
	player->quickLootFallbackToMainContainer = result->getBool("quickloot_fallback");
	player->setSex(static_cast<PlayerSex_t>(result->getU16("sex")));
	player->setPronoun(static_cast<PlayerPronoun_t>(result->getU16("pronoun")));
	player->level = std::max<uint32_t>(1, result->getU32("level"));
	player->soul = result->getU8("soul");
	player->capacity = result->getU32("cap") * 100;
	player->mana = result->getU32("mana");
	player->manaMax = result->getU32("manamax");
	player->magLevel = result->getU32("maglevel");
	uint64_t nextManaCount = player->vocation->getReqMana(player->magLevel + 1);
	uint64_t manaSpent = result->getU64("manaspent");
	if (manaSpent > nextManaCount) {
		manaSpent = 0;
	}
	player->manaSpent = manaSpent;
	player->magLevelPercent = Player::getPercentLevel(player->manaSpent, nextManaCount);
	player->health = result->getI64("health");
	player->healthMax = result->getI64("healthmax");
	player->isDailyReward = static_cast<uint8_t>(result->getU16("isreward"));
	player->loginPosition.x = result->getU16("posx");
	player->loginPosition.y = result->getU16("posy");
	player->loginPosition.z = static_cast<uint8_t>(result->getU16("posz"));
	player->addPreyCards(result->getU64("prey_wildcard"));
	player->addTaskHuntingPoints(result->getU64("task_points"));
	player->addForgeDusts(result->getU64("forge_dusts"));
	player->addForgeDustLevel(result->getU64("forge_dust_level"));
	player->setRandomMount(static_cast<uint8_t>(result->getU16("randomize_mount")));
	player->addBossPoints(result->getU32("boss_points"));
	player->lastLoginSaved = result->getTime("lastlogin");
	player->lastLogout = result->getTime("lastlogout");
	player->offlineTrainingTime = result->getI64("offlinetraining_time") * 1000;
	player->setOfflineTrainingSkill(result->getI8("offlinetraining_skill"));
	const auto &town = g_game().map.towns.getTown(result->getU32("town_id"));
	if (!town) {
		g_logger().error("Player {} has town id {} which doesn't exist", player->name, result->getU16("town_id"));
		return false;
	}
	player->town = town;

	const Position &loginPos = player->loginPosition;
	if (loginPos.x == 0 && loginPos.y == 0 && loginPos.z == 0) {
		player->loginPosition = player->getTemplePosition();
	}

	player->staminaMinutes = result->getU16("stamina");
	player->setXpBoostPercent(result->getU16("xpboost_value"));
	player->setXpBoostTime(result->getU16("xpboost_stamina"));

	player->setManaShield(result->getU32("manashield"));
	player->setMaxManaShield(result->getU32("max_manashield"));

	player->setMarriageSpouse(result->getNumber<int32_t>("marriage_spouse"));
	return true;
}

void IOLoginDataLoad::loadPlayerExperience(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	uint64_t experience = result->getU64("experience");
	uint64_t currExpCount = Player::getExpForLevel(player->level);
	uint64_t nextExpCount = Player::getExpForLevel(player->level + 1);

	if (experience < currExpCount || experience > nextExpCount) {
		experience = currExpCount;
	}

	player->experience = experience;

	if (currExpCount < nextExpCount) {
		player->levelPercent = static_cast<uint8_t>(std::round(Player::getPercentLevel(player->experience - currExpCount, nextExpCount - currExpCount)));
	} else {
		player->levelPercent = 0;
	}
}

void IOLoginDataLoad::loadPlayerBlessings(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	for (int i = 1; i <= 8; i++) {
		player->addBlessing(static_cast<uint8_t>(i), static_cast<uint8_t>(result->getU16(fmt::format("blessings{}", i))));
	}
}

void IOLoginDataLoad::loadPlayerConditions(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	auto attributes = result->getStream("conditions");
	PropStream propStream(attributes);
	auto condition = Condition::createCondition(propStream);
	while (condition) {
		const std::string typeName = std::string(magic_enum::enum_name(condition->getType()));
		g_logger().debug("[{}] loading condition: {}", __METHOD_NAME__, typeName);
		if (condition->unserialize(propStream)) {
			player->storedConditionList.emplace_back(condition);
		}
		condition = Condition::createCondition(propStream);
	}
}

void IOLoginDataLoad::loadPlayerDefaultOutfit(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	player->defaultOutfit.lookType = result->getU16("looktype");
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS, __FUNCTION__) && player->defaultOutfit.lookType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookType)) {
		g_logger().warn("[IOLoginData::loadPlayer] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", player->defaultOutfit.lookType);
		return;
	}

	player->defaultOutfit.lookHead = static_cast<uint8_t>(result->getU16("lookhead"));
	player->defaultOutfit.lookBody = static_cast<uint8_t>(result->getU16("lookbody"));
	player->defaultOutfit.lookLegs = static_cast<uint8_t>(result->getU16("looklegs"));
	player->defaultOutfit.lookFeet = static_cast<uint8_t>(result->getU16("lookfeet"));
	player->defaultOutfit.lookAddons = static_cast<uint8_t>(result->getU16("lookaddons"));
	player->defaultOutfit.lookMountHead = static_cast<uint8_t>(result->getU16("lookmounthead"));
	player->defaultOutfit.lookMountBody = static_cast<uint8_t>(result->getU16("lookmountbody"));
	player->defaultOutfit.lookMountLegs = static_cast<uint8_t>(result->getU16("lookmountlegs"));
	player->defaultOutfit.lookMountFeet = static_cast<uint8_t>(result->getU16("lookmountfeet"));
	player->defaultOutfit.lookFamiliarsType = result->getU16("lookfamiliarstype");

	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS, __FUNCTION__) && player->defaultOutfit.lookFamiliarsType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookFamiliarsType)) {
		g_logger().warn("[IOLoginData::loadPlayer] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", player->defaultOutfit.lookFamiliarsType);
		return;
	}

	player->currentOutfit = player->defaultOutfit;
}

void IOLoginDataLoad::loadPlayerSkullSystem(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		const time_t skullSeconds = result->getTime("skulltime") - time(nullptr);
		if (skullSeconds > 0) {
			// ensure that we round up the number of ticks
			player->skullTicks = (skullSeconds + 2);

			uint16_t skull = result->getU16("skull");
			if (skull == SKULL_RED) {
				player->skull = SKULL_RED;
			} else if (skull == SKULL_BLACK) {
				player->skull = SKULL_BLACK;
			}
		}
	}
}

void IOLoginDataLoad::loadPlayerSkill(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	static const std::array<std::string, 13> skillNames = { "skill_fist", "skill_club", "skill_sword", "skill_axe", "skill_dist", "skill_shielding", "skill_fishing", "skill_critical_hit_chance", "skill_critical_hit_damage", "skill_life_leech_chance", "skill_life_leech_amount", "skill_mana_leech_chance", "skill_mana_leech_amount" };
	static const std::array<std::string, 13> skillNameTries = { "skill_fist_tries", "skill_club_tries", "skill_sword_tries", "skill_axe_tries", "skill_dist_tries", "skill_shielding_tries", "skill_fishing_tries", "skill_critical_hit_chance_tries", "skill_critical_hit_damage_tries", "skill_life_leech_chance_tries", "skill_life_leech_amount_tries", "skill_mana_leech_chance_tries", "skill_mana_leech_amount_tries" };
	for (size_t i = 0; i < skillNames.size(); ++i) {
		uint16_t skillLevel = result->getU16(skillNames[i]);
		uint64_t skillTries = result->getU64(skillNameTries[i]);
		uint64_t nextSkillTries = player->vocation->getReqSkillTries(static_cast<uint8_t>(i), skillLevel + 1);
		if (skillTries > nextSkillTries) {
			skillTries = 0;
		}

		player->skills[i].level = skillLevel;
		player->skills[i].tries = skillTries;
		player->skills[i].percent = Player::getPercentLevel(skillTries, nextSkillTries);
	}
}

void IOLoginDataLoad::loadPlayerKills(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `player_id`, `time`, `target`, `unavenged` FROM `player_kills` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			time_t killTime = result->getTime("time");
			if ((time(nullptr) - killTime) <= g_configManager().getNumber(FRAG_TIME, __FUNCTION__)) {
				player->unjustifiedKills.emplace_back(result->getU32("target"), killTime, result->getBool("unavenged"));
			}
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerGuild(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `guild_id`, `rank_id`, `nick` FROM `guild_membership` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		uint32_t guildId = result->getU32("guild_id");
		uint32_t playerRankId = result->getU32("rank_id");
		player->guildNick = result->getString("nick");

		auto guild = g_game().getGuild(guildId);
		if (!guild) {
			guild = IOGuild::loadGuild(guildId);
			g_game().addGuild(guild);
		}

		if (guild) {
			player->guild = guild;
			GuildRank_ptr rank = guild->getRankById(playerRankId);
			if (!rank) {
				query.str("");
				query << "SELECT `id`, `name`, `level` FROM `guild_ranks` WHERE `id` = " << playerRankId;

				if ((result = db.storeQuery(query.str()))) {
					guild->addRank(result->getU32("id"), result->getString("name"), static_cast<uint8_t>(result->getU16("level")));
				}

				rank = guild->getRankById(playerRankId);
				if (!rank) {
					player->guild = nullptr;
				}
			}

			player->guildRank = rank;

			IOGuild::getWarList(guildId, player->guildWarVector);

			query.str("");
			query << "SELECT COUNT(*) AS `members` FROM `guild_membership` WHERE `guild_id` = " << guildId;
			if ((result = db.storeQuery(query.str()))) {
				guild->setMemberCount(result->getU32("members"));
			}
		}
	}
}

void IOLoginDataLoad::loadPlayerStashItems(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `item_count`, `item_id`  FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addItemOnStash(result->getU16("item_id"), result->getU32("item_count"));
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerBestiaryCharms(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `player_charms` WHERE `player_guid` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		player->charmPoints = result->getU32("charm_points");
		player->charmExpansion = result->getBool("charm_expansion");
		player->charmRuneWound = result->getU16("rune_wound");
		player->charmRuneEnflame = result->getU16("rune_enflame");
		player->charmRunePoison = result->getU16("rune_poison");
		player->charmRuneFreeze = result->getU16("rune_freeze");
		player->charmRuneZap = result->getU16("rune_zap");
		player->charmRuneCurse = result->getU16("rune_curse");
		player->charmRuneCripple = result->getU16("rune_cripple");
		player->charmRuneParry = result->getU16("rune_parry");
		player->charmRuneDodge = result->getU16("rune_dodge");
		player->charmRuneAdrenaline = result->getU16("rune_adrenaline");
		player->charmRuneNumb = result->getU16("rune_numb");
		player->charmRuneCleanse = result->getU16("rune_cleanse");
		player->charmRuneBless = result->getU16("rune_bless");
		player->charmRuneScavenge = result->getU16("rune_scavenge");
		player->charmRuneGut = result->getU16("rune_gut");
		player->charmRuneLowBlow = result->getU16("rune_low_blow");
		player->charmRuneDivine = result->getU16("rune_divine");
		player->charmRuneVamp = result->getU16("rune_vamp");
		player->charmRuneVoid = result->getU16("rune_void");
		player->UsedRunesBit = result->getI64("UsedRunesBit");
		player->UnlockedRunesBit = result->getI64("UnlockedRunesBit");

		auto bestiaryAttributes = result->getStream("tracker_list");
		PropStream propBestStream(bestiaryAttributes);
		uint16_t monsterRaceId;
		while (propBestStream.readU16(monsterRaceId)) {
			const auto monsterType = g_monsters().getMonsterTypeByRaceId(monsterRaceId);
			if (monsterType) {
				player->addMonsterToCyclopediaTrackerList(monsterType, false, false);
			}
		}
	} else {
		query.str("");
		query << "INSERT INTO `player_charms` (`player_guid`) VALUES (" << player->getGUID() << ')';
		Database::getInstance().executeQuery(query.str());
	}
}

void IOLoginDataLoad::loadPlayerInstantSpellList(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `player_id`, `name` FROM `player_spells` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->learnedInstantSpellList.emplace_back(result->getString("name"));
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerInventoryItems(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	bool oldProtocol = g_configManager().getBoolean(OLD_PROTOCOL, __FUNCTION__) && player->getProtocolVersion() < 1200;
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_items` WHERE `player_id` = " << player->getGUID() << " ORDER BY `sid` DESC";

	ItemsMap inventoryItems;
	std::vector<std::pair<uint8_t, std::shared_ptr<Container>>> openContainersList;

	try {
		if ((result = db.storeQuery(query.str()))) {
			loadItems(inventoryItems, result, player);

			for (ItemsMap::const_reverse_iterator it = inventoryItems.rbegin(), end = inventoryItems.rend(); it != end; ++it) {
				const std::pair<std::shared_ptr<Item>, int32_t> &pair = it->second;
				std::shared_ptr<Item> item = pair.first;
				if (!item) {
					continue;
				}

				int32_t pid = pair.second;

				if (pid >= CONST_SLOT_FIRST && pid <= CONST_SLOT_LAST) {
					player->internalAddThing(pid, item);
					item->startDecaying();
				} else {
					ItemsMap::const_iterator it2 = inventoryItems.find(pid);
					if (it2 == inventoryItems.end()) {
						continue;
					}

					std::shared_ptr<Container> container = it2->second.first->getContainer();
					if (container) {
						container->internalAddThing(item);
						item->startDecaying();
					}
				}

				std::shared_ptr<Container> itemContainer = item->getContainer();
				if (itemContainer) {
					if (!oldProtocol) {
						auto cid = item->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER);
						if (cid > 0) {
							openContainersList.emplace_back(std::make_pair(cid, itemContainer));
						}
					}
					for (bool isLootContainer : { true, false }) {
						auto checkAttribute = isLootContainer ? ItemAttribute_t::QUICKLOOTCONTAINER : ItemAttribute_t::OBTAINCONTAINER;
						if (item->hasAttribute(checkAttribute)) {
							auto flags = item->getAttribute<uint32_t>(checkAttribute);

							for (uint8_t category = OBJECTCATEGORY_FIRST; category <= OBJECTCATEGORY_LAST; category++) {
								if (hasBitSet(1 << category, flags)) {
									player->refreshManagedContainer(static_cast<ObjectCategory_t>(category), itemContainer, isLootContainer, true);
								}
							}
						}
					}
				}
			}
		}

		if (!oldProtocol) {
			std::ranges::sort(openContainersList.begin(), openContainersList.end(), [](const std::pair<uint8_t, std::shared_ptr<Container>> &left, const std::pair<uint8_t, std::shared_ptr<Container>> &right) {
				return left.first < right.first;
			});

			for (auto &it : openContainersList) {
				player->addContainer(it.first - 1, it.second);
				player->onSendContainer(it.second);
			}
		}
	} catch (const std::exception &e) {
		g_logger().error("[IOLoginDataLoad::loadPlayerInventoryItems] - Exceção durante o carregamento do inventário: {}", e.what());
	}
}

void IOLoginDataLoad::loadPlayerStoreInbox(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player nullptr: {}", __FUNCTION__);
		return;
	}

	if (!player->inventory[CONST_SLOT_STORE_INBOX]) {
		player->internalAddThing(CONST_SLOT_STORE_INBOX, Item::CreateItem(ITEM_STORE_INBOX));
	}
}

void IOLoginDataLoad::loadRewardItems(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player nullptr: {}", __FUNCTION__);
		return;
	}

	ItemsMap rewardItems;
	std::ostringstream query;
	query.str(std::string());
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_rewards` WHERE `player_id` = "
		  << player->getGUID() << " ORDER BY `pid`, `sid` ASC";
	if (auto result = Database::getInstance().storeQuery(query.str())) {
		loadItems(rewardItems, result, player);
		bindRewardBag(player, rewardItems);
		insertItemsIntoRewardBag(rewardItems);
	}
}

void IOLoginDataLoad::loadPlayerDepotItems(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	ItemsMap depotItems;
	std::ostringstream query;
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_depotitems` WHERE `player_id` = " << player->getGUID() << " ORDER BY `sid` DESC";
	if ((result = db.storeQuery(query.str()))) {
		loadItems(depotItems, result, player);
		for (ItemsMap::const_reverse_iterator it = depotItems.rbegin(), end = depotItems.rend(); it != end; ++it) {
			const std::pair<std::shared_ptr<Item>, int32_t> &pair = it->second;
			std::shared_ptr<Item> item = pair.first;

			int32_t pid = pair.second;
			if (pid >= 0 && pid < 100) {
				std::shared_ptr<DepotChest> depotChest = player->getDepotChest(pid, true);
				if (depotChest) {
					depotChest->internalAddThing(item);
					item->startDecaying();
				}
			} else {
				ItemsMap::const_iterator it2 = depotItems.find(pid);
				if (it2 == depotItems.end()) {
					continue;
				}

				std::shared_ptr<Container> container = it2->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					item->startDecaying();
				}
			}
		}
	}
}

void IOLoginDataLoad::loadPlayerInboxItems(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `pid`, `sid`, `itemtype`, `count`, `attributes` FROM `player_inboxitems` WHERE `player_id` = " << player->getGUID() << " ORDER BY `sid` DESC";
	if ((result = db.storeQuery(query.str()))) {
		ItemsMap inboxItems;
		loadItems(inboxItems, result, player);

		for (ItemsMap::const_reverse_iterator it = inboxItems.rbegin(), end = inboxItems.rend(); it != end; ++it) {
			const std::pair<std::shared_ptr<Item>, int32_t> &pair = it->second;
			std::shared_ptr<Item> item = pair.first;
			int32_t pid = pair.second;
			if (pid >= 0 && pid < 100) {
				player->getInbox()->internalAddThing(item);
				item->startDecaying();
			} else {
				ItemsMap::const_iterator it2 = inboxItems.find(pid);
				if (it2 == inboxItems.end()) {
					continue;
				}

				std::shared_ptr<Container> container = it2->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					item->startDecaying();
				}
			}
		}
	}
}

void IOLoginDataLoad::loadPlayerStorageMap(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addStorageValue(result->getU32("key"), result->getI64("value"), true);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerVip(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	uint32_t accountId = player->getAccountId();

	Database &db = Database::getInstance();
	std::string query = fmt::format("SELECT `player_id` FROM `account_viplist` WHERE `account_id` = {}", accountId);
	if ((result = db.storeQuery(query))) {
		do {
			player->vip()->addInternal(result->getU32("player_id"));
		} while (result->next());
	}

	query = fmt::format("SELECT `id`, `name`, `customizable` FROM `account_vipgroups` WHERE `account_id` = {}", accountId);
	if ((result = db.storeQuery(query))) {
		do {
			player->vip()->addGroupInternal(
				result->getU8("id"),
				result->getString("name"),
				result->getU8("customizable") == 0 ? false : true
			);
		} while (result->next());
	}

	query = fmt::format("SELECT `player_id`, `vipgroup_id` FROM `account_vipgrouplist` WHERE `account_id` = {}", accountId);
	if ((result = db.storeQuery(query))) {
		do {
			player->vip()->addGuidToGroupInternal(
				result->getU8("vipgroup_id"),
				result->getU32("player_id")
			);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerPreyClass(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	if (g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__)) {
		Database &db = Database::getInstance();
		std::ostringstream query;
		query << "SELECT * FROM `player_prey` WHERE `player_id` = " << player->getGUID();
		if (result = db.storeQuery(query.str())) {
			do {
				auto slot = std::make_unique<PreySlot>(static_cast<PreySlot_t>(result->getU16("slot")));
				auto state = static_cast<PreyDataState_t>(result->getU16("state"));
				if (slot->id == PreySlot_Two && state == PreyDataState_Locked) {
					if (!player->isPremium()) {
						slot->state = PreyDataState_Locked;
					} else {
						slot->state = PreyDataState_Selection;
					}
				} else {
					slot->state = state;
				}
				slot->selectedRaceId = result->getU16("raceid");
				slot->option = static_cast<PreyOption_t>(result->getU16("option"));
				slot->bonus = static_cast<PreyBonus_t>(result->getU16("bonus_type"));
				slot->bonusRarity = static_cast<uint8_t>(result->getU16("bonus_rarity"));
				slot->bonusPercentage = result->getU16("bonus_percentage");
				slot->bonusTimeLeft = result->getU16("bonus_time");
				slot->freeRerollTimeStamp = result->getI64("free_reroll");

				auto preyStream = result->getStream("monster_list");
				PropStream propPreyStream(preyStream);
				uint16_t raceId;
				while (propPreyStream.readU16(raceId)) {
					slot->raceIdList.push_back(raceId);
				}

				player->setPreySlotClass(slot);
			} while (result->next());
		}
	}
}

void IOLoginDataLoad::loadPlayerTaskHuntingClass(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
		Database &db = Database::getInstance();
		std::ostringstream query;
		query << "SELECT * FROM `player_taskhunt` WHERE `player_id` = " << player->getGUID();
		if (result = db.storeQuery(query.str())) {
			do {
				auto slot = std::make_unique<TaskHuntingSlot>(static_cast<PreySlot_t>(result->getU16("slot")));
				auto state = static_cast<PreyTaskDataState_t>(result->getU16("state"));
				if (slot->id == PreySlot_Two && state == PreyTaskDataState_Locked) {
					if (!player->isPremium()) {
						slot->state = PreyTaskDataState_Locked;
					} else {
						slot->state = PreyTaskDataState_Selection;
					}
				} else {
					slot->state = state;
				}
				slot->selectedRaceId = result->getU16("raceid");
				slot->upgrade = result->getBool("upgrade");
				slot->rarity = static_cast<uint8_t>(result->getU16("rarity"));
				slot->currentKills = result->getU16("kills");
				slot->disabledUntilTimeStamp = result->getI64("disabled_time");
				slot->freeRerollTimeStamp = result->getI64("free_reroll");

				auto taskHuntStream = result->getStream("monster_list");
				PropStream propTaskHuntStream(taskHuntStream);
				uint16_t raceId;
				while (propTaskHuntStream.readU16(raceId)) {
					slot->raceIdList.push_back(raceId);
				}

				if (slot->state == PreyTaskDataState_Inactive && slot->disabledUntilTimeStamp < OTSYS_TIME()) {
					slot->state = PreyTaskDataState_Selection;
				}

				player->setTaskHuntingSlotClass(slot);
			} while (result->next());
		}
	}
}

void IOLoginDataLoad::loadPlayerForgeHistory(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	std::ostringstream query;
	query << "SELECT * FROM `forge_history` WHERE `player_id` = " << player->getGUID();
	if (result = Database::getInstance().storeQuery(query.str())) {
		do {
			auto actionEnum = magic_enum::enum_value<ForgeAction_t>(result->getU16("action_type"));
			ForgeHistory history;
			history.actionType = actionEnum;
			history.description = result->getString("description");
			history.createdAt = result->getTime("done_at");
			history.success = result->getBool("is_success");
			player->setForgeHistory(history);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerBosstiary(std::shared_ptr<Player> player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player or Result nullptr: {}", __FUNCTION__);
		return;
	}

	std::ostringstream query;
	query << "SELECT * FROM `player_bosstiary` WHERE `player_id` = " << player->getGUID();
	if (result = Database::getInstance().storeQuery(query.str())) {
		do {
			player->setSlotBossId(1, result->getU16("bossIdSlotOne"));
			player->setSlotBossId(2, result->getU16("bossIdSlotTwo"));
			player->setRemoveBossTime(result->getU8("removeTimes"));

			// Tracker
			auto attributesTracker = result->getStream("tracker");
			PropStream stream(attributesTracker);
			uint16_t bossid;
			while (stream.readU16(bossid)) {
				const auto monsterType = g_monsters().getMonsterTypeByRaceId(bossid, true);
				if (!monsterType) {
					continue;
				}

				player->addMonsterToCyclopediaTrackerList(monsterType, true, false);
			}
		} while (result->next());
	}
}

void IOLoginDataLoad::bindRewardBag(std::shared_ptr<Player> player, ItemsMap &rewardItemsMap) {
	if (!player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player nullptr: {}", __FUNCTION__);
		return;
	}

	for (auto &[id, itemPair] : rewardItemsMap) {
		const auto [item, pid] = itemPair;
		if (pid == 0) {
			auto reward = player->getReward(item->getAttribute<uint64_t>(ItemAttribute_t::DATE), true);
			if (reward) {
				itemPair = std::pair<std::shared_ptr<Item>, int32_t>(reward->getItem(), player->getRewardChest()->getID());
			}
		} else {
			break;
		}
	}
}

void IOLoginDataLoad::insertItemsIntoRewardBag(const ItemsMap &rewardItemsMap) {
	for (const auto &it : std::views::reverse(rewardItemsMap)) {
		const std::pair<std::shared_ptr<Item>, int32_t> &pair = it.second;
		std::shared_ptr<Item> item = pair.first;
		int32_t pid = pair.second;
		if (pid == 0) {
			break;
		}

		ItemsMap::const_iterator it2 = rewardItemsMap.find(pid);
		if (it2 == rewardItemsMap.end()) {
			continue;
		}

		std::shared_ptr<Container> container = it2->second.first->getContainer();
		if (container) {
			container->internalAddThing(item);
		}
	}
}

void IOLoginDataLoad::loadPlayerInitializeSystem(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player nullptr: {}", __FUNCTION__);
		return;
	}

	// Wheel loading
	player->wheel()->loadDBPlayerSlotPointsOnLogin();
	player->wheel()->initializePlayerData();

	player->achiev()->loadUnlockedAchievements();
	player->badge()->checkAndUpdateNewBadges();
	player->title()->checkAndUpdateNewTitles();
	player->cyclopedia()->loadSummaryData();

	player->initializePrey();
	player->initializeTaskHunting();
}

void IOLoginDataLoad::loadPlayerUpdateSystem(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::loadPlayer] - Player nullptr: {}", __FUNCTION__);
		return;
	}

	player->updateBaseSpeed();
	player->updateInventoryWeight();
	player->updateItemsLight(true);
}
