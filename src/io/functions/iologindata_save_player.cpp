/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/functions/iologindata_save_player.hpp"

#include "database/database.hpp"
#include "game/game.hpp"

bool IOLoginDataSave::saveItems(std::shared_ptr<Player> player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &propWriteStream) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	static std::vector<std::string> columns = { "player_id", "pid", "sid", "itemtype", "count", "attributes" };
	static std::vector<std::string> primaryColumns = { "player_id", "pid", "sid" };

	// Initialize variables
	using ContainerBlock = std::pair<std::shared_ptr<Container>, int32_t>;
	std::list<ContainerBlock> queue;
	int32_t runningId = 100;

	// Loop through each item in itemList
	const auto openContainers = player->getOpenContainers();
	for (const auto &it : itemList) {
		std::shared_ptr<Item> item = it.second;
		++runningId;

		// Update container attributes if necessary
		if (std::shared_ptr<Container> container = item->getContainer()) {
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
		try {
			propWriteStream.clear();
			item->serializeAttr(propWriteStream);
		} catch (...) {
			g_logger().error("Error serializing item attributes.");
			return false;
		}

		size_t attributesSize;
		const char* attributes = propWriteStream.getStream(attributesSize);
		std::vector<mysqlx::Value> values = {
			player->getGUID(),
			it.first,
			runningId,
			item->getID(),
			item->getSubType(),
			mysqlx::Value(mysqlx::bytes(reinterpret_cast<const uint8_t*>(attributes), attributesSize))
		};

		std::vector<mysqlx::Value> primaryValues = {
			player->getGUID(),
			it.first,
			runningId
		};

		if (!g_database().updateTable("player_items", columns, values, primaryColumns, primaryValues)) {
			g_logger().error("Failed to update table 'player_items', for player: '{}', and item: '{}'", player->getName(), item->getID());
			return false;
		}
	}

	// Loop through containers in queue
	while (!queue.empty()) {
		const ContainerBlock &cb = queue.front();
		std::shared_ptr<Container> container = cb.first;
		int32_t parentId = cb.second;
		queue.pop_front();

		if (!container) {
			continue; // Check for null container
		}

		// Loop through items in container
		for (std::shared_ptr<Item> item : container->getItemList()) {
			if (!item) {
				continue;
			}

			++runningId;

			// Update sub-container attributes if necessary
			std::shared_ptr<Container> subContainer = item->getContainer();
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
			try {
				propWriteStream.clear();
				item->serializeAttr(propWriteStream);
			} catch (...) {
				g_logger().error("Error serializing item attributes in container.");
				return false;
			}

			size_t attributesSize;
			const char* attributes = propWriteStream.getStream(attributesSize);
			std::vector<mysqlx::Value> values = {
				player->getGUID(),
				parentId,
				runningId,
				item->getID(),
				item->getSubType(),
				mysqlx::Value(mysqlx::bytes(reinterpret_cast<const uint8_t*>(attributes), attributesSize))
			};

			std::vector<mysqlx::Value> primaryValues = {
				player->getGUID(),
				parentId,
				runningId
			};

			if (!g_database().updateTable("player_items", columns, values, primaryColumns, primaryValues)) {
				return false;
			}
		}
	}

	// Execute query
	if (!query_insert.execute()) {
		g_logger().error("Error executing query.");
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerFirst(std::shared_ptr<Player> player) {
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

	if (result->getU16("save") == 0) {
		query.str("");
		query << "UPDATE `players` SET `lastlogin` = " << player->lastLoginSaved << ", `lastip` = " << player->lastIP << " WHERE `id` = " << player->getGUID();
		return db.executeQuery(query.str());
	}

	// serialize conditions
	PropWriteStream propWriteStream;
	for (const auto &condition : player->conditions) {
		const std::string typeName = std::string(magic_enum::enum_name(condition->getType()));
		g_logger().debug("Saving condition: {}", typeName);
		if (condition->isPersistent()) {
			condition->serialize(propWriteStream);
			propWriteStream.write<uint8_t>(CONDITIONATTR_END);
		}
	}

	int64_t skullTime = 0;
	Skulls_t skull = SKULL_NONE;
	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		if (player->skullTicks > 0) {
			auto now = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
			skullTime = now + player->skullTicks;
		}

		if (player->skull == SKULL_RED) {
			skull = SKULL_RED;
		} else if (player->skull == SKULL_BLACK) {
			skull = SKULL_BLACK;
		}
	}

	static std::vector<std::string> columns = {
		"name", "level", "group_id", "vocation", "health", "healthmax", "experience",
		"lookbody", "lookfeet", "lookhead", "looklegs", "looktype", "lookaddons",
		"lookmountbody", "lookmountfeet", "lookmounthead", "lookmountlegs", "lookfamiliarsType",
		"isreward", "maglevel", "mana", "manamax", "manaspent", "soul", "town_id",
		"posx", "posy", "posz", "prey_wildcard", "task_points", "boss_points", "forge_dusts",
		"forge_dust_level", "randomize_mount", "cap", "sex", "lastlogin", "lastip",
		"conditions", "skulltime", "skull", "lastlogout", "balance", "offlinetraining_time",
		"offlinetraining_skill", "stamina", "skill_fist", "skill_fist_tries", "skill_club",
		"skill_club_tries", "skill_sword", "skill_sword_tries", "skill_axe", "skill_axe_tries",
		"skill_dist", "skill_dist_tries", "skill_shielding", "skill_shielding_tries",
		"skill_fishing", "skill_fishing_tries", "skill_critical_hit_chance",
		"skill_critical_hit_chance_tries", "skill_critical_hit_damage",
		"skill_critical_hit_damage_tries", "skill_life_leech_chance",
		"skill_life_leech_chance_tries", "skill_life_leech_amount",
		"skill_life_leech_amount_tries", "skill_mana_leech_chance",
		"skill_mana_leech_chance_tries", "skill_mana_leech_amount",
		"skill_mana_leech_amount_tries", "manashield", "max_manashield", "xpboost_value",
		"xpboost_stamina", "quickloot_fallback", "onlinetime"
	};

	const auto [attributes, attributesSize] = propWriteStream.getStream();
	std::vector<mysqlx::Value> values = {
		mysqlx::Value(player->name),
		mysqlx::Value(player->level),
		mysqlx::Value(player->group->id),
		mysqlx::Value(player->getVocationId()),
		mysqlx::Value(player->health),
		mysqlx::Value(player->healthMax),
		mysqlx::Value(player->experience),
		mysqlx::Value(player->defaultOutfit.lookBody),
		mysqlx::Value(player->defaultOutfit.lookFeet),
		mysqlx::Value(player->defaultOutfit.lookHead),
		mysqlx::Value(player->defaultOutfit.lookLegs),
		mysqlx::Value(player->defaultOutfit.lookType),
		mysqlx::Value(player->defaultOutfit.lookAddons),
		mysqlx::Value(player->defaultOutfit.lookMountBody),
		mysqlx::Value(player->defaultOutfit.lookMountFeet),
		mysqlx::Value(player->defaultOutfit.lookMountHead),
		mysqlx::Value(player->defaultOutfit.lookMountLegs),
		mysqlx::Value(player->defaultOutfit.lookFamiliarsType),
		mysqlx::Value(player->isDailyReward),
		mysqlx::Value(player->magLevel),
		mysqlx::Value(player->mana),
		mysqlx::Value(player->manaMax),
		mysqlx::Value(player->manaSpent),
		mysqlx::Value(player->soul),
		mysqlx::Value(player->town->getID()),
		mysqlx::Value(player->loginPosition.getX()),
		mysqlx::Value(player->loginPosition.getY()),
		mysqlx::Value(player->loginPosition.getZ()),
		mysqlx::Value(player->getPreyCards()),
		mysqlx::Value(player->getTaskHuntingPoints()),
		mysqlx::Value(player->getBossPoints()),
		mysqlx::Value(player->getForgeDusts()),
		mysqlx::Value(player->getForgeDustLevel()),
		mysqlx::Value(player->isRandomMounted()),
		mysqlx::Value(player->capacity / 100),
		mysqlx::Value(enumToValue(player->sex)),
		mysqlx::Value(player->lastLoginSaved),
		mysqlx::Value(player->lastIP),
		mysqlx::Value(mysqlx::bytes(reinterpret_cast<const uint8_t*>(attributes), attributesSize)),
		mysqlx::Value(skullTime),
		mysqlx::Value(enumToValue(skull)),
		mysqlx::Value(player->getLastLogout()),
		mysqlx::Value(player->bankBalance),
		mysqlx::Value(player->getOfflineTrainingTime() / 1000),
		mysqlx::Value(player->getOfflineTrainingSkill()),
		mysqlx::Value(player->getStaminaMinutes()),
		mysqlx::Value(player->skills[SKILL_FIST].level),
		mysqlx::Value(player->skills[SKILL_FIST].tries),
		mysqlx::Value(player->skills[SKILL_CLUB].level),
		mysqlx::Value(player->skills[SKILL_CLUB].tries),
		mysqlx::Value(player->skills[SKILL_SWORD].level),
		mysqlx::Value(player->skills[SKILL_SWORD].tries),
		mysqlx::Value(player->skills[SKILL_AXE].level),
		mysqlx::Value(player->skills[SKILL_AXE].tries),
		mysqlx::Value(player->skills[SKILL_DISTANCE].level),
		mysqlx::Value(player->skills[SKILL_DISTANCE].tries),
		mysqlx::Value(player->skills[SKILL_SHIELD].level),
		mysqlx::Value(player->skills[SKILL_SHIELD].tries),
		mysqlx::Value(player->skills[SKILL_FISHING].level),
		mysqlx::Value(player->skills[SKILL_FISHING].tries),
		mysqlx::Value(player->skills[SKILL_CRITICAL_HIT_CHANCE].level),
		mysqlx::Value(player->skills[SKILL_CRITICAL_HIT_CHANCE].tries),
		mysqlx::Value(player->skills[SKILL_CRITICAL_HIT_DAMAGE].level),
		mysqlx::Value(player->skills[SKILL_CRITICAL_HIT_DAMAGE].tries),
		mysqlx::Value(player->skills[SKILL_LIFE_LEECH_CHANCE].level),
		mysqlx::Value(player->skills[SKILL_LIFE_LEECH_CHANCE].tries),
		mysqlx::Value(player->skills[SKILL_LIFE_LEECH_AMOUNT].level),
		mysqlx::Value(player->skills[SKILL_LIFE_LEECH_AMOUNT].tries),
		mysqlx::Value(player->skills[SKILL_MANA_LEECH_CHANCE].level),
		mysqlx::Value(player->skills[SKILL_MANA_LEECH_CHANCE].tries),
		mysqlx::Value(player->skills[SKILL_MANA_LEECH_AMOUNT].level),
		mysqlx::Value(player->skills[SKILL_MANA_LEECH_AMOUNT].tries),
		mysqlx::Value(player->getManaShield()),
		mysqlx::Value(player->getMaxManaShield()),
		mysqlx::Value(player->getXpBoostPercent()),
		mysqlx::Value(player->getXpBoostTime()),
		mysqlx::Value(player->quickLootFallbackToMainContainer ? 1 : 0),
	};

	if (!player->isOffline()) {
		auto now = std::chrono::system_clock::now();
		auto lastLoginSaved = std::chrono::system_clock::from_time_t(player->lastLoginSaved);
		auto onlineTimeSecs = std::chrono::duration_cast<std::chrono::seconds>(now - lastLoginSaved).count();
		values.push_back(mysqlx::Value(onlineTimeSecs));
	}

	// Blessings
	for (uint8_t i = 1; i <= 8; i++) {
		values.push_back(mysqlx::Value(player->getBlessingCount(i)));
	}

	if (!g_database().updateTable("players", columns, values, "id", player->getGUID())) {
		g_logger().debug("[{}] failed to insert or update row data", __FUNCTION__);
		return false;
	}

	return true;
}

bool IOLoginDataSave::savePlayerStash(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "DELETE FROM `player_stash` WHERE `player_id` = " << player->getGUID();
	if (!db.executeQuery(query.str())) {
		g_logger().error("Failed to executeQuery, query: {}", query.str());
		return false;
	}

	query.str("");

	DBInsert stashQuery("INSERT INTO `player_stash` (`player_id`,`item_id`,`item_count`) VALUES ");
	for (const auto &[itemId, itemCount] : player->getStashItems()) {
		query << player->getGUID() << ',' << itemId << ',' << itemCount;
		if (!stashQuery.addRow(query)) {
			g_logger().error("Failed to add row to query {}", query.str());
			return false;
		}
	}

	if (!stashQuery.execute()) {
		g_logger().error("Failed to execute, query: {}", query.str());
		return false;
	}
	return true;
}

bool IOLoginDataSave::savePlayerSpells(std::shared_ptr<Player> player) {
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

bool IOLoginDataSave::savePlayerKills(std::shared_ptr<Player> player) {
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

bool IOLoginDataSave::savePlayerBestiarySystem(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	// Create a stream to serialize monster tracker information
	PropWriteStream propBestiaryStream;
	for (const auto &trackedType : player->getCyclopediaMonsterTrackerSet(false)) {
		if (trackedType) {
			propBestiaryStream.write<uint16_t>(trackedType->info.raceid);
		}
	}

	size_t trackerSize;
	const char* trackerList = propBestiaryStream.getStream(trackerSize);

	// Define the columns and their corresponding values for the database update
	static std::vector<std::string> columns = {
		"player_guid",
		"charm_points",
		"charm_expansion",
		"rune_wound",
		"rune_enflame",
		"rune_poison",
		"rune_freeze",
		"rune_zap",
		"rune_curse",
		"rune_cripple",
		"rune_parry",
		"rune_dodge",
		"rune_adrenaline",
		"rune_numb",
		"rune_cleanse",
		"rune_bless",
		"rune_scavenge",
		"rune_gut",
		"rune_low_blow",
		"rune_divine",
		"rune_vamp",
		"rune_void",
		"UsedRunesBit",
		"UnlockedRunesBit",
		"tracker_list"
	};

	std::vector<mysqlx::Value> values = {
		player->getGUID(),
		player->charmPoints,
		player->charmExpansion ? 1 : 0,
		player->charmRuneWound,
		player->charmRuneEnflame,
		player->charmRunePoison,
		player->charmRuneFreeze,
		player->charmRuneZap,
		player->charmRuneCurse,
		player->charmRuneCripple,
		player->charmRuneParry,
		player->charmRuneDodge,
		player->charmRuneAdrenaline,
		player->charmRuneNumb,
		player->charmRuneCleanse,
		player->charmRuneBless,
		player->charmRuneScavenge,
		player->charmRuneGut,
		player->charmRuneLowBlow,
		player->charmRuneDivine,
		player->charmRuneVamp,
		player->charmRuneVoid,
		player->UsedRunesBit,
		player->UnlockedRunesBit,
		mysqlx::bytes(reinterpret_cast<const uint8_t*>(trackerList), trackerSize)
	};

	mysqlx::Value whereValue(player->getGUID());
	// Attempt to insert or update the blob data in the database
	if (!g_database().updateTable("player_charms", columns, values, "player_guid", whereValue)) {
		g_logger().warn("[IOLoginData::savePlayer] - Error saving bestiary data for player: {}", player->getName());
		return false;
	}

	return true;
}

bool IOLoginDataSave::savePlayerItem(std::shared_ptr<Player> player) {
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
		std::shared_ptr<Item> item = player->inventory[slotId];
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

bool IOLoginDataSave::savePlayerDepotItems(std::shared_ptr<Player> player) {
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
			for (std::shared_ptr<Item> item : depotChest->getItemList()) {
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

bool IOLoginDataSave::saveRewardItems(std::shared_ptr<Player> player) {
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

bool IOLoginDataSave::savePlayerInbox(std::shared_ptr<Player> player) {
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

bool IOLoginDataSave::savePlayerPreyClass(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	if (g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__)) {
		static std::vector<std::string> columns = {
			"player_id", "slot", "state", "raceid", "option", "bonus_type",
			"bonus_rarity", "bonus_percentage", "bonus_time", "free_reroll", "monster_list"
		};

		static std::vector<std::string> primaryColumns = {
			"player_id", "slot"
		};

		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			if (const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId))) {
				PropWriteStream propPreyStream;
				std::ranges::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&propPreyStream](uint16_t raceId) {
					propPreyStream.write<uint16_t>(raceId);
				});

				size_t preySize;
				const char* preyList = propPreyStream.getStream(preySize);
				std::vector<mysqlx::Value> values = {
					player->getGUID(),
					static_cast<uint16_t>(slot->id),
					static_cast<uint16_t>(slot->state),
					slot->selectedRaceId,
					static_cast<uint16_t>(slot->option),
					static_cast<uint16_t>(slot->bonus),
					static_cast<uint16_t>(slot->bonusRarity),
					slot->bonusPercentage,
					slot->bonusTimeLeft,
					slot->freeRerollTimeStamp,
					mysqlx::Value(mysqlx::bytes(reinterpret_cast<const uint8_t*>(preyList), preySize))
				};

				std::vector<mysqlx::Value> primaryValues = {
					player->getGUID(),
					static_cast<uint16_t>(slot->id)
				};

				if (!g_database().updateTable("player_prey", columns, values, primaryColumns, primaryValues)) {
					g_logger().warn("[IOLoginData::savePlayer] - Error saving prey slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}
	return true;
}

bool IOLoginDataSave::savePlayerTaskHuntingClass(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	Database &db = Database::getInstance();
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
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
				std::ranges::for_each(slot->raceIdList.begin(), slot->raceIdList.end(), [&propTaskHuntingStream](uint16_t raceId) {
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

bool IOLoginDataSave::savePlayerForgeHistory(std::shared_ptr<Player> player) {
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

bool IOLoginDataSave::savePlayerBosstiary(std::shared_ptr<Player> player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	// Bosstiary tracker serialization
	PropWriteStream stream;
	for (const auto &monsterType : player->getCyclopediaMonsterTrackerSet(true)) {
		if (!monsterType) {
			continue;
		}
		stream.write<uint16_t>(monsterType->info.raceid);
	}

	auto [attributeData, attributeSize] = stream.getStream();
	std::vector<std::string> columns = { "player_id", "bossIdSlotOne", "bossIdSlotTwo", "removeTimes", "tracker" };
	std::vector<mysqlx::Value> values = {
		player->getGUID(),
		player->getSlotBossId(1),
		player->getSlotBossId(2),
		player->getRemoveTimes(),
		mysqlx::Value(mysqlx::bytes(reinterpret_cast<const uint8_t*>(attributeData), attributeSize))
	};

	// Upsert data
	return g_database().updateTable("player_bosstiary", columns, values, "player_id", player->getGUID());
}

bool IOLoginDataSave::savePlayerStorage(std::shared_ptr<Player> player) {
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
