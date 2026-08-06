/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_combat_intention.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

MonsterCombatIntentionResult MonsterCombatIntentionEvaluator::evaluate(const MonsterCombatIntentionRequest &request, std::stop_token stopToken) {
	MonsterCombatIntentionResult result;
	if (stopToken.stop_requested()) {
		result.canceled = true;
		return result;
	}
	if (request.origin.z != request.target.z) {
		return result;
	}

	const auto distance = std::max<uint32_t>(Position::getDistanceX(request.origin, request.target), Position::getDistanceY(request.origin, request.target));
	result.geometricallyEligibleSpellIndices.reserve(request.spells.size());
	for (const auto &spell : request.spells) {
		if (stopToken.stop_requested()) {
			result.geometricallyEligibleSpellIndices.clear();
			result.canceled = true;
			return result;
		}
		if (!spell.enabled || (spell.melee && request.fleeing)) {
			continue;
		}
		if (spell.range == 0 || distance <= spell.range) {
			result.geometricallyEligibleSpellIndices.emplace_back(spell.index);
		}
	}
	return result;
}
