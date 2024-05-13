/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Player;
class KV;

struct Summary {
	uint16_t m_storeXpBoosts = 0;
	uint16_t m_dailyRewardCollections = 0;
	uint16_t m_hirelings = 0;
	uint16_t m_preyCards = 0;
	uint16_t m_charms = 0;
	uint16_t m_goshnar = 0;
	uint16_t m_drome = 0;
	uint16_t m_loginStreak = 0;
	uint16_t m_taskHuntingPoints = 0;
	uint16_t m_mapAreaDiscoveredPercentage = 0;

	std::vector<uint16_t> m_hirelingOutfits;
	std::vector<uint8_t> m_hirelingJobs;
	std::map<Blessings_t, uint16_t> m_blessings;

	Summary(uint16_t mStoreXpBoosts, uint16_t mDailyRewardCollections, uint16_t mHirelings, uint16_t mPreyCards, uint16_t mCharms, uint16_t mGoshnar, uint16_t mDrome, uint16_t mLoginStreak, uint16_t mTaskHuntingPoints, uint16_t mMapAreaDiscoveredPercentage, const std::vector<uint16_t> &mHirelingOutfits, const std::vector<uint8_t> &mHirelingJobs, const std::map<Blessings_t, uint16_t> &mBlessings) :
		m_storeXpBoosts(mStoreXpBoosts), m_dailyRewardCollections(mDailyRewardCollections), m_hirelings(mHirelings), m_preyCards(mPreyCards), m_charms(mCharms), m_goshnar(mGoshnar), m_drome(mDrome), m_loginStreak(mLoginStreak), m_taskHuntingPoints(mTaskHuntingPoints), m_mapAreaDiscoveredPercentage(mMapAreaDiscoveredPercentage), m_hirelingOutfits(mHirelingOutfits), m_hirelingJobs(mHirelingJobs), m_blessings(mBlessings) { }
};

class PlayerCyclopedia {
public:
	explicit PlayerCyclopedia(Player &player);

	Summary getSummary() {
		return Summary(m_storeXpBoosts, m_dailyRewardCollections, m_hirelings, m_preyCards, m_charms, m_goshnar, m_drome, m_loginStreak, m_taskHuntingPoints, m_mapAreaDiscoveredPercentage, m_hirelingOutfits, m_hirelingJobs, m_blessings);
	}
	void loadSummaryData();
	void loadRecentKills();
	void loadDeathHistory();

	[[nodiscard]] std::vector<RecentDeathEntry> getDeathHistory() const;
	void insertDeathOnHistory(std::string cause, uint32_t timestamp);
	[[nodiscard]] std::vector<RecentPvPKillEntry> getPvpKillsHistory() const;
	void insertPvpKillOnHistory(std::string cause, uint32_t timestamp, uint8_t status);

	void addXpBoostsObtained(uint16_t amount);
	void addRewardCollectionObtained(uint16_t amount);
	void addHirelingsObtained(uint16_t amount);
	void addPreyCardsObtained(uint16_t amount);
	void addCharmsPointsObtained(uint16_t amount);
	void addGoshnarTaintsObtained(uint16_t amount);
	void addDromePointsObtained(uint16_t amount);
	void addLoginStreak(uint16_t amount);
	void addTaskHuntingPointsObtained(uint16_t amount);
	void addMapAreaDiscoveredPercentage(uint16_t amount);

	void addHirelingOutfitObtained(uint16_t lookType);
	void addHirelingJobsObtained(uint8_t jobId);
	void addBlessingsObtained(Blessings_t id, uint16_t amount);
	//	void addHouseItemsObtained(uint16_t itemId, uint32_t amount);

private:
	uint16_t m_storeXpBoosts = 0;
	uint16_t m_dailyRewardCollections = 0;
	uint16_t m_hirelings = 0;
	uint16_t m_preyCards = 0;
	uint16_t m_charms = 0;
	uint16_t m_goshnar = 0;
	uint16_t m_drome = 0;
	uint16_t m_loginStreak = 0;
	uint16_t m_taskHuntingPoints = 0;
	uint16_t m_mapAreaDiscoveredPercentage = 0;

	std::vector<uint16_t> m_hirelingOutfits;
	std::vector<uint8_t> m_hirelingJobs;
	std::map<Blessings_t, uint16_t> m_blessings;

	//	StashItemList houseItems;
	//	std::map<uint8_t, std::vector<uint16_t>> m_accountLevelSummary;

	std::vector<RecentDeathEntry> m_deathHistory;
	std::vector<RecentPvPKillEntry> m_pvpKillsHistory;

	Player &m_player;
};
