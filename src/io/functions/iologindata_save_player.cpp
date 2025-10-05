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
#include "creatures/players/components/player_storage.hpp"
#include "game/game.hpp"
#include "io/ioprey.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "items/containers/rewards/reward.hpp"
#include "creatures/players/player.hpp"
#include "io/player_storage_repository.hpp"
#include "game/scheduling/save_manager.hpp"
#include "lib/di/container.hpp"

namespace {
	ILoginDataSaveRepository* g_testLoginDataSaveRepository = nullptr;
}

class DbLoginDataSaveRepository final : public ILoginDataSaveRepository {
public:
	bool savePlayerFirst(const std::shared_ptr<Player> &player) override;
	bool savePlayerStash(const std::shared_ptr<Player> &player) override;
	bool savePlayerSpells(const std::shared_ptr<Player> &player) override;
	bool savePlayerKills(const std::shared_ptr<Player> &player) override;
	bool savePlayerBestiarySystem(const std::shared_ptr<Player> &player) override;
	bool savePlayerItem(const std::shared_ptr<Player> &player) override;
	bool savePlayerDepotItems(const std::shared_ptr<Player> &player) override;
	bool saveRewardItems(const std::shared_ptr<Player> &player) override;
	bool savePlayerInbox(const std::shared_ptr<Player> &player) override;
	bool savePlayerPreyClass(const std::shared_ptr<Player> &player) override;
	bool savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player) override;
	bool savePlayerForgeHistory(const std::shared_ptr<Player> &player) override;
	bool savePlayerBosstiary(const std::shared_ptr<Player> &player) override;
	bool savePlayerStorage(const std::shared_ptr<Player> &player) override;

private:
	using ItemBlockList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;
	using ItemDepotList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;
	using ItemRewardList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;
	using ItemInboxList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;

	bool saveItems(const std::shared_ptr<Player> &player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &stream);
};

bool DbLoginDataSaveRepository::saveItems(const std::shared_ptr<Player> &player, const ItemBlockList &itemList, DBInsert &query_insert, PropWriteStream &propWriteStream) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	const auto &db = g_database();
	const uint32_t playerGuid = player->getGUID();
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(256);

	using ContainerBlock = std::pair<std::shared_ptr<Container>, int32_t>;
	std::list<ContainerBlock> queue;
	int32_t runningId = 100;

	const auto &openContainers = player->getOpenContainers();
	for (const auto &it : itemList) {
		const auto &item = it.second;
		if (!item) {
			continue;
		}

		const int32_t pid = it.first;

		++runningId;

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

			queue.emplace_back(container, runningId);
		}

		propWriteStream.clear();
		item->serializeAttr(propWriteStream);

		size_t attributesSize;
		const char* attributes = propWriteStream.getStream(attributesSize);

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

	while (!queue.empty()) {
		const ContainerBlock &cb = queue.front();
		const std::shared_ptr<Container> &container = cb.first;
		if (!container) {
			continue;
		}

		const int32_t parentId = cb.second;

		for (auto &item : container->getItemList()) {
			if (!item) {
				continue;
			}

			++runningId;

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

			propWriteStream.clear();
			item->serializeAttr(propWriteStream);

			size_t attributesSize;
			const char* attributes = propWriteStream.getStream(attributesSize);

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

		queue.pop_front();
	}

	return true;
}

