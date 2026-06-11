/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/functions/iologindata_save_player.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/animus_mastery/animus_mastery.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/components/player_storage.hpp"
#include "game/game.hpp"
#include "io/ioprey.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "items/containers/rewards/reward.hpp"
#include "creatures/players/player.hpp"
#include "io/player_storage_repository.hpp"
#include "kv/kv.hpp"

#include <iterator>

#ifndef USE_PRECOMPILED_HEADERS
	#include <fmt/format.h>
	#include <string_view>
	#include <utility>
#endif

bool IOLoginDataSave::saveItems(const std::shared_ptr<Player> &player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &propWriteStream) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	const Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(256);
	auto rowOutput = std::back_inserter(rowBuffer);

	// Initialize variables
	using ContainerBlock = std::pair<std::shared_ptr<Container>, int32_t>;
	std::list<ContainerBlock> queue;
	int32_t runningId = 100;

	// Loop through each item in itemList
	const auto &openContainers = player->getOpenContainers();
	for (const auto &it : itemList) {
		const auto &item = it.second;
		if (!item) {
			continue;
		}

		int32_t pid = it.first;

		++runningId;

		// Update container attributes if necessary
		if (const std::shared_ptr<Container> &container = item->getContainer()) {
			if (!container) {
				continue;
			}

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

			// Add container to queue
			queue.emplace_back(container, runningId);
		}

		// Serialize item attributes
		propWriteStream.clear();
		item->serializeAttr(propWriteStream);

		size_t attributesSize;
		const char* attributes = propWriteStream.getStream(attributesSize);

		// Build query string and add row
		rowBuffer.clear();
		rowOutput = fmt::format_to(
			rowOutput,
			"{},{},{},{},{},{}",
			playerGuid,
			pid,
			runningId,
			item->getID(),
			item->getSubType(),
			db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize))
		);
		if (!query_insert.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			g_logger().error("Error adding row to query.");
			return false;
		}
	}

	// Loop through containers in queue
	while (!queue.empty()) {
		const ContainerBlock &cb = queue.front();
		const std::shared_ptr<Container> &container = cb.first;
		if (!container) {
			queue.pop_front();
			continue;
		}

		int32_t parentId = cb.second;

		// Loop through items in container
		for (auto &item : container->getItemList()) {
			if (!item) {
				continue;
			}

			++runningId;

			// Update sub-container attributes if necessary
			const auto &subContainer = item->getContainer();
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

			// Serialize item attributes
			propWriteStream.clear();
			item->serializeAttr(propWriteStream);

			size_t attributesSize;
			const char* attributes = propWriteStream.getStream(attributesSize);

			// Build query string and add row
			rowBuffer.clear();
			rowOutput = fmt::format_to(
				rowOutput,
				"{},{},{},{},{},{}",
				playerGuid,
				parentId,
				runningId,
				item->getID(),
				item->getSubType(),
				db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize))
			);
			if (!query_insert.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
				g_logger().error("Error adding row to query for container item.");
				return false;
			}
		}

		// Removes the object after processing everything, avoiding memory usage after freeing
		queue.pop_front();
	}

	// Execute query
	if (!query_insert.execute()) {
		g_logger().error("Error executing query.");
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerFirst(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	if (player->getHealth() <= 0) {
		player->changeHealth(1);
	}

	savePlayerSystems(player);

	savePlayerExivaRestrictions(player);

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();

	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `save` FROM `players` WHERE `id` = {}", playerGuid));
	if (!result) {
		g_logger().warn("[IOLoginData::savePlayer] - Error for select result query from player: {}", player->getName());
		return false;
	}

	if (result->getNumber<uint16_t>("save") == 0) {
		return db.executeQuery(fmt::format("UPDATE `players` SET `lastlogin` = {}, `lastip` = {} WHERE `id` = {}", player->lastLoginSaved, player->lastIP, playerGuid));
	}

	std::string setClause;
	setClause.reserve(4096);
	auto setClauseOutput = std::back_inserter(setClause);

	auto appendColumn = [&setClause, &setClauseOutput]<typename... Args>(std::string_view format, Args &&... args) {
		if (!setClause.empty()) {
			setClause += ", ";
		}
		setClauseOutput = fmt::format_to(setClauseOutput, fmt::runtime(format), std::forward<Args>(args)...);
	};

	appendColumn("`name` = {}", db.escapeString(player->name));
	appendColumn("`level` = {}", player->level);
	appendColumn("`group_id` = {}", player->group->id);
	appendColumn("`vocation` = {}", player->getVocationId());
	appendColumn("`health` = {}", player->health);
	appendColumn("`healthmax` = {}", player->healthMax);
	appendColumn("`experience` = {}", player->experience);
	appendColumn("`lookbody` = {}", static_cast<uint32_t>(player->defaultOutfit.lookBody));
	appendColumn("`lookfeet` = {}", static_cast<uint32_t>(player->defaultOutfit.lookFeet));
	appendColumn("`lookhead` = {}", static_cast<uint32_t>(player->defaultOutfit.lookHead));
	appendColumn("`looklegs` = {}", static_cast<uint32_t>(player->defaultOutfit.lookLegs));
	appendColumn("`looktype` = {}", player->defaultOutfit.lookType);
	appendColumn("`lookaddons` = {}", static_cast<uint32_t>(player->defaultOutfit.lookAddons));
	appendColumn("`lookmountbody` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountBody));
	appendColumn("`lookmountfeet` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountFeet));
	appendColumn("`lookmounthead` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountHead));
	appendColumn("`lookmountlegs` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountLegs));
	appendColumn("`lookfamiliarstype` = {}", player->defaultOutfit.lookFamiliarsType);
	appendColumn("`isreward` = {}", static_cast<uint16_t>(player->isDailyReward));
	appendColumn("`maglevel` = {}", player->magLevel);
	appendColumn("`mana` = {}", player->mana);
	appendColumn("`manamax` = {}", player->manaMax);
	appendColumn("`manaspent` = {}", player->manaSpent);
	appendColumn("`soul` = {}", static_cast<uint16_t>(player->soul));
	if (player->town) {
		appendColumn("`town_id` = {}", player->town->getID());
	}

	const Position &loginPosition = player->getLoginPosition();
	appendColumn("`posx` = {}", loginPosition.getX());
	appendColumn("`posy` = {}", loginPosition.getY());
	appendColumn("`posz` = {}", loginPosition.getZ());

	appendColumn("`prey_wildcard` = {}", player->getPreyCards());
	appendColumn("`task_points` = {}", player->getTaskHuntingPoints());
	appendColumn("`boss_points` = {}", player->getBossPoints());
	appendColumn("`forge_dusts` = {}", player->getForgeDusts());
	appendColumn("`forge_dust_level` = {}", player->getForgeDustLevel());
	appendColumn("`randomize_mount` = {}", static_cast<uint16_t>(player->isRandomMounted()));
	appendColumn("`cap` = {}", (player->capacity / 100));
	appendColumn("`sex` = {}", static_cast<uint16_t>(player->sex));

	if (player->lastLoginSaved != 0) {
		appendColumn("`lastlogin` = {}", player->lastLoginSaved);
	}

	if (player->lastIP != 0) {
		appendColumn("`lastip` = {}", player->lastIP);
	}

	// serialize conditions
	PropWriteStream propWriteStream;
	for (const auto &condition : player->conditions) {
		if (condition->isPersistent()) {
			condition->serialize(propWriteStream);
			propWriteStream.write<uint8_t>(CONDITIONATTR_END);
		}
	}

	size_t attributesSize;
	const char* attributes = propWriteStream.getStream(attributesSize);

	appendColumn("`conditions` = {}", db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize)));

	// serialize animus mastery
	PropWriteStream propAnimusMasteryStream;
	player->animusMastery().serialize(propAnimusMasteryStream);
	size_t animusMasterySize;
	const char* animusMastery = propAnimusMasteryStream.getStream(animusMasterySize);

	appendColumn("`animus_mastery` = {}", db.escapeBlob(animusMastery, static_cast<uint32_t>(animusMasterySize)));

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		int64_t skullTime = 0;

		if (player->skullTicks > 0) {
			auto now = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
			skullTime = now + player->skullTicks;
		}

		appendColumn("`skulltime` = {}", skullTime);

		Skulls_t skull = SKULL_NONE;
		if (player->skull == SKULL_RED) {
			skull = SKULL_RED;
		} else if (player->skull == SKULL_BLACK) {
			skull = SKULL_BLACK;
		}
		appendColumn("`skull` = {}", static_cast<int64_t>(skull));
	}

	appendColumn("`lastlogout` = {}", player->getLastLogout());
	appendColumn("`balance` = {}", player->bankBalance);
	appendColumn("`offlinetraining_time` = {}", player->getOfflineTrainingTime() / 1000);
	appendColumn("`offlinetraining_skill` = {}", player->getOfflineTrainingSkill());
	appendColumn("`stamina` = {}", player->getStaminaMinutes());
	appendColumn("`skill_fist` = {}", player->skills[SKILL_FIST].level);
	appendColumn("`skill_fist_tries` = {}", player->skills[SKILL_FIST].tries);
	appendColumn("`skill_club` = {}", player->skills[SKILL_CLUB].level);
	appendColumn("`skill_club_tries` = {}", player->skills[SKILL_CLUB].tries);
	appendColumn("`skill_sword` = {}", player->skills[SKILL_SWORD].level);
	appendColumn("`skill_sword_tries` = {}", player->skills[SKILL_SWORD].tries);
	appendColumn("`skill_axe` = {}", player->skills[SKILL_AXE].level);
	appendColumn("`skill_axe_tries` = {}", player->skills[SKILL_AXE].tries);
	appendColumn("`skill_dist` = {}", player->skills[SKILL_DISTANCE].level);
	appendColumn("`skill_dist_tries` = {}", player->skills[SKILL_DISTANCE].tries);
	appendColumn("`skill_shielding` = {}", player->skills[SKILL_SHIELD].level);
	appendColumn("`skill_shielding_tries` = {}", player->skills[SKILL_SHIELD].tries);
	appendColumn("`skill_fishing` = {}", player->skills[SKILL_FISHING].level);
	appendColumn("`skill_fishing_tries` = {}", player->skills[SKILL_FISHING].tries);
	appendColumn("`skill_critical_hit_chance` = {}", player->skills[SKILL_CRITICAL_HIT_CHANCE].level);
	appendColumn("`skill_critical_hit_chance_tries` = {}", player->skills[SKILL_CRITICAL_HIT_CHANCE].tries);
	appendColumn("`skill_critical_hit_damage` = {}", player->skills[SKILL_CRITICAL_HIT_DAMAGE].level);
	appendColumn("`skill_critical_hit_damage_tries` = {}", player->skills[SKILL_CRITICAL_HIT_DAMAGE].tries);
	appendColumn("`skill_life_leech_chance` = {}", player->skills[SKILL_LIFE_LEECH_CHANCE].level);
	appendColumn("`skill_life_leech_chance_tries` = {}", player->skills[SKILL_LIFE_LEECH_CHANCE].tries);
	appendColumn("`skill_life_leech_amount` = {}", player->skills[SKILL_LIFE_LEECH_AMOUNT].level);
	appendColumn("`skill_life_leech_amount_tries` = {}", player->skills[SKILL_LIFE_LEECH_AMOUNT].tries);
	appendColumn("`skill_mana_leech_chance` = {}", player->skills[SKILL_MANA_LEECH_CHANCE].level);
	appendColumn("`skill_mana_leech_chance_tries` = {}", player->skills[SKILL_MANA_LEECH_CHANCE].tries);
	appendColumn("`skill_mana_leech_amount` = {}", player->skills[SKILL_MANA_LEECH_AMOUNT].level);
	appendColumn("`skill_mana_leech_amount_tries` = {}", player->skills[SKILL_MANA_LEECH_AMOUNT].tries);
	appendColumn("`manashield` = {}", player->getManaShield());
	appendColumn("`max_manashield` = {}", player->getMaxManaShield());
	appendColumn("`xpboost_value` = {}", player->getXpBoostPercent());
	appendColumn("`xpboost_stamina` = {}", player->getXpBoostTime());
	appendColumn("`quickloot_fallback` = {}", player->quickLootFallbackToMainContainer ? 1 : 0);

	if (!player->isOffline()) {
		auto now = std::chrono::system_clock::now();
		auto lastLoginSaved = std::chrono::system_clock::from_time_t(player->lastLoginSaved);
		appendColumn("`onlinetime` = `onlinetime` + {}", std::chrono::duration_cast<std::chrono::seconds>(now - lastLoginSaved).count());
	}

	for (int i = 1; i <= 8; i++) {
		appendColumn("`blessings{}` = {}", i, static_cast<uint32_t>(player->getBlessingCount(static_cast<uint8_t>(i))));
	}

	if (!db.executeQuery(fmt::format("UPDATE `players` SET {} WHERE `id` = {}", setClause, playerGuid))) {
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerStash(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_stash` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert stashQuery("INSERT INTO `player_stash` (`player_id`,`item_id`,`item_count`) VALUES ");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(48);
	auto rowOutput = std::back_inserter(rowBuffer);
	for (const auto &[itemId, itemCount] : player->getStashItems()) {
		const ItemType &itemType = Item::items[itemId];
		if (itemType.decayTo >= 0 && itemType.decayTime > 0) {
			continue;
		}

		auto wareId = itemType.wareId;
		if (wareId > 0 && wareId != itemType.id) {
			g_logger().warn("[{}] - Item ID {} is a ware item, for player: {}, skipping.", __FUNCTION__, itemId, player->getName());
			continue;
		}

		rowBuffer.clear();
		rowOutput = fmt::format_to(rowOutput, "{},{},{}", playerGuid, itemId, itemCount);
		if (!stashQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}

	if (!stashQuery.execute()) {
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerSpells(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_spells` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert spellsQuery("INSERT INTO `player_spells` (`player_id`, `name` ) VALUES ");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(64);
	auto rowOutput = std::back_inserter(rowBuffer);
	for (const std::string &spellName : player->learnedInstantSpellList) {
		rowBuffer.clear();
		rowOutput = fmt::format_to(rowOutput, "{},{}", playerGuid, db.escapeString(spellName));
		if (!spellsQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}

	if (!spellsQuery.execute()) {
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerKills(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_kills` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert killsQuery("INSERT INTO `player_kills` (`player_id`, `target`, `time`, `unavenged`) VALUES");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(80);
	auto rowOutput = std::back_inserter(rowBuffer);
	for (const auto &kill : player->unjustifiedKills) {
		rowBuffer.clear();
		rowOutput = fmt::format_to(rowOutput, "{},{},{},{}", playerGuid, kill.target, kill.time, kill.unavenged);
		if (!killsQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}

	if (!killsQuery.execute()) {
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerBestiarySystem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();

	PropWriteStream charmsStream;
	for (uint8_t id = magic_enum::enum_value<charmRune_t>(1); id <= magic_enum::enum_count<charmRune_t>(); id++) {
		const auto &charm = player->charmsArray[id];
		charmsStream.write<uint16_t>(charm.raceId);
		charmsStream.write<uint8_t>(charm.tier);
		g_logger().debug("Player {} saved raceId {} and tier {} to charm Id {}", player->name, charm.raceId, charm.tier, id);
	}
	size_t size;
	const char* charmsList = charmsStream.getStream(size);

	PropWriteStream propBestiaryStream;
	for (const auto &trackedType : player->getCyclopediaMonsterTrackerSet(false)) {
		propBestiaryStream.write<uint16_t>(trackedType->info.raceid);
	}
	size_t trackerSize;
	const char* trackerList = propBestiaryStream.getStream(trackerSize);
	const std::string query = fmt::format(
		"UPDATE `player_charms` SET "
		"`charm_points` = {}, "
		"`minor_charm_echoes` = {}, "
		"`max_charm_points` = {}, "
		"`max_minor_charm_echoes` = {}, "
		"`charm_expansion` = {}, "
		"`UsedRunesBit` = {}, "
		"`UnlockedRunesBit` = {}, "
		"`charms` = {}, "
		"`tracker list` = {} "
		"WHERE `player_id` = {}",
		player->charmPoints,
		player->minorCharmEchoes,
		player->maxCharmPoints,
		player->maxMinorCharmEchoes,
		player->charmExpansion ? 1 : 0,
		player->UsedRunesBit,
		player->UnlockedRunesBit,
		db.escapeBlob(charmsList, static_cast<uint32_t>(size)),
		db.escapeBlob(trackerList, static_cast<uint32_t>(trackerSize)),
		playerGuid
	);

	if (!db.executeQuery(query)) {
		g_logger().warn("[IOLoginData::savePlayer] - Error saving bestiary data from player: {}", player->getName());
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerItem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	PropWriteStream propWriteStream;
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_items` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		g_logger().warn("[IOLoginData::savePlayer] - Error delete query 'player_items' from player: {}", player->getName());
		return false;
	}

	DBInsert itemsQuery("INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");

	ItemBlockList itemList;
	for (int32_t slotId = CONST_SLOT_FIRST; slotId <= CONST_SLOT_LAST; ++slotId) {
		const auto &item = player->inventory[slotId];
		if (item) {
			itemList.emplace_back(slotId, item);
		}
	}

	if (!saveItems(player, itemList, itemsQuery, propWriteStream)) {
		g_logger().warn("[IOLoginData::savePlayer] - Failed for save items from player: {}", player->getName());
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerDepotItems(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	PropWriteStream propWriteStream;
	ItemDepotList depotList;
	const uint32_t playerGuid = player->getGUID();
	if (player->lastDepotId != -1) {
		const std::string deleteQuery = fmt::format("DELETE FROM `player_depotitems` WHERE `player_id` = {}", playerGuid);

		if (!db.executeQuery(deleteQuery)) {
			return false;
		}

		DBInsert depotQuery("INSERT INTO `player_depotitems` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");

		for (const auto &[pid, depotChest] : player->depotChests) {
			for (const std::shared_ptr<Item> &item : depotChest->getItemList()) {
				depotList.emplace_back(pid, item);
			}
		}

		if (!saveItems(player, depotList, depotQuery, propWriteStream)) {
			return false;
		}
		return true;
	}
	return true;
}

bool IOLoginDataSave::saveRewardItems(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_rewards` WHERE `player_id` = {}", playerGuid);

	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	std::vector<uint64_t> rewardList;
	player->getRewardList(rewardList);

	ItemRewardList rewardListItems;
	if (!rewardList.empty()) {
		for (const auto &rewardId : rewardList) {
			auto reward = player->getReward(rewardId, false);
			if (!reward->empty() && (getTimeMsNow() - rewardId <= 1000 * 60 * 60 * 24 * 7)) {
				rewardListItems.emplace_back(0, reward);
			}
		}

		DBInsert rewardQuery("INSERT INTO `player_rewards` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");
		PropWriteStream propWriteStream;
		if (!saveItems(player, rewardListItems, rewardQuery, propWriteStream)) {
			return false;
		}
	}
	return true;
}

bool IOLoginDataSave::savePlayerInbox(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	PropWriteStream propWriteStream;
	ItemInboxList inboxList;
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_inboxitems` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert inboxQuery("INSERT INTO `player_inboxitems` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ");

	for (const auto &item : player->getInbox()->getItemList()) {
		inboxList.emplace_back(0, item);
	}

	if (!saveItems(player, inboxList, inboxQuery, propWriteStream)) {
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerPreyClass(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	if (!g_configManager().getBoolean(PREY_ENABLED)) {
		return true;
	}

	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
		if (!slot) {
			continue;
		}

		PropWriteStream propPreyStream;
		[[maybe_unused]] auto lambda = std::ranges::for_each(slot->raceIdList, [&propPreyStream](uint16_t raceId) {
			propPreyStream.write<uint16_t>(raceId);
		});

		size_t preySize;
		const char* preyList = propPreyStream.getStream(preySize);
		const std::string query = fmt::format(
			"INSERT INTO player_prey (`player_id`, `slot`, `state`, `raceid`, `option`, `bonus_type`, `bonus_rarity`, `bonus_percentage`, `bonus_time`, `free_reroll`, `monster_list`) "
			"VALUES ({}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}) "
			"ON DUPLICATE KEY UPDATE "
			"`state` = VALUES(`state`), "
			"`raceid` = VALUES(`raceid`), "
			"`option` = VALUES(`option`), "
			"`bonus_type` = VALUES(`bonus_type`), "
			"`bonus_rarity` = VALUES(`bonus_rarity`), "
			"`bonus_percentage` = VALUES(`bonus_percentage`), "
			"`bonus_time` = VALUES(`bonus_time`), "
			"`free_reroll` = VALUES(`free_reroll`), "
			"`monster_list` = VALUES(`monster_list`)",
			playerGuid,
			static_cast<uint16_t>(slot->id),
			static_cast<uint16_t>(slot->state),
			slot->selectedRaceId,
			static_cast<uint16_t>(slot->option),
			static_cast<uint16_t>(slot->bonus),
			static_cast<uint16_t>(slot->bonusRarity),
			slot->bonusPercentage,
			slot->bonusTimeLeft,
			slot->freeRerollTimeStamp,
			db.escapeBlob(preyList, static_cast<uint32_t>(preySize))
		);

		if (!db.executeQuery(query)) {
			g_logger().warn("[IOLoginData::savePlayer] - Error saving prey slot data from player: {}", player->getName());
			return false;
		}
	}
	return true;
}

bool IOLoginDataSave::savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		return true;
	}

	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		const auto &slot = player->getTaskHuntingSlotById(static_cast<PreySlot_t>(slotId));
		if (!slot) {
			continue;
		}

		PropWriteStream propTaskHuntingStream;
		[[maybe_unused]] auto lambda = std::ranges::for_each(slot->raceIdList, [&propTaskHuntingStream](uint16_t raceId) {
			propTaskHuntingStream.write<uint16_t>(raceId);
		});

		size_t taskHuntingSize;
		const char* taskHuntingList = propTaskHuntingStream.getStream(taskHuntingSize);
		const std::string query = fmt::format(
			"INSERT INTO `player_taskhunt` (`player_id`, `slot`, `state`, `raceid`, `upgrade`, `rarity`, `kills`, `disabled_time`, `free_reroll`, `monster_list`) "
			"VALUES ({}, {}, {}, {}, {}, {}, {}, {}, {}, {}) "
			"ON DUPLICATE KEY UPDATE "
			"`state` = VALUES(`state`), "
			"`raceid` = VALUES(`raceid`), "
			"`upgrade` = VALUES(`upgrade`), "
			"`rarity` = VALUES(`rarity`), "
			"`kills` = VALUES(`kills`), "
			"`disabled_time` = VALUES(`disabled_time`), "
			"`free_reroll` = VALUES(`free_reroll`), "
			"`monster_list` = VALUES(`monster_list`)",
			playerGuid,
			static_cast<uint16_t>(slot->id),
			static_cast<uint16_t>(slot->state),
			slot->selectedRaceId,
			slot->upgrade ? 1 : 0,
			static_cast<uint16_t>(slot->rarity),
			slot->currentKills,
			slot->disabledUntilTimeStamp,
			slot->freeRerollTimeStamp,
			db.escapeBlob(taskHuntingList, static_cast<uint32_t>(taskHuntingSize))
		);

		if (!db.executeQuery(query)) {
			g_logger().warn("[IOLoginData::savePlayer] - Error saving task hunting slot data from player: {}", player->getName());
			return false;
		}
	}
	return true;
}

bool IOLoginDataSave::savePlayerForgeHistory(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginDataSave::savePlayerForgeHistory] - Player nullptr");
		return false;
	}

	return player->forgeHistory().save();
}

bool IOLoginDataSave::savePlayerBosstiary(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_bosstiary` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert insertQuery("INSERT INTO `player_bosstiary` (`player_id`, `bossIdSlotOne`, `bossIdSlotTwo`, `removeTimes`, `tracker`) VALUES");

	// Bosstiary tracker
	PropWriteStream stream;
	for (const auto &monsterType : player->getCyclopediaMonsterTrackerSet(true)) {
		if (!monsterType) {
			continue;
		}

		stream.write<uint16_t>(monsterType->info.raceid);
	}
	size_t size;
	const char* chars = stream.getStream(size);
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(96);
	auto rowOutput = std::back_inserter(rowBuffer);
	rowOutput = fmt::format_to(
		rowOutput,
		"{},{},{},{},{}",
		playerGuid,
		player->getSlotBossId(1),
		player->getSlotBossId(2),
		player->getRemoveTimes(),
		db.escapeBlob(chars, static_cast<uint32_t>(size))
	);
	static_cast<void>(rowOutput);

	if (!insertQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
		return false;
	}

	if (!insertQuery.execute()) {
		return false;
	}

	return true;
}

bool IOLoginDataSave::savePlayerStorage(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[{}] - Player nullptr", __FUNCTION__);
		return false;
	}

	auto &storage = player->storage();
	storage.prepareForPersist();
	auto delta = storage.delta();
	auto guid = player->getGUID();
	auto &repo = g_playerStorageRepository();

	if (!delta.deletions.empty() && !repo.deleteKeys(guid, delta.deletions)) {
		return false;
	}

	if (!delta.upserts.empty() && !repo.upsert(guid, delta.upserts)) {
		return false;
	}

	storage.clearDirty();
	return true;
}

void IOLoginDataSave::savePlayerSystems(const std::shared_ptr<Player> &player) {
	if (!player) {
		return;
	}

	// Save the player's Virtue to persistent storage if it's set
	auto virtue = player->getVirtue();
	if (virtue > Virtue_t::None) {
		player->kv()->scoped("spells")->set("virtue", static_cast<uint8_t>(virtue));
	}

	auto harmony = player->getHarmony();
	if (harmony > 0) {
		player->kv()->scoped("spells")->set("harmony", harmony);
	}
}

void IOLoginDataSave::savePlayerExivaRestrictions(const std::shared_ptr<Player> &player) {
	if (!player) {
		return;
	}

	const auto &restrictions = player->getExivaRestrictions();

	const auto &scope = player->kv()->scoped("exiva-restrictions");

	scope->set("allowAll", restrictions.allowAll);
	scope->set("allowOwnGuild", restrictions.allowOwnGuild);
	scope->set("allowOwnParty", restrictions.allowOwnParty);
	scope->set("allowVipList", restrictions.allowVipList);
	scope->set("allowPlayerWhitelist", restrictions.allowPlayerWhitelist);
	scope->set("allowGuildWhitelist", restrictions.allowGuildWhitelist);

	ArrayType playerArrayWrapper;
	for (const auto &playerGuid : restrictions.playerWhitelist) {
		playerArrayWrapper.push_back(ValueWrapper(static_cast<int>(playerGuid)));
	}

	scope->set("playerWhitelist", ValueWrapper(playerArrayWrapper));

	ArrayType guildArrayWrapper;
	for (const auto &guildId : restrictions.guildWhitelist) {
		guildArrayWrapper.push_back(ValueWrapper(static_cast<int>(guildId)));
	}

	scope->set("guildWhitelist", ValueWrapper(guildArrayWrapper));
}
