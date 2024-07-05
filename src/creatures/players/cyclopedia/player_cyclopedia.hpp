/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/creatures_definitions.hpp"
#include "enums/player_cyclopedia.hpp"

class Player;
class KV;

struct Summary {
	uint16_t m_preyWildcards = 0;
	uint16_t m_instantRewards = 0;
	uint16_t m_hirelings = 0;

	[[maybe_unused]] Summary(uint16_t mPreyWildcards, uint16_t mInstantRewards, uint16_t mHirelings) :
		m_preyWildcards(mPreyWildcards), m_instantRewards(mInstantRewards), m_hirelings(mHirelings) { }
};

class PlayerCyclopedia {
public:
	explicit PlayerCyclopedia(Player &player);

	Summary getSummary();

	void loadSummaryData();
	void loadDeathHistory(uint16_t page, uint16_t entriesPerPage);
	void loadRecentKills(uint16_t page, uint16_t entriesPerPage);

	void updateStoreSummary(uint8_t type, uint16_t amount = 1, const std::string &id = "");
	uint16_t getAmount(uint8_t type);
	void updateAmount(uint8_t type, uint16_t amount = 1);

	[[nodiscard]] std::map<uint16_t, uint16_t> getResult(uint8_t type) const;
	void insertValue(uint8_t type, uint16_t amount = 1, const std::string &id = "");

private:
	Player &m_player;
};