bool DbLoginDataSaveRepository::savePlayerFirst(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[DbLoginDataSaveRepository::savePlayerFirst] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	if (player->getHealth() <= 0) {
		player->changeHealth(1);
	}

	auto &db = g_database();
	const uint32_t playerGuid = player->getGUID();

	auto result = db.storeQuery(fmt::format("SELECT `save` FROM `players` WHERE `id` = {}", playerGuid));
	if (!result) {
		g_logger().warn("[DbLoginDataSaveRepository::savePlayerFirst] - Error retrieving save flag for player: {}", player->getName());
		return false;
	}

	if (result->getNumber<uint16_t>("save") == 0) {
		auto quickUpdateTask = [queryStr = fmt::format(
									"UPDATE `players` SET `lastlogin` = {}, `lastip` = {} WHERE `id` = {}",
									player->lastLoginSaved, player->lastIP, playerGuid
								)]() {
			if (!g_database().executeQuery(queryStr)) {
				g_logger().warn("[SaveManager::quickUpdateTask] - Failed to execute quick update for player.");
			}
		};

		g_saveManager().addTask(std::move(quickUpdateTask), "DbLoginDataSaveRepository::savePlayerFirst - quickUpdateTask");
		return true;
	}

	std::vector<std::string> columns;
	static constexpr size_t kMinReserve = 96;
	columns.reserve(std::max<size_t>(result->getNumColumns(), kMinReserve));

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

	PropWriteStream propAnimusMasteryStream;
	player->animusMastery().serialize(propAnimusMasteryStream);
	size_t animusMasterySize;
	const char* animusMastery = propAnimusMasteryStream.getStream(animusMasterySize);
	columns.emplace_back(fmt::format("`animus_mastery` = {}", db.escapeBlob(animusMastery, static_cast<uint32_t>(animusMasterySize))));

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		int64_t skullTime = 0;

		if (player->skullTicks > 0) {
			auto now = std::chrono::system_clock::now();
			skullTime = std::chrono::duration_cast<std::chrono::seconds>(now.time_since_epoch()).count() + player->skullTicks;
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
	columns.emplace_back(fmt::format("`offlinetraining_skill` = {}", player->getOfflineTrainingSkill()));
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

	auto savePlayerTask = [queryStr = fmt::format("UPDATE `players` SET {} WHERE `id` = {}", setClause, playerGuid), playerName = player->getName()]() {
		if (!g_database().executeQuery(queryStr)) {
			g_logger().warn("[SaveManager::savePlayerTask] - Error executing player first save for player: {}", playerName);
		}
	};

	g_saveManager().addTask(std::move(savePlayerTask), "IOLoginData::savePlayerFirst - savePlayerTask");
	return true;
}

bool DbLoginDataSaveRepository::savePlayerStash(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_stash` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert stashQuery("INSERT INTO `player_stash` (`player_id`,`item_id`,`item_count`) VALUES ");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(48);
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
		fmt::format_to(
			std::back_inserter(rowBuffer),
			"{},{},{}",
			playerGuid,
			itemId,
			itemCount
		);

		if (!stashQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}

	if (!stashQuery.execute()) {
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerSpells(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_spells` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert spellsQuery("INSERT INTO `player_spells` (`player_id`, `name` ) VALUES ");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(64);
	for (const std::string &spellName : player->learnedInstantSpellList) {
		rowBuffer.clear();
		fmt::format_to(
			std::back_inserter(rowBuffer),
			"{},{}",
			playerGuid,
			db.escapeString(spellName)
		);

		if (!spellsQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}

	if (!spellsQuery.execute()) {
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerKills(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `player_kills` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert killsQuery("INSERT INTO `player_kills` (`player_id`, `target`, `time`, `unavenged`) VALUES");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(80);
	for (const auto &kill : player->unjustifiedKills) {
		rowBuffer.clear();
		fmt::format_to(
			std::back_inserter(rowBuffer),
			"{},{},{},{}",
			playerGuid,
			kill.target,
			kill.time,
			kill.unavenged
		);

		if (!killsQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}

	if (!killsQuery.execute()) {
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerBestiarySystem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	std::vector<std::string> columns;
	columns.reserve(10);
	columns.emplace_back(fmt::format("`charm_points` = {}", player->charmPoints));
	columns.emplace_back(fmt::format("`minor_charm_echoes` = {}", player->minorCharmEchoes));
	columns.emplace_back(fmt::format("`max_charm_points` = {}", player->maxCharmPoints));
	columns.emplace_back(fmt::format("`max_minor_charm_echoes` = {}", player->maxMinorCharmEchoes));
	columns.emplace_back(fmt::format("`charm_expansion` = {}", player->charmExpansion ? 1 : 0));
	columns.emplace_back(fmt::format("`UsedRunesBit` = {}", player->UsedRunesBit));
	columns.emplace_back(fmt::format("`UnlockedRunesBit` = {}", player->UnlockedRunesBit));

	PropWriteStream charmsStream;
	for (uint8_t id = magic_enum::enum_value<charmRune_t>(1); id <= magic_enum::enum_count<charmRune_t>(); id++) {
		const auto &charm = player->charmsArray[id];
		charmsStream.write<uint16_t>(charm.raceId);
		charmsStream.write<uint8_t>(charm.tier);
		g_logger().debug("Player {} saved raceId {} and tier {} to charm Id {}", player->name, charm.raceId, charm.tier, id);
	}
	size_t size;
	const char* charmsList = charmsStream.getStream(size);
	columns.emplace_back(fmt::format("`charms` = {}", db.escapeBlob(charmsList, static_cast<uint32_t>(size))));

	PropWriteStream propBestiaryStream;
	for (const auto &trackedType : player->getCyclopediaMonsterTrackerSet(false)) {
		propBestiaryStream.write<uint16_t>(trackedType->info.raceid);
	}
	size_t trackerSize;
	const char* trackerList = propBestiaryStream.getStream(trackerSize);
	columns.emplace_back(fmt::format("`tracker list` = {}", db.escapeBlob(trackerList, static_cast<uint32_t>(trackerSize))));

	const uint32_t playerGuid = player->getGUID();
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

	const std::string query = fmt::format("UPDATE `player_charms` SET {} WHERE `player_id` = {}", setClause, playerGuid);

	if (!db.executeQuery(query)) {
		g_logger().warn("[IOLoginData::savePlayer] - Error saving bestiary data from player: {}", player->getName());
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerItem(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
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
	if (!itemsQuery.execute()) {
		g_logger().warn("[IOLoginData::savePlayer] - Error executing insert query 'player_items' for player: {}", player->getName());
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerDepotItems(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
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
		if (!depotQuery.execute()) {
			g_logger().warn("[IOLoginData::savePlayer] - Error executing insert query 'player_depotitems' for player: {}", player->getName());
			return false;
		}
		return true;
	}
	return true;
}

bool DbLoginDataSaveRepository::saveRewardItems(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
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
		if (!rewardQuery.execute()) {
			g_logger().warn("[IOLoginData::savePlayer] - Error executing insert query 'player_rewards' for player: {}", player->getName());
			return false;
		}
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerInbox(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
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
	if (!inboxQuery.execute()) {
		g_logger().warn("[IOLoginData::savePlayer] - Error executing insert query 'player_inboxitems' for player: {}", player->getName());
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerPreyClass(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	if (g_configManager().getBoolean(PREY_ENABLED)) {
		const uint32_t playerGuid = player->getGUID();
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			if (const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId))) {
				PropWriteStream propPreyStream;
				std::ranges::for_each(slot->raceIdList, [&propPreyStream](uint16_t raceId) {
					propPreyStream.write<uint16_t>(raceId);
				});

				size_t preySize;
				const char* preyList = propPreyStream.getStream(preySize);
				const std::string monsterList = db.escapeBlob(preyList, static_cast<uint32_t>(preySize));

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
					monsterList
				);

				if (!db.executeQuery(query)) {
					g_logger().warn("[IOLoginData::savePlayer] - Error saving prey slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		const uint32_t playerGuid = player->getGUID();
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			if (const auto &slot = player->getTaskHuntingSlotById(static_cast<PreySlot_t>(slotId))) {
				PropWriteStream propTaskHuntingStream;
				std::ranges::for_each(slot->raceIdList, [&propTaskHuntingStream](uint16_t raceId) {
					propTaskHuntingStream.write<uint16_t>(raceId);
				});

				size_t taskHuntingSize;
				const char* taskHuntingList = propTaskHuntingStream.getStream(taskHuntingSize);
				const std::string monsterList = db.escapeBlob(taskHuntingList, static_cast<uint32_t>(taskHuntingSize));

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
					monsterList
				);

				if (!db.executeQuery(query)) {
					g_logger().warn("[IOLoginData::savePlayer] - Error saving task hunting slot data from player: {}", player->getName());
					return false;
				}
			}
		}
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerForgeHistory(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
	const uint32_t playerGuid = player->getGUID();
	const std::string deleteQuery = fmt::format("DELETE FROM `forge_history` WHERE `player_id` = {}", playerGuid);
	if (!db.executeQuery(deleteQuery)) {
		return false;
	}

	DBInsert insertQuery("INSERT INTO `forge_history` (`player_id`, `action_type`, `description`, `done_at`, `is_success`) VALUES");
	fmt::memory_buffer rowBuffer;
	rowBuffer.reserve(128);
	for (const auto &history : player->getForgeHistory()) {
		const auto stringDescription = db.escapeString(history.description);
		const auto actionString = magic_enum::enum_integer(history.actionType);
		rowBuffer.clear();
		fmt::format_to(
			std::back_inserter(rowBuffer),
			"{},{},{},{},{}",
			playerGuid,
			actionString,
			stringDescription,
			history.createdAt,
			history.success
		);

		if (!insertQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
			return false;
		}
	}
	if (!insertQuery.execute()) {
		return false;
	}
	return true;
}

bool DbLoginDataSaveRepository::savePlayerBosstiary(const std::shared_ptr<Player> &player) {
	if (!player) {
		g_logger().warn("[IOLoginData::savePlayer] - Player nullptr: {}", __FUNCTION__);
		return false;
	}

	auto &db = g_database();
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
	fmt::format_to(
		std::back_inserter(rowBuffer),
		"{},{},{},{},{}",
		playerGuid,
		player->getSlotBossId(1),
		player->getSlotBossId(2),
		player->getRemoveTimes(),
		db.escapeBlob(chars, static_cast<uint32_t>(size))
	);

	if (!insertQuery.addRow(std::string_view(rowBuffer.data(), rowBuffer.size()))) {
		return false;
	}

	if (!insertQuery.execute()) {
		return false;
	}

	return true;
}

bool DbLoginDataSaveRepository::savePlayerStorage(const std::shared_ptr<Player> &player) {
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

ILoginDataSaveRepository &g_loginDataSaveRepository() {
	if (g_testLoginDataSaveRepository) {
		return *g_testLoginDataSaveRepository;
	}
	return inject<DbLoginDataSaveRepository>();
}

void setLoginDataSaveRepositoryForTest(ILoginDataSaveRepository* repository) {
	g_testLoginDataSaveRepository = repository;
}

void resetLoginDataSaveRepositoryForTest() {
	g_testLoginDataSaveRepository = nullptr;
}

bool IOLoginDataSave::savePlayerFirst(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerFirst(player);
}

bool IOLoginDataSave::savePlayerStash(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerStash(player);
}

bool IOLoginDataSave::savePlayerSpells(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerSpells(player);
}

bool IOLoginDataSave::savePlayerKills(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerKills(player);
}

bool IOLoginDataSave::savePlayerBestiarySystem(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerBestiarySystem(player);
}

bool IOLoginDataSave::savePlayerItem(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerItem(player);
}

bool IOLoginDataSave::savePlayerDepotItems(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerDepotItems(player);
}

bool IOLoginDataSave::saveRewardItems(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().saveRewardItems(player);
}

bool IOLoginDataSave::savePlayerInbox(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerInbox(player);
}

bool IOLoginDataSave::savePlayerPreyClass(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerPreyClass(player);
}

bool IOLoginDataSave::savePlayerTaskHuntingClass(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerTaskHuntingClass(player);
}

bool IOLoginDataSave::savePlayerForgeHistory(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerForgeHistory(player);
}

bool IOLoginDataSave::savePlayerBosstiary(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerBosstiary(player);
}

bool IOLoginDataSave::savePlayerStorage(const std::shared_ptr<Player> &player) {
	return g_loginDataSaveRepository().savePlayerStorage(player);
}
