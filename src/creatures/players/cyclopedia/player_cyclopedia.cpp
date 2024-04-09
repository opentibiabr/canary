/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "player_cyclopedia.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerCyclopedia::PlayerCyclopedia(Player &player) :
	m_player(player) { }

void PlayerCyclopedia::loadSummaryData() {
	// todo create player summary
}

void PlayerCyclopedia::addXpBoostsObtained(uint16_t amount) {
	m_storeXpBoosts += amount;
}

void PlayerCyclopedia::addRewardCollectionObtained(uint16_t amount) {
	m_dailyRewardCollections += amount;
}

void PlayerCyclopedia::addHirelingsObtained(uint16_t amount) {
	m_hirelings += amount;
}

void PlayerCyclopedia::addPreyCardsObtained(uint16_t amount) {
	m_preyCards += amount;
}

void PlayerCyclopedia::addCharmsPointsObtained(uint16_t amount) {
	m_charms += amount;
}

void PlayerCyclopedia::addGoshnarTaintsObtained(uint16_t amount) {
	m_goshnar += amount;
}

void PlayerCyclopedia::addDromePointsObtained(uint16_t amount) {
	m_drome += amount;
}

void PlayerCyclopedia::addLoginStreak(uint16_t amount) {
	m_loginStreak += amount;
}

void PlayerCyclopedia::addTaskHuntingPointsObtained(uint16_t amount) {
	m_taskHuntingPoints += amount;
}

void PlayerCyclopedia::addMapAreaDiscoveredPercentage(uint16_t amount) {
	m_mapAreaDiscoveredPercentage += amount;
}

void PlayerCyclopedia::addHirelingOutfitObtained(uint16_t lookType) {
	m_hirelingOutfits.push_back(lookType);
}

void PlayerCyclopedia::addHirelingJobsObtained(uint8_t jobId) {
	m_hirelingJobs.push_back(jobId);
}

void PlayerCyclopedia::addBlessingsObtained(Blessings_t id, uint16_t amount) {
	m_blessings[id] += amount;
}

// void PlayerCyclopedia::addHouseItemsObtained(uint16_t itemId, uint32_t amount) {
//	m_houseItems[itemId] += amount;
// }

// std::map<uint8_t, std::vector<uint16_t>> PlayerCyclopedia::getAccountLevelVocation() const {
//     return accountLevelSummary;
// }

std::vector<RecentDeathEntry> PlayerCyclopedia::getDeathHistory() const {
	return m_deathHistory;
}

void PlayerCyclopedia::insertDeathOnHistory(std::string cause, uint32_t timestamp) {
	m_deathHistory.emplace_back(std::move(cause), timestamp);
}

std::vector<RecentPvPKillEntry> PlayerCyclopedia::getPvpKillsHistory() const {
	return m_pvpKillsHistory;
}

void PlayerCyclopedia::insertPvpKillOnHistory(std::string cause, uint32_t timestamp, uint8_t status) {
	m_pvpKillsHistory.emplace_back(std::move(cause), timestamp, status);
}

// const std::shared_ptr<KV> &PlayerTitle::getSummary(std::string &key) {
//	return m_player.kv()->scoped("titles")->scoped("summary")->get(key);
// }
//
// uint16_t PlayerAchievement::getPoints() const {
//	return m_player.kv()->scoped("achievements")->get("points")->getNumber();
// }
//
// void PlayerAchievement::addPoints(uint16_t toAddPoints) {
//	auto oldPoints = getPoints();
//	m_player.kv()->scoped("achievements")->set("points", oldPoints + toAddPoints);
// }
