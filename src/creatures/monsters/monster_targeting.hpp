/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <stop_token>
	#include <vector>
#endif

enum class MonsterTargetRankMode : uint8_t {
	Nearest,
	Health,
	Damage
};

struct MonsterTargetCandidate {
	uint32_t creatureId = 0;
	Position position;
	int32_t faction = 0;
	int32_t health = 0;
	int32_t damage = 0;
	bool hasDamage = false;
};

struct MonsterTargetRankingRequest {
	MonsterTargetRankMode mode = MonsterTargetRankMode::Nearest;
	Position origin;
	std::vector<MonsterTargetCandidate> candidates;
};

struct MonsterTargetRankingResult {
	uint32_t suggestedCreatureId = 0;
	bool canceled = false;
};

class MonsterTargetRanker final {
public:
	[[nodiscard]] static MonsterTargetRankingResult rank(const MonsterTargetRankingRequest &request, std::stop_token stopToken = {});
};
