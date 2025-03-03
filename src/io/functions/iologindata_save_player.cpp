/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
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
#include "game/game.hpp"
#include "io/ioprey.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "items/containers/rewards/reward.hpp"
#include "creatures/players/player.hpp"

bool IOLoginDataSave::saveItems(const std::shared_ptr<Player> &player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &propWriteStream) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	const Database &db = Database::getInstance();
	std::ostringstream ss;

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
		ss << player->getGUID() << ',' << pid << ',' << runningId << ',' << item->getID() << ',' << item->getSubType() << ',' << db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize));
		if (!query_insert.addRow(ss)) {
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
			ss << player->getGUID() << ',' << parentId << ',' << runningId << ',' << item->getID() << ',' << item->getSubType() << ',' << db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize));
			if (!query_insert.addRow(ss)) {
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

	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `save` FROM `players` WHERE `id` = " << player->getGUID();
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		g_logger().warn("[IOLoginData::savePlayer] - Error for select result query from player: {}", player->getName());
		return false;
	}

	if (result->getNumber<uint16_t>("save") == 0) {
		query.str("");
		query << "UPDATE `players` SET `lastlogin` = " << player->lastLoginSaved << ", `lastip` = " << player->lastIP << " WHERE `id` = " << player->getGUID();
		return db.executeQuery(query.str());
	}

	// First, an UPDATE query to write the player itself
	query.str("");
	query << "UPDATE `players` SET ";
	query << "`name` = " << db.escapeString(player->name) << ",";
	query << "`level` = " << player->level << ",";
	query << "`group_id` = " << player->group->id << ",";
	query << "`vocation` = " << player->getVocationId() << ",";
	query << "`health` = " << player->health << ",";
	query << "`healthmax` = " << player->healthMax << ",";
	query << "`experience` = " << player->experience << ",";
	query << "`lookbody` = " << static_cast<uint32_t>(player->defaultOutfit.lookBody) << ",";
	query << "`lookfeet` = " << static_cast<uint32_t>(player->defaultOutfit.lookFeet) << ",";
	query << "`lookhead` = " << static_cast<uint32_t>(player->defaultOutfit.lookHead) << ",";
	query << "`looklegs` = " << static_cast<uint32_t>(player->defaultOutfit.lookLegs) << ",";
	query << "`looktype` = " << player->defaultOutfit.lookType << ",";
	query << "`lookaddons` = " << static_cast<uint32_t>(player->defaultOutfit.lookAddons) << ",";
	query << "`lookmountbody` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountBody) << ",";
	query << "`lookmountfeet` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountFeet) << ",";
	query << "`lookmounthead` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountHead) << ",";
	query << "`lookmountlegs` = " << static_cast<uint32_t>(player->defaultOutfit.lookMountLegs) << ",";
	query << "`lookfamiliarstype` = " << player->defaultOutfit.lookFamiliarsType << ",";
	query << "`isreward` = " << static_cast<uint16_t>(player->isDailyReward) << ",";
	query << "`maglevel` = " << player->magLevel << ",";
	query << "`mana` = " << player->mana << ",";
	query << "`manamax` = " << player->manaMax << ",";
	query << "`manaspent` = " << player->manaSpent << ",";
	query << "`soul` = " << static_cast<uint16_t>(player->soul) << ",";
	if (player->town) {
		query << "`town_id` = " << player->town->getID() << ",";
	}

	const Position &loginPosition = player->getLoginPosition();
	query << "`posx` = " << loginPosition.getX() << ",";
	query << "`posy` = " << loginPosition.getY() << ",";
	query << "`posz` = " << loginPosition.getZ() << ",";

	query << "`prey_wildcard` = " << player->getPreyCards() << ",";
	query << "`task_points` = " << player->getTaskHuntingPoints() << ",";
	query << "`boss_points` = " << player->getBossPoints() << ",";
	query << "`forge_dusts` = " << player->getForgeDusts() << ",";
	query << "`forge_dust_level` = " << player->getForgeDustLevel() << ",";
	query << "`randomize_mount` = " << static_cast<uint16_t>(player->isRandomMounted()) << ",";

	query << "`cap` = " << (player->capacity / 100) << ",";
	query << "`sex` = " << static_cast<uint16_t>(player->sex) << ",";

	if (player->lastLoginSaved != 0) {
		query << "`lastlogin` = " << player->lastLoginSaved << ",";
	}

	if (player->lastIP != 0) {
		query << "`lastip` = " << player->lastIP << ",";
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

	query << "`conditions` = " << db.escapeBlob(attributes, static_cast<uint32_t>(attributesSize)) << ",";

	// serialize animus mastery
	PropWriteStream propAnimusMasteryStream;
	player->animusMastery().serialize(propAnimusMasteryStream);
	size_t animusMasterySize;
	const char* animusMastery = propAnimusMasteryStream.getStream(animusMasterySize);

	query << "`animus_mastery` = " << db.escapeBlob(animusMastery, static_cast<uint32_t>(animusMasterySize)) << ",";

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		int64_t skullTime = 0;

		if (player->skullTicks > 0) {
			auto now = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
			skullTime = now + player->skullTicks;
		}

		query << "`skulltime` = " << skullTime << ",";

		Skulls_t skull = SKULL_NONE;
		if (player->skull == SKULL_RED) {
			skull = SKULL_RED;
		} else if (player->skull == SKULL_BLACK) {
			skull = SKULL_BLACK;
		}
		query << "`skull` = " << static_cast<int64_t>(skull) << ",";
	}

	query << "`lastlogout` = " << player->getLastLogout() << ",";
	query << "`balance` = " << player->bankBalance << ",";
	query << "`offlinetraining_time` = " << player->getOfflineTrainingTime() / 1000 << ",";
	query << "`offlinetraining_skill` = " << std::to_string(player->getOfflineTrainingSkill()) << ",";
	query << "`stamina` = " << player->getStaminaMinutes() << ",";
	query << "`skill_fist` = " << player->skills[SKILL_FIST].level << ",";
	query << "`skill_fist_tries` = " << player->skills[SKILL_FIST].tries << ",";
	query << "`skill_club` = " << player->skills[SKILL_CLUB].level << ",";
	query << "`skill_club_tries` = " << player->skills[SKILL_CLUB].tries << ",";
	query << "`skill_sword` = " << player->skills[SKILL_SWORD].level << ",";
	query << "`skill_sword_tries` = " << player->skills[SKILL_SWORD].tries << ",";
	query << "`skill_axe` = " << player->skills[SKILL_AXE].level << ",";
	query << "`skill_axe_tries` = " << player->skills[SKILL_AXE].tries << ",";
	query << "`skill_dist` = " << player->skills[SKILL_DISTANCE].level << ",";
	query << "`skill_dist_tries` = " << player->skills[SKILL_DISTANCE].tries << ",";
	query << "`skill_shielding` = " << player->skills[SKILL_SHIELD].level << ",";
	query << "`skill_shielding_tries` = " << player->skills[SKILL_SHIELD].tries << ",";
	query << "`skill_fishing` = " << player->skills[SKILL_FISHING].level << ",";
	query << "`skill_fishing_tries` = " << player->skills[SKILL_FISHING].tries << ",";
	query << "`skill_critical_hit_chance` = " << player->skills[SKILL_CRITICAL_HIT_CHANCE].level << ",";
	query << "`skill_critical_hit_chance_tries` = " << player->skills[SKILL_CRITICAL_HIT_CHANCE].tries << ",";
	query << "`skill_critical_hit_damage` = " << player->skills[SKILL_CRITICAL_HIT_DAMAGE].level << ",";
	query << "`skill_critical_hit_damage_tries` = " << player->skills[SKILL_CRITICAL_HIT_DAMAGE].tries << ",";
	query << "`skill_life_leech_chance` = " << player->skills[SKILL_LIFE_LEECH_CHANCE].level << ",";
	query << "`skill_life_leech_chance_tries` = " << player->skills[SKILL_LIFE_LEECH_CHANCE].tries << ",";
	query << "`skill_life_leech_amount` = " << player->skills[SKILL_LIFE_LEECH_AMOUNT].level << ",";
	query << "`skill_life_leech_amount_tries` = " << player->skills[SKILL_LIFE_LEECH_AMOUNT].tries << ",";
	query << "`skill_mana_leech_chance` = " << player->skills[SKILL_MANA_LEECH_CHANCE].level << ",";
	query << "`skill_mana_leech_chance_tries` = " << player->skills[SKILL_MANA_LEECH_CHANCE].tries << ",";
	query << "`skill_mana_leech_amount` = " << player->skills[SKILL_MANA_LEECH_AMOUNT].level << ",";
	query << "`skill_mana_leech_amount_tries` = " << player->skills[SKILL_MANA_LEECH_AMOUNT].tries << ",";
	query << "`manashield` = " << player->getManaShield() << ",";
	query << "`max_manashield` = " << player->getMaxManaShield() << ",";
	query << "`xpboost_value` = " << player->getXpBoostPercent() << ",";
	query << "`xpboost_stamina` = " << player->getXpBoostTime() << ",";
	query << "`quickloot_fallback` = " << (player->quickLootFallbackToMainContainer ? 1 : 0) << ",";

	if (!player->isOffline()) {
		auto now = std::chrono::system_clock::now();
		auto lastLoginSaved = std::chrono::system_clock::from_time_t(player->lastLoginSaved);
		query << "`onlinetime` = `onlinetime` + " << std::chrono::duration_cast<std::chrono::seconds>(now - lastLoginSaved).count() << ",";
	}

	for (int i = 1; i <= 8; i++) {
		query << "`blessings" << i << "`"
			  << " = " << static_cast<uint32_t>(player->getBlessingCount(static_cast<uint8_t>(i))) << ((i == 8) ? " " : ",");
	}
	query << " WHERE `id` = " << player->getGUID();

	if (!db.executeQuery(query.str())) {
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
				std::ranges::for_each(slot->raceIdList, [&propPreyStream](uint16_t raceId) {
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
				std::ranges::for_each(slot->raceIdList, [&propTaskHuntingStream](uint16_t raceId) {
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
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	std::ostringstream query;
	query << "DELETE FROM `forge_history` WHERE `player_id` = " << player->getGUID();
	if (!Database::getInstance().executeQuery(query.str())) {
		return false;
	}

	query.str("");
	DBInsert insertQuery("INSERT INTO `forge_history` (`player_id`, `action_type`, `description`, `done_at`, `is_success`) VALUES");
	for (const auto &history : player->getForgeHistory()) {
		const auto stringDescription = Database::getInstance().escapeString(history.description);
		auto actionString = magic_enum::enum_integer(history.actionType);
		// Append query informations
		query << player->getGUID() << ','
			  << std::to_string(actionString) << ','
			  << stringDescription << ','
			  << history.createdAt << ','
			  << history.success;

		if (!insertQuery.addRow(query)) {
			return false;
		}
	}
	if (!insertQuery.execute()) {
		return false;
	}
	return true;
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
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "DELETE FROM `player_storage` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		return false;
	}

	query.str("");

	DBInsert storageQuery("INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES ");
	player->genReservedStorageRange();

	for (const auto &[key, value] : player->storageMap) {
		query << player->getGUID() << ',' << key << ',' << value;
		if (!storageQuery.addRow(query)) {
			return false;
		}
	}

	if (!storageQuery.execute()) {
		return false;
	}
	return true;
}
