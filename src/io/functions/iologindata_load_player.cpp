/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/functions/iologindata_load_player.hpp"

#include "account/account.hpp"
#include "config/configmanager.hpp"
#include "creatures/combat/condition.hpp"
#include "database/database.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "enums/account_coins.hpp"
#include "enums/account_errors.hpp"
#include "enums/object_category.hpp"
#include "game/game.hpp"
#include "io/ioguild.hpp"
#include "io/ioprey.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/containers/rewards/rewardchest.hpp"
#include "creatures/players/player.hpp"
#include "utils/tools.hpp"

void IOLoginDataLoad::loadItems(ItemsMap &itemsMap, const DBResult_ptr &result, const std::shared_ptr<Player> &player) {
	try {
		do {
			auto sid = result->getNumber<uint32_t>("sid");
			auto pid = result->getNumber<uint32_t>("pid");
			auto type = result->getNumber<uint16_t>("itemtype");
			auto count = result->getNumber<uint16_t>("count");
			unsigned long attrSize;
			const char* attr = result->getStream("attributes", attrSize);
			PropStream propStream;
			propStream.init(attr, attrSize);

			try {
				const auto &item = Item::CreateItem(type, count);
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

bool IOLoginDataLoad::preLoadPlayer(const std::shared_ptr<Player> &player, const std::string &name) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id`, `account_id`, `group_id`, `deletion` FROM `players` WHERE `name` = " << db.escapeString(name);
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	if (result->getNumber<uint64_t>("deletion") != 0) {
		return false;
	}

	player->setGUID(result->getNumber<uint32_t>("id"));
	const auto &group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"));
	if (!group) {
		g_logger().error("Player {} has group id {} which doesn't exist", player->name, result->getNumber<uint16_t>("group_id"));
		return false;
	}
	player->setGroup(group);

	auto accountId = result->getNumber<uint32_t>("account_id");
	if (!player->setAccount(accountId)) {
		g_logger().error("Player {} has account id {} which doesn't exist", player->name, accountId);
		return false;
	}

	auto [coins, error] = player->account->getCoins(CoinType::Normal);
	if (error != AccountErrors_t::Ok) {
		g_logger().error("Failed to get coins for player {}, error {}", player->name, static_cast<uint8_t>(error));
		return false;
	}

	player->coinBalance = coins;

	auto [transferableCoins, errorT] = player->account->getCoins(CoinType::Transferable);
	if (errorT != AccountErrors_t::Ok) {
		g_logger().error("Failed to get transferable coins for player {}, error {}", player->name, static_cast<uint8_t>(errorT));
		return false;
	}

	player->coinTransferableBalance = transferableCoins;

	uint32_t premiumDays = player->getAccount()->getPremiumRemainingDays();
	uint32_t premiumDaysPurchased = player->getAccount()->getPremiumDaysPurchased();

	player->loyaltyPoints = player->getAccount()->getAccountAgeInDays() * g_configManager().getNumber(LOYALTY_POINTS_PER_CREATION_DAY)
		+ (premiumDaysPurchased - premiumDays) * g_configManager().getNumber(LOYALTY_POINTS_PER_PREMIUM_DAY_SPENT)
		+ premiumDaysPurchased * g_configManager().getNumber(LOYALTY_POINTS_PER_PREMIUM_DAY_PURCHASED);

	return true;
}

bool IOLoginDataLoad::loadPlayerBasicInfo(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return false;
	}

	auto vocationId = result->getNumber<uint16_t>("vocation");
	if (!player->setVocation(vocationId)) {
		g_logger().error("Can't set vocation, player {} has vocation id {} which doesn't exist", player->name, vocationId);
		return false;
	}

	player->setGUID(result->getNumber<uint32_t>("id"));
	player->name = result->getString("name");

	if (!player->getAccount()) {
		player->setAccount(result->getNumber<uint32_t>("account_id"));
	}

	const auto &group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"));
	if (!group) {
		g_logger().error("Player {} has group id {} which doesn't exist", player->name, result->getNumber<uint16_t>("group_id"));
		return false;
	}
	player->setGroup(group);

	player->setBankBalance(result->getNumber<uint64_t>("balance"));
	player->quickLootFallbackToMainContainer = result->getNumber<bool>("quickloot_fallback");
	player->setSex(static_cast<PlayerSex_t>(result->getNumber<uint16_t>("sex")));
	player->setPronoun(static_cast<PlayerPronoun_t>(result->getNumber<uint16_t>("pronoun")));
	player->level = std::max<uint32_t>(1, result->getNumber<uint32_t>("level"));
	player->soul = static_cast<uint8_t>(result->getNumber<unsigned short>("soul"));
	player->capacity = result->getNumber<uint32_t>("cap") * 100;
	player->mana = result->getNumber<uint32_t>("mana");
	player->manaMax = result->getNumber<uint32_t>("manamax");
	player->magLevel = result->getNumber<uint32_t>("maglevel");
	uint64_t nextManaCount = player->vocation->getReqMana(player->magLevel + 1);
	auto manaSpent = result->getNumber<uint64_t>("manaspent");
	if (manaSpent > nextManaCount) {
		manaSpent = 0;
	}
	player->manaSpent = manaSpent;
	player->magLevelPercent = Player::getPercentLevel(player->manaSpent, nextManaCount);
	player->health = result->getNumber<int32_t>("health");
	player->healthMax = result->getNumber<int32_t>("healthmax");
	player->isDailyReward = static_cast<uint8_t>(result->getNumber<uint16_t>("isreward"));
	player->loginPosition.x = result->getNumber<uint16_t>("posx");
	player->loginPosition.y = result->getNumber<uint16_t>("posy");
	player->loginPosition.z = static_cast<uint8_t>(result->getNumber<uint16_t>("posz"));
	player->addPreyCards(result->getNumber<uint64_t>("prey_wildcard"));
	player->addTaskHuntingPoints(result->getNumber<uint64_t>("task_points"));
	player->addForgeDusts(result->getNumber<uint64_t>("forge_dusts"));
	player->addForgeDustLevel(result->getNumber<uint64_t>("forge_dust_level"));
	player->setRandomMount(static_cast<uint8_t>(result->getNumber<uint16_t>("randomize_mount")));
	player->addBossPoints(result->getNumber<uint32_t>("boss_points"));
	player->lastLoginSaved = result->getNumber<time_t>("lastlogin");
	player->lastLogout = result->getNumber<time_t>("lastlogout");
	player->offlineTrainingTime = result->getNumber<int32_t>("offlinetraining_time") * 1000;
	auto skill = result->getInt8FromString(result->getString("offlinetraining_skill"), __FUNCTION__);
	player->setOfflineTrainingSkill(skill);
	const auto &town = g_game().map.towns.getTown(result->getNumber<uint32_t>("town_id"));
	if (!town) {
		g_logger().error("Player {} has invalid town id {}. Attempting to set the correct town.", player->name, result->getNumber<uint16_t>("town_id"));

		const auto &thaisTown = g_game().map.towns.getTown("Thais");
		if (thaisTown) {
			player->town = thaisTown;
			g_logger().warn("Assigned town 'Thais' to player {}", player->name);
		} else {
			for (const auto &[townId, currentTown] : g_game().map.towns.getTowns()) {
				if (townId != 0 && currentTown) {
					player->town = currentTown;
					g_logger().warn("Assigned first valid town {} (id: {}) to player {}", currentTown->getName(), townId, player->name);
				}
			}

			if (!player->town) {
				g_logger().error("Player {} has invalid town id {}. No valid town found to assign.", player->name, result->getNumber<uint16_t>("town_id"));
				return false;
			}
		}
	} else {
		player->town = town;
	}

	const Position &loginPos = player->loginPosition;
	if (loginPos.x == 0 && loginPos.y == 0 && loginPos.z == 0) {
		player->loginPosition = player->getTemplePosition();
	}

	player->staminaMinutes = result->getNumber<uint16_t>("stamina");
	player->setXpBoostPercent(result->getNumber<uint16_t>("xpboost_value"));
	player->setXpBoostTime(result->getNumber<uint16_t>("xpboost_stamina"));

	player->setManaShield(result->getNumber<uint32_t>("manashield"));
	player->setMaxManaShield(result->getNumber<uint32_t>("max_manashield"));

	player->setMarriageSpouse(result->getNumber<int32_t>("marriage_spouse"));
	return true;
}

void IOLoginDataLoad::loadPlayerExperience(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	auto experience = result->getNumber<uint64_t>("experience");
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

void IOLoginDataLoad::loadPlayerBlessings(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	for (int i = 1; i <= 8; i++) {
		player->addBlessing(static_cast<uint8_t>(i), static_cast<uint8_t>(result->getNumber<uint16_t>(fmt::format("blessings{}", i))));
	}
}

void IOLoginDataLoad::loadPlayerConditions(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	unsigned long attrSize;
	const char* attr = result->getStream("conditions", attrSize);
	PropStream propStream;
	propStream.init(attr, attrSize);

	auto condition = Condition::createCondition(propStream);
	while (condition) {
		if (condition->unserialize(propStream)) {
			player->storedConditionList.emplace_back(condition);
		}
		condition = Condition::createCondition(propStream);
	}
}

void IOLoginDataLoad::loadPlayerAnimusMastery(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	unsigned long attrSize;
	const char* attr = result->getStream("animus_mastery", attrSize);
	PropStream propStream;
	propStream.init(attr, attrSize);

	player->animusMastery().unserialize(propStream);
}

void IOLoginDataLoad::loadPlayerDefaultOutfit(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	player->defaultOutfit.lookType = result->getNumber<uint16_t>("looktype");
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && player->defaultOutfit.lookType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookType)) {
		g_logger().warn("[{}] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", __FUNCTION__, player->defaultOutfit.lookType);
		return;
	}

	player->defaultOutfit.lookHead = static_cast<uint8_t>(result->getNumber<uint16_t>("lookhead"));
	player->defaultOutfit.lookBody = static_cast<uint8_t>(result->getNumber<uint16_t>("lookbody"));
	player->defaultOutfit.lookLegs = static_cast<uint8_t>(result->getNumber<uint16_t>("looklegs"));
	player->defaultOutfit.lookFeet = static_cast<uint8_t>(result->getNumber<uint16_t>("lookfeet"));
	player->defaultOutfit.lookAddons = static_cast<uint8_t>(result->getNumber<uint16_t>("lookaddons"));
	player->defaultOutfit.lookMountHead = static_cast<uint8_t>(result->getNumber<uint16_t>("lookmounthead"));
	player->defaultOutfit.lookMountBody = static_cast<uint8_t>(result->getNumber<uint16_t>("lookmountbody"));
	player->defaultOutfit.lookMountLegs = static_cast<uint8_t>(result->getNumber<uint16_t>("lookmountlegs"));
	player->defaultOutfit.lookMountFeet = static_cast<uint8_t>(result->getNumber<uint16_t>("lookmountfeet"));
	player->defaultOutfit.lookFamiliarsType = result->getNumber<uint16_t>("lookfamiliarstype");

	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && player->defaultOutfit.lookFamiliarsType != 0 && !g_game().isLookTypeRegistered(player->defaultOutfit.lookFamiliarsType)) {
		g_logger().warn("[{}] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", __FUNCTION__, player->defaultOutfit.lookFamiliarsType);
		return;
	}

	player->currentOutfit = player->defaultOutfit;
}

void IOLoginDataLoad::loadPlayerSkullSystem(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		const time_t skullSeconds = result->getNumber<time_t>("skulltime") - time(nullptr);
		if (skullSeconds > 0) {
			// ensure that we round up the number of ticks
			player->skullTicks = (skullSeconds + 2);

			auto skull = result->getNumber<uint16_t>("skull");
			if (skull == SKULL_RED) {
				player->skull = SKULL_RED;
			} else if (skull == SKULL_BLACK) {
				player->skull = SKULL_BLACK;
			}
		}
	}
}

void IOLoginDataLoad::loadPlayerSkill(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	auto vocationPtr = player->getVocation();
	if (!vocationPtr) {
		return;
	}

	static const std::array<std::string, 13> skillNames = { "skill_fist", "skill_club", "skill_sword", "skill_axe", "skill_dist", "skill_shielding", "skill_fishing", "skill_critical_hit_chance", "skill_critical_hit_damage", "skill_life_leech_chance", "skill_life_leech_amount", "skill_mana_leech_chance", "skill_mana_leech_amount" };
	static const std::array<std::string, 13> skillNameTries = { "skill_fist_tries", "skill_club_tries", "skill_sword_tries", "skill_axe_tries", "skill_dist_tries", "skill_shielding_tries", "skill_fishing_tries", "skill_critical_hit_chance_tries", "skill_critical_hit_damage_tries", "skill_life_leech_chance_tries", "skill_life_leech_amount_tries", "skill_mana_leech_chance_tries", "skill_mana_leech_amount_tries" };
	for (size_t i = 0; i < skillNames.size(); ++i) {
		auto skillLevel = result->getNumber<uint16_t>(skillNames[i]);
		auto skillTries = result->getNumber<uint64_t>(skillNameTries[i]);
		uint64_t nextSkillTries = vocationPtr->getReqSkillTries(static_cast<uint8_t>(i), skillLevel + 1);
		if (skillTries > nextSkillTries) {
			skillTries = 0;
		}

		player->skills[i].level = skillLevel;
		player->skills[i].tries = skillTries;
		player->skills[i].percent = Player::getPercentLevel(skillTries, nextSkillTries);
	}
}

void IOLoginDataLoad::loadPlayerKills(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `player_id`, `time`, `target`, `unavenged` FROM `player_kills` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			auto killTime = result->getNumber<time_t>("time");
			if ((time(nullptr) - killTime) <= g_configManager().getNumber(FRAG_TIME)) {
				player->unjustifiedKills.emplace_back(result->getNumber<uint32_t>("target"), killTime, result->getNumber<bool>("unavenged"));
			}
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerGuild(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `guild_id`, `rank_id`, `nick` FROM `guild_membership` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		auto guildId = result->getNumber<uint32_t>("guild_id");
		auto playerRankId = result->getNumber<uint32_t>("rank_id");
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
					guild->addRank(result->getNumber<uint32_t>("id"), result->getString("name"), static_cast<uint8_t>(result->getNumber<uint16_t>("level")));
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
				guild->setMemberCount(result->getNumber<uint32_t>("members"));
			}
		}
	}
}

void IOLoginDataLoad::loadPlayerStashItems(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `item_count`, `item_id`  FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addItemOnStash(result->getNumber<uint16_t>("item_id"), result->getNumber<uint32_t>("item_count"));
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerBestiaryCharms(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `player_charms` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		player->charmPoints = result->getNumber<uint32_t>("charm_points");
		player->minorCharmEchoes = result->getNumber<uint32_t>("minor_charm_echoes");
		player->maxCharmPoints = result->getNumber<uint32_t>("max_charm_points");
		player->maxMinorCharmEchoes = result->getNumber<uint32_t>("max_minor_charm_echoes");
		player->charmExpansion = result->getNumber<bool>("charm_expansion");
		player->UsedRunesBit = result->getNumber<int32_t>("UsedRunesBit");
		player->UnlockedRunesBit = result->getNumber<int32_t>("UnlockedRunesBit");

		unsigned long size;
		const auto attribute = result->getStream("charms", size);
		PropStream charmsStream;
		charmsStream.init(attribute, size);
		for (uint8_t id = magic_enum::enum_value<charmRune_t>(1); id <= magic_enum::enum_count<charmRune_t>(); id++) {
			uint16_t raceId;
			uint8_t tier;

			if (!charmsStream.read<uint16_t>(raceId) || !charmsStream.read<uint8_t>(tier)) {
				continue;
			}

			player->charmsArray[id].raceId = raceId;
			player->charmsArray[id].tier = tier;

			g_logger().debug("Player {} loaded charm Id {} with raceId {} and tier {}", player->name, id, raceId, tier);
		}

		unsigned long attrBestSize;
		const char* Bestattr = result->getStream("tracker list", attrBestSize);
		PropStream propBestStream;
		propBestStream.init(Bestattr, attrBestSize);

		uint16_t monsterRaceId;
		while (propBestStream.read<uint16_t>(monsterRaceId)) {
			const auto monsterType = g_monsters().getMonsterTypeByRaceId(monsterRaceId);
			if (monsterType) {
				player->addMonsterToCyclopediaTrackerList(monsterType, false, false);
			}
		}
	} else {
		query.str("");
		query << "INSERT INTO `player_charms` (`player_id`) VALUES (" << player->getGUID() << ')';
		Database::getInstance().executeQuery(query.str());
	}
}

void IOLoginDataLoad::loadPlayerInstantSpellList(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
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

void IOLoginDataLoad::loadPlayerInventoryItems(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	bool oldProtocol = g_configManager().getBoolean(OLD_PROTOCOL) && player->getProtocolVersion() < 1200;
	auto query = fmt::format("SELECT pid, sid, itemtype, count, attributes FROM player_items WHERE player_id = {} ORDER BY sid DESC", player->getGUID());

	ItemsMap inventoryItems;
	std::vector<std::pair<uint8_t, std::shared_ptr<Container>>> openContainersList;
	std::vector<std::shared_ptr<Item>> itemsToStartDecaying;

	try {
		if ((result = g_database().storeQuery(query))) {
			loadItems(inventoryItems, result, player);

			for (auto it = inventoryItems.rbegin(), end = inventoryItems.rend(); it != end; ++it) {
				const std::pair<std::shared_ptr<Item>, int32_t> &pair = it->second;
				const auto &item = pair.first;
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

					const std::shared_ptr<Container> &container = it2->second.first->getContainer();
					if (container) {
						container->internalAddThing(item);
						// Here, the sub-containers do not yet have a parent, since the main backpack has not yet been added to the player, so we need to postpone
						itemsToStartDecaying.emplace_back(item);
					}
				}

				const std::shared_ptr<Container> &itemContainer = item->getContainer();
				if (itemContainer) {
					if (!oldProtocol) {
						auto cid = item->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER);
						if (cid > 0) {
							openContainersList.emplace_back(cid, itemContainer);
						}
					}
					for (const bool isLootContainer : { true, false }) {
						const auto checkAttribute = isLootContainer ? ItemAttribute_t::QUICKLOOTCONTAINER : ItemAttribute_t::OBTAINCONTAINER;
						if (item->hasAttribute(checkAttribute)) {
							const auto flags = item->getAttribute<uint32_t>(checkAttribute);

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

		// Now that all items and containers have been added and parent chain is established, start decay
		for (const auto &item : itemsToStartDecaying) {
			item->startDecaying();
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
		g_logger().error("[IOLoginDataLoad::loadPlayerInventoryItems] - Exception during inventory loading: {}", e.what());
	}
}

void IOLoginDataLoad::loadPlayerStoreInbox(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
		return;
	}

	if (!player->inventory[CONST_SLOT_STORE_INBOX]) {
		player->internalAddThing(CONST_SLOT_STORE_INBOX, Item::CreateItem(ITEM_STORE_INBOX));
	}
}

void IOLoginDataLoad::loadRewardItems(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
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

void IOLoginDataLoad::loadPlayerDepotItems(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	ItemsMap depotItems;
	std::vector<std::shared_ptr<Item>> itemsToStartDecaying;
	auto query = fmt::format("SELECT pid, sid, itemtype, count, attributes FROM player_depotitems WHERE player_id = {} ORDER BY sid DESC", player->getGUID());
	if ((result = g_database().storeQuery(query))) {
		loadItems(depotItems, result, player);
		for (auto it = depotItems.rbegin(), end = depotItems.rend(); it != end; ++it) {
			const std::pair<std::shared_ptr<Item>, int32_t> &pair = it->second;
			const auto &item = pair.first;
			if (!item) {
				continue;
			}

			int32_t pid = pair.second;
			if (pid >= 0 && pid < 100) {
				const std::shared_ptr<DepotChest> &depotChest = player->getDepotChest(pid, true);
				if (depotChest) {
					depotChest->internalAddThing(item);
					item->startDecaying();
				}
			} else {
				auto depotIt = depotItems.find(pid);
				if (depotIt == depotItems.end()) {
					continue;
				}

				const std::shared_ptr<Container> &container = depotIt->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					// Here, the sub-containers do not yet have a parent, since the main backpack has not yet been added to the player, so we need to postpone
					itemsToStartDecaying.emplace_back(item);
				}
			}
		}
	}

	// Now that all items and containers have been added and parent chain is established, start decay
	for (const auto &item : itemsToStartDecaying) {
		item->startDecaying();
	}
}

void IOLoginDataLoad::loadPlayerInboxItems(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	std::vector<std::shared_ptr<Item>> itemsToStartDecaying;
	auto query = fmt::format("SELECT pid, sid, itemtype, count, attributes FROM player_inboxitems WHERE player_id = {} ORDER BY sid DESC", player->getGUID());
	if ((result = g_database().storeQuery(query))) {
		ItemsMap inboxItems;
		loadItems(inboxItems, result, player);

		const auto &playerInbox = player->getInbox();
		if (!playerInbox) {
			g_logger().warn("[{}] - Player inbox nullptr", __FUNCTION__);
			return;
		}

		for (const auto &it : std::ranges::reverse_view(inboxItems)) {
			const std::pair<std::shared_ptr<Item>, int32_t> &pair = it.second;
			const auto &item = pair.first;
			if (!item) {
				continue;
			}

			int32_t pid = pair.second;
			if (pid >= 0 && pid < 100) {
				playerInbox->internalAddThing(item);
				item->startDecaying();
			} else {
				auto inboxIt = inboxItems.find(pid);
				if (inboxIt == inboxItems.end()) {
					continue;
				}

				const std::shared_ptr<Container> &container = inboxIt->second.first->getContainer();
				if (container) {
					container->internalAddThing(item);
					itemsToStartDecaying.emplace_back(item);
				}
			}
		}
	}

	// Now that all items and containers have been added and parent chain is established, start decay
	for (const auto &item : itemsToStartDecaying) {
		item->startDecaying();
	}
}

void IOLoginDataLoad::loadPlayerStorageMap(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = " << player->getGUID();
	if ((result = db.storeQuery(query.str()))) {
		do {
			player->addStorageValue(result->getNumber<uint32_t>("key"), result->getNumber<int32_t>("value"), true);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerVip(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	uint32_t accountId = player->getAccountId();

	Database &db = Database::getInstance();
	std::string query = fmt::format("SELECT `player_id` FROM `account_viplist` WHERE `account_id` = {}", accountId);
	if ((result = db.storeQuery(query))) {
		do {
			player->vip().addInternal(result->getNumber<uint32_t>("player_id"));
		} while (result->next());
	}

	query = fmt::format("SELECT `id`, `name`, `customizable` FROM `account_vipgroups` WHERE `account_id` = {}", accountId);
	if ((result = db.storeQuery(query))) {
		do {
			player->vip().addGroupInternal(
				result->getNumber<uint8_t>("id"),
				result->getString("name"),
				result->getNumber<uint8_t>("customizable") == 0 ? false : true
			);
		} while (result->next());
	}

	query = fmt::format("SELECT `player_id`, `vipgroup_id` FROM `account_vipgrouplist` WHERE `account_id` = {}", accountId);
	if ((result = db.storeQuery(query))) {
		do {
			player->vip().addGuidToGroupInternal(
				result->getNumber<uint8_t>("vipgroup_id"),
				result->getNumber<uint32_t>("player_id")
			);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerPreyClass(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	if (g_configManager().getBoolean(PREY_ENABLED)) {
		Database &db = Database::getInstance();
		std::ostringstream query;
		query << "SELECT * FROM `player_prey` WHERE `player_id` = " << player->getGUID();
		if ((result = db.storeQuery(query.str()))) {
			do {
				auto slot = std::make_unique<PreySlot>(static_cast<PreySlot_t>(result->getNumber<uint16_t>("slot")));
				auto state = static_cast<PreyDataState_t>(result->getNumber<uint16_t>("state"));
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
}

void IOLoginDataLoad::loadPlayerTaskHuntingClass(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result || !player) {
		g_logger().warn("[{}] - Player or Result nullptr", __FUNCTION__);
		return;
	}

	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		Database &db = Database::getInstance();
		std::ostringstream query;
		query << "SELECT * FROM `player_taskhunt` WHERE `player_id` = " << player->getGUID();
		if ((result = db.storeQuery(query.str()))) {
			do {
				auto slot = std::make_unique<TaskHuntingSlot>(static_cast<PreySlot_t>(result->getNumber<uint16_t>("slot")));
				auto state = static_cast<PreyTaskDataState_t>(result->getNumber<uint16_t>("state"));
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
}

void IOLoginDataLoad::loadPlayerForgeHistory(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
		return;
	}

	auto playerGUID = player->getGUID();

	auto query = fmt::format(
		"SELECT id, action_type, description, done_at, is_success FROM forge_history WHERE player_id = {}",
		playerGUID
	);
	if ((result = Database::getInstance().storeQuery(query))) {
		do {
			auto actionEnum = magic_enum::enum_value<ForgeAction_t>(result->getNumber<uint16_t>("action_type"));
			ForgeHistory history;
			history.actionType = actionEnum;
			history.description = result->getString("description");
			history.createdAt = result->getNumber<time_t>("done_at");
			history.success = result->getNumber<bool>("is_success");
			player->setForgeHistory(history);
		} while (result->next());
	}
}

void IOLoginDataLoad::loadPlayerBosstiary(const std::shared_ptr<Player> &player, DBResult_ptr result) {
	if (!result) {
		g_logger().warn("[{}] - Result nullptr", __FUNCTION__);
		return;
	}

	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
		return;
	}

	std::ostringstream query;
	query << "SELECT * FROM `player_bosstiary` WHERE `player_id` = " << player->getGUID();
	if ((result = Database::getInstance().storeQuery(query.str()))) {
		do {
			player->setSlotBossId(1, result->getNumber<uint16_t>("bossIdSlotOne"));
			player->setSlotBossId(2, result->getNumber<uint16_t>("bossIdSlotTwo"));
			player->setRemoveBossTime(result->getU8FromString(result->getString("removeTimes"), __FUNCTION__));

			// Tracker
			unsigned long size;
			const char* chars = result->getStream("tracker", size);
			PropStream stream;
			stream.init(chars, size);
			uint16_t bossid;
			while (stream.read<uint16_t>(bossid)) {
				const auto monsterType = g_monsters().getMonsterTypeByRaceId(bossid, true);
				if (!monsterType) {
					continue;
				}

				player->addMonsterToCyclopediaTrackerList(monsterType, true, false);
			}
		} while (result->next());
	}
}

void IOLoginDataLoad::bindRewardBag(const std::shared_ptr<Player> &player, ItemsMap &rewardItemsMap) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
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
		const auto &item = pair.first;
		if (!item) {
			continue;
		}

		int32_t pid = pair.second;
		if (pid == 0) {
			break;
		}

		auto rewardIt = rewardItemsMap.find(pid);
		if (rewardIt == rewardItemsMap.end()) {
			continue;
		}

		const std::shared_ptr<Container> &container = rewardIt->second.first->getContainer();
		if (container) {
			container->internalAddThing(item);
		}
	}
}

void IOLoginDataLoad::loadPlayerInitializeSystem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
		return;
	}

	// Wheel loading
	player->wheel().loadDBPlayerSlotPointsOnLogin();
	player->wheel().loadRevealedGems();
	player->wheel().loadActiveGems();
	player->wheel().loadKVModGrades();
	player->wheel().loadKVScrolls();
	player->wheel().initializePlayerData();

	player->achiev().loadUnlockedAchievements();
	player->badge().checkAndUpdateNewBadges();
	player->title().checkAndUpdateNewTitles();
	player->cyclopedia().loadSummaryData();

	player->initializePrey();
	player->initializeTaskHunting();
}

void IOLoginDataLoad::loadPlayerUpdateSystem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
		return;
	}

	player->updateBaseSpeed();
	player->updateInventoryWeight();
	player->updateItemsLight(true);
}
