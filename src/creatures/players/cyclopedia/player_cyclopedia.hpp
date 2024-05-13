/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <creatures/creatures_definitions.hpp>
#include <utils/utils_definitions.hpp>
#include <enums/player_cyclopedia.hpp>

class Player;
class KV;

struct Summary {
	uint16_t m_xpBoosts = 0;
	uint16_t m_preyWildcards = 0;
	uint16_t m_instantRewards = 0;
	uint16_t m_charmsExpansions = 0;
	uint16_t m_hirelings = 0;

	Summary(uint16_t mXpBoosts, uint16_t mPreyWildcards, uint16_t mInstantRewards, uint16_t mCharmsExpansions, uint16_t mHirelings) :
		m_xpBoosts(mXpBoosts), m_preyWildcards(mPreyWildcards), m_instantRewards(mInstantRewards), m_charmsExpansions(mCharmsExpansions), m_hirelings(mHirelings) { }
};

class PlayerCyclopedia {
public:
	explicit PlayerCyclopedia(Player &player);

	void loadSummaryData();
	void loadSummary();
	void loadRecentKills();
	void loadDeathHistory();

	void updateStoreSummary(uint8_t type, uint16_t count = 1, uint8_t itemType = 0, uint8_t offerId = 0, uint8_t blessId = 0);
	uint16_t getAmount(uint8_t type);
	void updateAmount(uint8_t type, uint16_t toAddPoints);

	[[nodiscard]] std::vector<RecentDeathEntry> getDeathHistory() const;
	void insertDeathOnHistory(std::string cause, uint32_t timestamp);

	[[nodiscard]] std::vector<RecentPvPKillEntry> getPvpKillsHistory() const;
	void insertPvpKillOnHistory(std::string cause, uint32_t timestamp, uint8_t status);

	const Summary &getSummary() {
		return Summary(getAmount(Summary_t::BOOSTS), getAmount(Summary_t::PREY_WILDCARDS), getAmount(Summary_t::INSTANT_REWARDS), getAmount(Summary_t::CHARM_EXPANSIONS), getAmount(Summary_t::HIRELINGS));
	}
	[[nodiscard]] std::map<Blessings_t, uint16_t> getBlessings() const;
	void insertBlessings(uint8_t bless, uint32_t timestamp);

	[[nodiscard]] std::vector<uint8_t> getHirelingJobs() const;
	void insertHirelingJobs(uint8_t job, uint32_t timestamp);

	[[nodiscard]] std::vector<uint16_t> getHirelingOutfits() const;
	void insertHirelingOutfits(uint8_t outfit, uint32_t timestamp);

	[[nodiscard]] std::map<uint32_t, uint16_t> getHouseItems() const;
	void insertHouseItems(uint32_t itemId, uint16_t amount);

private:
	std::vector<RecentDeathEntry> m_deathHistory;
	std::vector<RecentPvPKillEntry> m_pvpKillsHistory;
	std::map<Blessings_t, uint16_t> m_blessings;
	std::vector<uint8_t> m_hirelingJobs;
	std::vector<uint16_t> m_hirelingOutfits;
	std::map<uint32_t, uint16_t> m_houseItems;
	Player &m_player;
};
