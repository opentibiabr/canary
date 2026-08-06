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

struct MonsterCombatSpellGeometry {
	uint32_t index = 0;
	uint32_t range = 0;
	bool enabled = false;
	bool melee = false;
};

struct MonsterCombatIntentionRequest {
	Position origin;
	Position target;
	bool fleeing = false;
	std::vector<MonsterCombatSpellGeometry> spells;
};

struct MonsterCombatIntentionResult {
	std::vector<uint32_t> geometricallyEligibleSpellIndices;
	bool canceled = false;
};

class MonsterCombatIntentionEvaluator final {
public:
	[[nodiscard]] static MonsterCombatIntentionResult evaluate(const MonsterCombatIntentionRequest &request, std::stop_token stopToken = {});
};
