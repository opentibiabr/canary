/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"
#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <map>
	#include <string>
	#include <vector>
#endif

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
	struct DiscoveryPoint {
		Position position;
		uint8_t state = 0; // Hidden, close, reached. Wire states are state-1.
	};
	struct DiscoveryProgress {
		uint16_t area;
		uint8_t grade;
		uint8_t percent;
	};
	bool loadDiscovery();
	std::string startDiscovery(uint16_t subarea);
	void onDiscoveryMove(bool teleport);
	void sendDiscoveryEffects();
	std::vector<DiscoveryProgress> discoveryProgress();
	std::vector<uint16_t> discoverableAreas() const;
	std::vector<uint16_t> completedDiscoveryAreas() const;
	uint16_t activeDiscoveryArea() const {
		return discoveryActive;
	}
	uint16_t currentDiscoveryArea() const;
	const std::vector<DiscoveryPoint> &discoveryPoints() const;
	explicit PlayerCyclopedia(Player &player);

	Summary getSummary() const;

	void loadSummaryData() const;
	void loadDeathHistory(uint16_t page, uint16_t entriesPerPage) const;
	void loadRecentKills(uint16_t page, uint16_t entriesPerPage) const;

	void updateStoreSummary(uint8_t type, uint16_t amount = 1, const std::string &id = "") const;
	uint16_t getAmount(uint8_t type) const;
	void updateAmount(uint8_t type, uint16_t amount = 1) const;

	[[nodiscard]] std::map<uint16_t, uint16_t> getResult(uint8_t type) const;
	void insertValue(uint8_t type, uint16_t amount = 1, const std::string &id = "") const;

private:
	Player &m_player;
	bool discoveryLoaded = false;
	std::string discoverySnapshot;
	uint64_t discoveryRetryAfter = 0;
	uint64_t discoveryNextReset = 0;
	uint64_t discoveryNextWrite = 0;
	uint64_t discoveryNextEffects = 0;
	uint16_t discoveryActive = 0;
	uint16_t discoveryLastArea = UINT16_MAX;
	std::map<uint16_t, std::vector<DiscoveryPoint>> discoveryState;
	bool saveDiscovery(uint16_t area, const std::vector<DiscoveryPoint> &points);
};
