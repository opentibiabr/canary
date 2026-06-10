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
		fmt::format_to(
			std::back_inserter(rowBuffer),
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
			fmt::format_to(
				std::back_inserter(rowBuffer),
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

	std::vector<std::string> columns;
	columns.reserve(96);

	columns.emplace_back(fmt::format("`name` = {}", db.escapeString(player->name)));
	columns.emplace_back(fmt::format("`level` = {}", player->level));
	columns.emplace_back(fmt::format("`group_id` = {}", player->group->id));
	columns.emplace_back(fmt::format("`vocation` = {}", player->getVocationId()));
	columns.emplace_back(fmt::format("`health` = {}", player->health));
	columns.emplace_back(fmt::format("`healthmax` = {}", player->healthMax));
	columns.emplace_back(fmt::format("`experience` = {}", player->experience));
	columns.emplace_back(fmt::format("`lookbody` = {}", static_cast<uint32_t>(player->defaultOutfit.lookBody)));
	columns.emplace_back(fmt::format("`lookfeet` = {}", static_cast<uint32_t>(player->defaultOutfit.lookFeet)));
	columns.emplace_back(fmt::format("`lookhead` = {}", static_cast<uint32_t>(player->defaultOutfit.lookHead)));
	columns.emplace_back(fmt::format("`looklegs` = {}", static_cast<uint32_t>(player->defaultOutfit.lookLegs)));
	columns.emplace_back(fmt::format("`looktype` = {}", player->defaultOutfit.lookType));
	columns.emplace_back(fmt::format("`lookaddons` = {}", static_cast<uint32_t>(player->defaultOutfit.lookAddons)));
	columns.emplace_back(fmt::format("`lookmountbody` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountBody)));
	columns.emplace_back(fmt::format("`lookmountfeet` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountFeet)));
	columns.emplace_back(fmt::format("`lookmounthead` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountHead)));
	columns.emplace_back(fmt::format("`lookmountlegs` = {}", static_cast<uint32_t>(player->defaultOutfit.lookMountLegs)));
	columns.emplace_back(fmt::format("`lookfamiliarstype` = {}", player->defaultOutfit.lookFamiliarsType));
	columns.emplace_back(fmt::format("`isreward` = {}", static_cast<uint16_t>(player->isDailyReward)));
	columns.emplace_back(fmt::format("`maglevel` = {}", player->magLevel));
	columns.emplace_back(fmt::format("`mana` = {}", player->mana));
	columns.emplace_back(fmt::format("`manamax` = {}", player->manaMax));
	columns.emplace_back(fmt::format("`manaspent` = {}", player->manaSpent));
	columns.emplace_back(fmt::format("`soul` = {}", static_cast<uint16_t>(player->soul)));
	if (player->town) {
		columns.emplace_back(fmt::format("`town_id` = {}", player->town->getID()));
	}

	const Position &loginPosition = player->getLoginPosition();
	columns.emplace_back(fmt::format("`posx` = {}", loginPosition.getX()));
	columns.emplace_back(fmt::format("`posy` = {}", loginPosition.getY()));
	columns.emplace_back(fmt::format("`posz` = {}", loginPosition.getZ()));

	columns.emplace_back(fmt::format("`prey_wildcard` = {}", player->getPreyCards()));
	columns.emplace_back(fmt::format("`task_points` = {}", player->getTaskHuntingPoints()));
	columns.emplace_back(fmt::format("`boss_points` = {}", player->getBossPoints()));
	columns.emplace_back(fmt::format("`forge_dusts` = {}", player->getForgeDusts()));
	columns.emplace_back(fmt::format("`forge_dust_level` = {}", player->getForgeDustLevel()));
	columns.emplace_back(fmt::format("`randomize_mount` = {}", static_cast<uint16_t>(player->isRandomMounted())));
	columns.emplace_back(fmt::format("`cap` = {}", (player->capacity / 100)));
	columns.emplace_back(fmt::format("`sex` = {}", static_cast<uint16_t>(player->sex)));

	if (player->lastLoginSaved != 0) {
		columns.emplace_back(fmt::format("`lastlogin` = {}", player->lastLoginSaved));
	}

	if (player->lastIP != 0) {
		columns.emplace_back(fmt::format("`lastip` = {}", player->lastIP));
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

	columns.emplace_back(fmt::format("`conditions` = {}", db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize))));

	// serialize animus mastery
	PropWriteStream propAnimusMasteryStream;
	player->animusMastery().serialize(propAnimusMasteryStream);
	size_t animusMasterySize;
	const char* animusMastery = propAnimusMasteryStream.getStream(animusMasterySize);

	columns.emplace_back(fmt::format("`animus_mastery` = {}", db.escapeBlob(animusMastery, static_cast<uint32_t>(animusMasterySize))));

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		int64_t skullTime = 0;

		if (player->skullTicks > 0) {
			auto now = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
			skullTime = now + player->skullTicks;
		}

		columns.emplace_back(fmt::format("`skulltime` = {}", skullTime));

		Skulls_t skull = SKULL_NONE;
		if (player->skull == SKULL_RED) {
			skull = SKULL_RED;
		} else if (player->skull == SKULL_BLACK) {
			skull = SKULL_BLACK;
		}
		columns.emplace_back(fmt::format("`skull` = {}", static_cast<int64_t>(skull)));
	}

	columns.emplace_back(fmt::format("`lastlogout` = {}", player->getLastLogout()));
	columns.emplace_back(fmt::format("`balance` = {}", player->bankBalance));
	columns.emplace_back(fmt::format("`offlinetraining_time` = {}", player->getOfflineTrainingTime() / 1000));
	columns.emplace_back(fmt::format("`offlinetraining_skill` = {}", std::to_string(player->getOfflineTrainingSkill())));
	columns.emplace_back(fmt::format("`stamina` = {}", player->getStaminaMinutes()));
	columns.emplace_back(fmt::format("`skill_fist` = {}", player->skills[SKILL_FIST].level));
	columns.emplace_back(fmt::format("`skill_fist_tries` = {}", player->skills[SKILL_FIST].tries));
	columns.emplace_back(fmt::format("`skill_club` = {}", player->skills[SKILL_CLUB].level));
	columns.emplace_back(fmt::format("`skill_club_tries` = {}", player->skills[SKILL_CLUB].tries));
	columns.emplace_back(fmt::format("`skill_sword` = {}", player->skills[SKILL_SWORD].level));
	columns.emplace_back(fmt::format("`skill_sword_tries` = {}", player->skills[SKILL_SWORD].tries));
	columns.emplace_back(fmt::format("`skill_axe` = {}", player->skills[SKILL_AXE].level));
	columns.emplace_back(fmt::format("`skill_axe_tries` = {}", player->skills[SKILL_AXE].tries));
	columns.emplace_back(fmt::format("`skill_dist` = {}", player->skills[SKILL_DISTANCE].level));
	columns.emplace_back(fmt::format("`skill_dist_tries` = {}", player->skills[SKILL_DISTANCE].tries));
	columns.emplace_back(fmt::format("`skill_shielding` = {}", player->skills[SKILL_SHIELD].level));
	columns.emplace_back(fmt::format("`skill_shielding_tries` = {}", player->skills[SKILL_SHIELD].tries));
	columns.emplace_back(fmt::format("`skill_fishing` = {}", player->skills[SKILL_FISHING].level));
	columns.emplace_back(fmt::format("`skill_fishing_tries` = {}", player->skills[SKILL_FISHING].tries));
	columns.emplace_back(fmt::format("`skill_critical_hit_chance` = {}", player->skills[SKILL_CRITICAL_HIT_CHANCE].level));
	columns.emplace_back(fmt::format("`skill_critical_hit_chance_tries` = {}", player->skills[SKILL_CRITICAL_HIT_CHANCE].tries));
	columns.emplace_back(fmt::format("`skill_critical_hit_damage` = {}", player->skills[SKILL_CRITICAL_HIT_DAMAGE].level));
	columns.emplace_back(fmt::format("`skill_critical_hit_damage_tries` = {}", player->skills[SKILL_CRITICAL_HIT_DAMAGE].tries));
	columns.emplace_back(fmt::format("`skill_life_leech_chance` = {}", player->skills[SKILL_LIFE_LEECH_CHANCE].level));
	columns.emplace_back(fmt::format("`skill_life_leech_chance_tries` = {}", player->skills[SKILL_LIFE_LEECH_CHANCE].tries));
	columns.emplace_back(fmt::format("`skill_life_leech_amount` = {}", player->skills[SKILL_LIFE_LEECH_AMOUNT].level));
	columns.emplace_back(fmt::format("`skill_life_leech_amount_tries` = {}", player->skills[SKILL_LIFE_LEECH_AMOUNT].tries));
	columns.emplace_back(fmt::format("`skill_mana_leech_chance` = {}", player->skills[SKILL_MANA_LEECH_CHANCE].level));
	columns.emplace_back(fmt::format("`skill_mana_leech_chance_tries` = {}", player->skills[SKILL_MANA_LEECH_CHANCE].tries));
	columns.emplace_back(fmt::format("`skill_mana_leech_amount` = {}", player->skills[SKILL_MANA_LEECH_AMOUNT].level));
	columns.emplace_back(fmt::format("`skill_mana_leech_amount_tries` = {}", player->skills[SKILL_MANA_LEECH_AMOUNT].tries));
	columns.emplace_back(fmt::format("`manashield` = {}", player->getManaShield()));
	columns.emplace_back(fmt::format("`max_manashield` = {}", player->getMaxManaShield()));
	columns.emplace_back(fmt::format("`xpboost_value` = {}", player->getXpBoostPercent()));
	columns.emplace_back(fmt::format("`xpboost_stamina` = {}", player->getXpBoostTime()));
	columns.emplace_back(fmt::format("`quickloot_fallback` = {}", player->quickLootFallbackToMainContainer ? 1 : 0));

	if (!player->isOffline()) {
		auto now = std::chrono::system_clock::now();
		auto lastLoginSaved = std::chrono::system_clock::from_time_t(player->lastLoginSaved);
		columns.emplace_back(fmt::format("`onlinetime` = `onlinetime` + {}", std::chrono::duration_cast<std::chrono::seconds>(now - lastLoginSaved).count()));
	}

	for (int i = 1; i <= 8; i++) {
		columns.emplace_back(fmt::format("`blessings{}` = {}", i, static_cast<uint32_t>(player->getBlessingCount(static_cast<uint8_t>(i)))));
	}

	size_t estimatedSize = 0;
	for (const auto &column : columns) {
		estimatedSize += column.size() + 2;
	}

	std::string setClause;
	setClause.reserve(estimatedSize);
	for (size_t i = 0; i < columns.size(); ++i) {
		setClause.append(columns[i]);
		if (i + 1 < columns.size()) {
			setClause.append(", ");
		}
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
	std::ostringstream query;
	query << "DELETE FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str("");

	DBInsert stashQuery("INSERT INTO `player_stash` (`player_id`,`item_id`,`item_count`) VALUES ");
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

		query << player->getGUID() << ',' << itemId << ',' << itemCount;
		if (!stashQuery.addRow(query)) {
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
	std::ostringstream query;
	query << "DELETE FROM `player_spells` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str("");

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
	return true;
}

bool IOLoginDataSave::savePlayerKills(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "DELETE FROM `player_kills` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str("");

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
	return true;
}

bool IOLoginDataSave::savePlayerBestiarySystem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "UPDATE `player_charms` SET ";
	query << "`charm_points` = " << player->charmPoints << ",";
	query << "`minor_charm_echoes` = " << player->minorCharmEchoes << ",";
	query << "`max_charm_points` = " << player->maxCharmPoints << ",";
	query << "`max_minor_charm_echoes` = " << player->maxMinorCharmEchoes << ",";
	query << "`charm_expansion` = " << (player->charmExpansion ? 1 : 0) << ",";
	query << "`UsedRunesBit` = " << player->UsedRunesBit << ",";
	query << "`UnlockedRunesBit` = " << player->UnlockedRunesBit << ",";

	PropWriteStream charmsStream;
	for (uint8_t id = magic_enum::enum_value<charmRune_t>(1); id <= magic_enum::enum_count<charmRune_t>(); id++) {
		const auto &charm = player->charmsArray[id];
		charmsStream.write<uint16_t>(charm.raceId);
		charmsStream.write<uint8_t>(charm.tier);
		g_logger().debug("Player {} saved raceId {} and tier {} to charm Id {}", player->name, charm.raceId, charm.tier, id);
	}
	size_t size;
	const char* charmsList = charmsStream.getStream(size);
	query << " `charms` = " << db.escapeBlob(charmsList, static_cast<uint32_t>(size)) << ",";

	PropWriteStream propBestiaryStream;
	for (const auto &trackedType : player->getCyclopediaMonsterTrackerSet(false)) {
		propBestiaryStream.write<uint16_t>(trackedType->info.raceid);
	}
	size_t trackerSize;
	const char* trackerList = propBestiaryStream.getStream(trackerSize);
	query << " `tracker list` = " << db.escapeBlob(trackerList, static_cast<uint32_t>(trackerSize));
	query << " WHERE `player_id` = " << player->getGUID();

	if (!db.executeQuery(query.str())) {
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
	std::ostringstream query;
	query << "DELETE FROM `player_items` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
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
	if (player->lastDepotId != -1) {
		std::ostringstream query;
		query << "DELETE FROM `player_depotitems` WHERE `player_id` = " << player->getGUID();

		if (!db.executeQuery(query.str())) {
			return false;
		}

		query.str("");

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

	std::ostringstream query;
	query << "DELETE FROM `player_rewards` WHERE `player_id` = " << player->getGUID();

	if (!Database::getInstance().executeQuery(query.str())) {
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
	std::ostringstream query;
	query << "DELETE FROM `player_inboxitems` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str("");
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
	if (g_configManager().getBoolean(PREY_ENABLED)) {
		std::ostringstream query;
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			if (const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId))) {
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
				[[maybe_unused]] auto lambda = std::ranges::for_each(slot->raceIdList, [&propPreyStream](uint16_t raceId) {
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
	return true;
}

bool IOLoginDataSave::savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		std::ostringstream query;
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			if (const auto &slot = player->getTaskHuntingSlotById(static_cast<PreySlot_t>(slotId))) {
				query.str("");
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
				[[maybe_unused]] auto lambda = std::ranges::for_each(slot->raceIdList, [&propTaskHuntingStream](uint16_t raceId) {
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

	std::ostringstream query;
	query << "DELETE FROM `player_bosstiary` WHERE `player_id` = " << player->getGUID();
	if (!Database::getInstance().executeQuery(query.str())) {
		return false;
	}

	query.str("");
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
	// Append query informations
	query << player->getGUID() << ','
		  << player->getSlotBossId(1) << ','
		  << player->getSlotBossId(2) << ','
		  << std::to_string(player->getRemoveTimes()) << ','
		  << Database::getInstance().escapeBlob(chars, static_cast<uint32_t>(size));

	if (!insertQuery.addRow(query)) {
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
