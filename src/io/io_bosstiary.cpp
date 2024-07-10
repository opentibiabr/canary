/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/io_bosstiary.hpp"

#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "utils/tools.hpp"
#include "items/item.hpp"

void IOBosstiary::loadBoostedBoss() {
	Database &database = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `boosted_boss`";
	DBResult_ptr result = database.storeQuery(query.str());
	if (!result) {
		g_logger().error("[{}] Failed to detect boosted boss database. (CODE 01)", __FUNCTION__);
		return;
	}

	uint16_t date = result->getNumber<uint16_t>("date");
	auto timeNow = getTimeNow();
	auto time = localtime(&timeNow);
	auto today = time->tm_mday;

	auto bossMap = getBosstiaryMap();
	if (bossMap.size() <= 1) {
		g_logger().error("[{}] It is not possible to create a boosted boss with only one registered boss. (CODE 02)", __FUNCTION__);
		return;
	}

	std::string bossName;
	uint16_t bossId = 0;
	if (date == today) {
		bossName = result->getString("boostname");
		bossId = result->getNumber<uint16_t>("raceid");
		setBossBoostedName(bossName);
		setBossBoostedId(bossId);
		g_logger().info("Boosted boss: {}", bossName);
		return;
	}

	// Filter only archfoe bosses
	std::map<uint16_t, std::string> bossInfo;
	for (auto [infoBossRaceId, infoBossName] : bossMap) {
		const auto mType = getMonsterTypeByBossRaceId(infoBossRaceId);
		if (!mType || mType->info.bosstiaryRace != BosstiaryRarity_t::RARITY_ARCHFOE) {
			continue;
		}

		bossInfo.try_emplace(infoBossRaceId, infoBossName);
	}

	// Check if not have archfoe registered boss
	if (bossInfo.size() == 0) {
		g_logger().error("Failed to boost a boss. There is no boss registered with the Archfoe Rarity.");
		return;
	}

	uint16_t oldBossRace = result->getNumber<uint16_t>("raceid");
	while (true) {
		uint32_t randomIndex = uniform_random(0, static_cast<int32_t>(bossInfo.size()));
		auto it = std::next(bossInfo.begin(), randomIndex);
		if (it == bossInfo.end()) {
			break;
		}

		const auto &[randomBossId, randomBossName] = *it;
		if (randomBossId == oldBossRace) {
			continue;
		}

		bossName = randomBossName;
		bossId = randomBossId;
		break;
	}

	query.str(std::string());
	query << "UPDATE `boosted_boss` SET ";
	query << "`date` = '" << today << "',";
	query << "`boostname` = " << database.escapeString(bossName) << ",";
	if (const auto bossType = getMonsterTypeByBossRaceId(bossId);
	    bossType) {
		query << "`looktypeEx` = " << static_cast<int>(bossType->info.outfit.lookTypeEx) << ",";
		query << "`looktype` = " << static_cast<int>(bossType->info.outfit.lookType) << ",";
		query << "`lookfeet` = " << static_cast<int>(bossType->info.outfit.lookFeet) << ",";
		query << "`looklegs` = " << static_cast<int>(bossType->info.outfit.lookLegs) << ",";
		query << "`lookhead` = " << static_cast<int>(bossType->info.outfit.lookHead) << ",";
		query << "`lookbody` = " << static_cast<int>(bossType->info.outfit.lookBody) << ",";
		query << "`lookaddons` = " << static_cast<int>(bossType->info.outfit.lookAddons) << ",";
		query << "`lookmount` = " << static_cast<int>(bossType->info.outfit.lookMount) << ",";
	}
	query << "`raceid` = '" << bossId << "'";
	if (!database.executeQuery(query.str())) {
		g_logger().error("[{}] Failed to detect boosted boss database. (CODE 03)", __FUNCTION__);
		return;
	}

	query.str(std::string());
	query << "UPDATE `player_bosstiary` SET `bossIdSlotOne` = 0 WHERE `bossIdSlotOne` = " << bossId;
	if (!database.executeQuery(query.str())) {
		g_logger().error("[{}] Failed to reset players selected boss slot 1. (CODE 03)", __FUNCTION__);
	}

	query.str(std::string());
	query << "UPDATE `player_bosstiary` SET `bossIdSlotTwo` = 0 WHERE `bossIdSlotTwo` = " << bossId;
	if (!database.executeQuery(query.str())) {
		g_logger().error("[{}] Failed to reset players selected boss slot 1. (CODE 03)", __FUNCTION__);
	}

	setBossBoostedName(bossName);
	setBossBoostedId(bossId);
	g_logger().info("Boosted boss: {}", bossName);
}

void IOBosstiary::addBosstiaryMonster(uint16_t raceId, const std::string &name) {
	if (auto it = bosstiaryMap.find(raceId);
	    it != bosstiaryMap.end()) {
		return;
	}

	bosstiaryMap.try_emplace(raceId, name);
	auto boss = std::pair<uint16_t, std::string>(raceId, name);
	bosstiaryMap.insert(boss);
}

const std::map<uint16_t, std::string> &IOBosstiary::getBosstiaryMap() const {
	return bosstiaryMap;
}

void IOBosstiary::setBossBoostedName(const std::string_view &name) {
	boostedBoss = name;
}

std::string IOBosstiary::getBoostedBossName() const {
	return boostedBoss;
}

void IOBosstiary::setBossBoostedId(uint16_t raceId) {
	boostedBossId = raceId;
}

uint16_t IOBosstiary::getBoostedBossId() const {
	return boostedBossId;
}

