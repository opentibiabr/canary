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
	uint16_t m_hirelings = 0;

	Summary(uint16_t mXpBoosts, uint16_t mPreyWildcards, uint16_t mInstantRewards, uint16_t mHirelings) :
		m_xpBoosts(mXpBoosts), m_preyWildcards(mPreyWildcards), m_instantRewards(mInstantRewards), m_hirelings(mHirelings) { }
};

class PlayerCyclopedia {
public:
	explicit PlayerCyclopedia(Player &player);

	void loadSummaryData();
	void loadSummary();
	void loadRecentKills();
	void loadDeathHistory();

	void updateStoreSummary(uint8_t type, uint16_t amount = 1, const std::string &id = "");
	uint16_t getAmount(uint8_t type);
	void updateAmount(uint8_t type, uint16_t amount = 1);

	[[nodiscard]] std::vector<RecentDeathEntry> getDeathHistory() const;
	void insertDeathOnHistory(std::string cause, uint32_t timestamp);

	[[nodiscard]] std::vector<RecentPvPKillEntry> getPvpKillsHistory() const;
	void insertPvpKillOnHistory(std::string cause, uint32_t timestamp, uint8_t status);

	Summary getSummary();

	[[nodiscard]] std::map<uint16_t, uint16_t> getResult(uint8_t type) const;
	void insertValue(uint8_t type, uint16_t amount = 1, const std::string &id = "");

private:
	std::vector<RecentDeathEntry> m_deathHistory;
	std::vector<RecentPvPKillEntry> m_pvpKillsHistory;
	Player &m_player;
};
