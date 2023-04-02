/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/io_bosstiary.hpp"

#include "creatures/monsters/monsters.h"
#include "creatures/players/player.h"
#include "game/game.h"
#include "utils/tools.h"

void IOBosstiary::loadBoostedBoss() {
	Database &database = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `boosted_boss`";
	DBResult_ptr result = database.storeQuery(query.str());
	if (!result) {
		SPDLOG_ERROR("[{}] Failed to detect boosted boss database. (CODE 01)", __FUNCTION__);
		return;
	}

	uint16_t date = result->getNumber<uint16_t>("date");
	auto timeNow = getTimeNow();
	auto time = localtime(&timeNow);
	auto today = time->tm_mday;

	auto bossMap = getBosstiaryMap();
	if (bossMap.size() <= 1) {
		SPDLOG_ERROR("[{}] It is not possible to create a boosted boss with only one registered boss. (CODE 02)", __FUNCTION__);
		return;
	}

	std::string bossName;
	uint32_t bossId;
	if (date == today) {
		bossName = result->getString("boostname");
		bossId = result->getNumber<uint32_t>("raceid");
		setBossBoostedName(bossName);
		setBossBoostedId(bossId);
		SPDLOG_INFO("Boosted boss: {}", bossName);
		return;
	}

	uint32_t oldBossRace = result->getNumber<uint32_t>("raceid");
	while (true) {
		uint32_t randomIndex = uniform_random(0, static_cast<int32_t>(bossMap.size()));
		auto it = std::next(bossMap.begin(), randomIndex);
		const auto &[randomBossId, randomBossName] = *it;

		auto mapBossRaceId = randomBossId;
		if (mapBossRaceId == oldBossRace) {
			continue;
		}

		const MonsterType* mType = getMonsterTypeByBossRaceId(mapBossRaceId);
		if (!mType) {
			continue;
		}

		if (auto bossRarity = mType->info.bosstiaryRace;
			bossRarity != BosstiaryRarity_t::RARITY_ARCHFOE) {
			continue;
		}

		bossName = randomBossName;
		bossId = mapBossRaceId;
		break;
	}

	query.str(std::string());
	query << "UPDATE `boosted_boss` SET ";
	query << "`date` = '" << today << "',";
	query << "`boostname` = " << database.escapeString(bossName) << ",";
	if (const MonsterType* bossType = getMonsterTypeByBossRaceId(bossId);
		bossType) {
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
		SPDLOG_ERROR("[{}] Failed to detect boosted boss database. (CODE 03)", __FUNCTION__);
		return;
	}

	setBossBoostedName(bossName);
	setBossBoostedId(bossId);
	SPDLOG_INFO("Boosted boss: {}", bossName);
}

void IOBosstiary::addBosstiaryMonster(uint32_t raceId, const std::string &name) {
	if (auto it = bosstiaryMap.find(raceId);
		it != bosstiaryMap.end()) {
		return;
	}

	bosstiaryMap.try_emplace(raceId, name);
	auto boss = std::pair<uint32_t, std::string>(raceId, name);
	bosstiaryMap.insert(boss);
}

const std::map<uint32_t, std::string> &IOBosstiary::getBosstiaryMap() const {
	return bosstiaryMap;
}

void IOBosstiary::setBossBoostedName(const std::string_view &name) {
	boostedBoss = name;
}

std::string IOBosstiary::getBoostedBossName() const {
	return boostedBoss;
}

void IOBosstiary::setBossBoostedId(uint32_t raceId) {
	boostedBossId = raceId;
}

uint32_t IOBosstiary::getBoostedBossId() const {
	return boostedBossId;
}

MonsterType* IOBosstiary::getMonsterTypeByBossRaceId(uint32_t raceId) const {
	for ([[maybe_unused]] const auto &[bossRaceId, bossName] : getBosstiaryMap()) {
		if (bossRaceId == raceId) {
			MonsterType* monsterType = g_monsters().getMonsterType(bossName);
			if (!monsterType) {
				SPDLOG_ERROR("[{}] Boss with id not found in boss map", raceId);
				continue;
			}

			return monsterType;
		}
	}

	return nullptr;
}

void IOBosstiary::addBosstiaryKill(Player* player, const MonsterType* mtype, uint32_t amount /*= 1*/) const {
	if (!player || !mtype) {
		return;
	}

	uint32_t bossId = mtype->info.bossRaceId;
	if (bossId == 0) {
		return;
	}

	auto oldBossLevel = getBossCurrentLevel(player, bossId);
	player->addBestiaryKillCount(static_cast<uint16_t>(bossId), amount);
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
	if (lootBonus <= 25)
		return 0;

	if (lootBonus <= 50) {
		return 10 * lootBonus - 250;
	} else if (lootBonus <= 100) {
		return 20 * lootBonus - 750;
	}
	return static_cast<uint32_t>((2.5 * lootBonus * lootBonus) - (477.5 * lootBonus) + 24000);
}

std::vector<uint32_t> IOBosstiary::getBosstiaryFinished(const Player* player, uint8_t level /* = 1*/) const {
	std::vector<uint32_t> unlockedMonsters;
	if (!player) {
		return unlockedMonsters;
	}

	for (std::map<uint32_t, std::string> bossesMap = getBosstiaryMap();
		 const auto &[bossId, bossName] : bossesMap) {
		uint32_t bossKills = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));
		if (bossKills == 0) {
			continue;
		}

		const MonsterType* mType = g_monsters().getMonsterType(bossName);
		if (!mType) {
			continue;
		}

		auto bossRace = mType->info.bosstiaryRace;
		auto it = levelInfos.find(bossRace);
		if (it != levelInfos.end()) {
			const std::vector<LevelInfo> &infoForCurrentRace = it->second;
			auto levelKills = infoForCurrentRace.at(level - 1).kills;
			if (bossKills >= levelKills) {
				unlockedMonsters.push_back(bossId);
			}
		} else {
			SPDLOG_WARN("[{}] boss with id {} and name {} not found in bossRace", __FUNCTION__, bossId, bossName);
		}
	}

	return unlockedMonsters;
}

uint8_t IOBosstiary::getBossCurrentLevel(const Player* player, uint32_t bossId) const {
	if (bossId == 0 || !player) {
		return 0;
	}

	auto mType = getMonsterTypeByBossRaceId(bossId);
	if (!mType) {
		return 0;
	}

	uint32_t currentKills = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));
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
		SPDLOG_WARN("[{}] boss with id {} and name {} not found in bossRace", __FUNCTION__, bossId, mType->name);
	}

	return level;
}

uint32_t IOBosstiary::calculteRemoveBoss(uint8_t removeTimes) const {
	if (removeTimes < 2)
		return 0;
	return 300000 * removeTimes - 500000;
}

std::vector<uint32_t> IOBosstiary::getBosstiaryCooldown(const Player* player) const {
	std::vector<uint32_t> bossesCooldown;
	if (!player) {
		return bossesCooldown;
	}

	for (std::map<uint32_t, std::string> bossesMap = getBosstiaryMap();
		 const auto &[bossId, bossName] : bossesMap) {
		uint32_t bossKills = player->getBestiaryKillCount(static_cast<uint16_t>(bossId));

		const MonsterType* mType = g_monsters().getMonsterType(bossName);
		if (!mType) {
			continue;
		}

		auto bossStorage = mType->info.bossStorageCooldown;
		if (bossStorage == 0) {
			continue;
		}

		if (bossKills >= 1 || player->getStorageValue(bossStorage) > 0) {
			bossesCooldown.push_back(bossId);
		}
	}

	return bossesCooldown;
}