std::shared_ptr<MonsterType> IOBosstiary::getMonsterTypeByBossRaceId(uint16_t raceId) const {
	for ([[maybe_unused]] const auto &[bossRaceId, bossName] : getBosstiaryMap()) {
		if (bossRaceId == raceId) {
			const auto monsterType = g_monsters().getMonsterType(bossName);
			if (!monsterType) {
				g_logger().error("[{}] Boss with id {} not found in boss map", __FUNCTION__, raceId);
				continue;
			}

			return monsterType;
		}
	}

	return nullptr;
}

void IOBosstiary::addBosstiaryKill(std::shared_ptr<Player> player, const std::shared_ptr<MonsterType> mtype, uint32_t amount /*= 1*/) const {
	if (!player || !mtype) {
		return;
	}

	uint16_t bossId = mtype->info.raceid;
	if (bossId == 0) {
		return;
	}

	auto oldBossLevel = getBossCurrentLevel(player, bossId);
	player->addBestiaryKillCount(bossId, amount);
	player->refreshCyclopediaMonsterTracker(true);
	auto newBossLevel = getBossCurrentLevel(player, bossId);
	if (oldBossLevel == newBossLevel) {
		return;
	}
	player->sendBosstiaryEntryChanged(bossId);

	auto bossRace = mtype->info.bosstiaryRace;
	const std::vector<LevelInfo> &infoForCurrentRace = levelInfos.at(bossRace);

	auto pointsForCurrentLevel = infoForCurrentRace[newBossLevel - 1].points;
	player->addBossPoints(pointsForCurrentLevel);

	int32_t value = player->getStorageValue(STORAGEVALUE_PODIUM);
	if (value != 1 && newBossLevel == 2) {
		auto returnValue = g_game().addItemStoreInbox(player, ITEM_PODIUM_OF_VIGOUR);
		if (!returnValue) {
			return;
		}

		std::string podiumMessage = "Congratulations! You have reached the Expertise level for your first boss. "
									"As a reward, a free Podium of Vigour has been sent to your Store inbox. "
									"You can place this podium in any house you own with this character. "
									"Use it to display bosses for which you have reached at least the Expertise level.";
		player->sendTextMessage(MESSAGE_GAME_HIGHLIGHT, podiumMessage);

		player->addStorageValue(STORAGEVALUE_PODIUM, 1);
	}
}

uint16_t IOBosstiary::calculateLootBonus(uint32_t bossPoints) const {
	// Calculate Bonus based on Boss Points
	if (bossPoints <= 250) {
		return static_cast<uint16_t>(25 + bossPoints / 10);
	} else if (bossPoints < 1250) {
		return static_cast<uint16_t>(37.5 + bossPoints / 20);
	}
	return static_cast<uint16_t>(100 + 0.5 * (sqrt(8 * ((bossPoints - 1250) / 5) + 81) - 9));
}

uint32_t IOBosstiary::calculateBossPoints(uint16_t lootBonus) const {
	// Calculate Boss Points based on Bonus
	if (lootBonus <= 25) {
		return 0;
	}

	if (lootBonus <= 50) {
		return 10 * lootBonus - 250;
	} else if (lootBonus <= 100) {
		return 20 * lootBonus - 750;
	}
	return static_cast<uint32_t>((2.5 * lootBonus * lootBonus) - (477.5 * lootBonus) + 24000);
}

std::vector<uint16_t> IOBosstiary::getBosstiaryFinished(const std::shared_ptr<Player> &player, uint8_t level /* = 1*/) const {
	if (!player) {
		return {};
	}

	stdext::vector_set<uint16_t> unlockedMonsters;
	for (const auto &[bossId, bossName] : getBosstiaryMap()) {
		uint32_t bossKills = player->getBestiaryKillCount(bossId);
		if (bossKills == 0) {
			continue;
		}

		const auto mType = g_monsters().getMonsterType(bossName);
		if (!mType) {
			continue;
		}

		auto bossRace = mType->info.bosstiaryRace;
		auto it = levelInfos.find(bossRace);
		if (it != levelInfos.end()) {
			const std::vector<LevelInfo> &infoForCurrentRace = it->second;
			auto levelKills = infoForCurrentRace.at(level - 1).kills;
			if (bossKills >= levelKills) {
				unlockedMonsters.emplace(bossId);
			}
		} else {
			g_logger().warn("[{}] boss with id {} and name {} not found in bossRace", __FUNCTION__, bossId, bossName);
		}
	}

	return unlockedMonsters.data();
}

uint8_t IOBosstiary::getBossCurrentLevel(std::shared_ptr<Player> player, uint16_t bossId) const {
	if (bossId == 0 || !player) {
		return 0;
	}

	auto mType = getMonsterTypeByBossRaceId(bossId);
	if (!mType) {
		return 0;
	}

	uint32_t currentKills = player->getBestiaryKillCount(bossId);
	auto bossRace = mType->info.bosstiaryRace;
	uint8_t level = 0;
	if (auto it = levelInfos.find(bossRace);
	    it != levelInfos.end()) {
		const std::vector<LevelInfo> &infoForCurrentRace = it->second;
		for (const auto &raceInfo : infoForCurrentRace) {
			if (currentKills >= raceInfo.kills) {
				++level;
			}
		}
	} else {
		g_logger().warn("[{}] boss with id {} and name {} not found in bossRace", __FUNCTION__, bossId, mType->name);
	}

	return level;
}

uint32_t IOBosstiary::calculteRemoveBoss(uint8_t removeTimes) const {
	if (removeTimes < 2) {
		return 0;
	}
	return 300000 * removeTimes - 500000;
}

const std::vector<LevelInfo> &IOBosstiary::getBossRaceKillStages(BosstiaryRarity_t race) const {
	auto it = levelInfos.find(race);
	if (it != levelInfos.end()) {
		return it->second;
	}

	static std::vector<LevelInfo> emptyVector;
	return emptyVector;
}
