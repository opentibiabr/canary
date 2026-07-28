/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_targeting.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <iterator>
	#include <limits>
#endif

MonsterTargetRankingResult MonsterTargetRanker::rank(const MonsterTargetRankingRequest &request, std::stop_token stopToken) {
	MonsterTargetRankingResult result;
	if (request.candidates.empty()) {
		return result;
	}
	if (stopToken.stop_requested()) {
		result.canceled = true;
		return result;
	}

	const MonsterTargetCandidate* selected = &request.candidates.front();
	switch (request.mode) {
		case MonsterTargetRankMode::Nearest: {
			int32_t minimumRange = std::max(Position::getDistanceX(request.origin, selected->position), Position::getDistanceY(request.origin, selected->position)) + selected->faction * 100;
			for (auto it = std::next(request.candidates.begin()); it != request.candidates.end(); ++it) {
				if (stopToken.stop_requested()) {
					result.canceled = true;
					return result;
				}
				const int32_t distance = std::max(Position::getDistanceX(request.origin, it->position), Position::getDistanceY(request.origin, it->position)) + it->faction * 100;
				if (distance < minimumRange) {
					selected = &*it;
					minimumRange = distance;
				}
			}
			break;
		}
		case MonsterTargetRankMode::Health: {
			int32_t minimumHealth = selected->health + selected->faction * 100000;
			for (auto it = std::next(request.candidates.begin()); it != request.candidates.end(); ++it) {
				if (stopToken.stop_requested()) {
					result.canceled = true;
					return result;
				}
				const int32_t health = it->health + it->faction * 100000;
				if (health < minimumHealth) {
					selected = &*it;
					minimumHealth = health;
				}
			}
			break;
		}
		case MonsterTargetRankMode::Damage: {
			int32_t mostDamage = selected->hasDamage ? selected->damage + selected->faction * 100000 : std::numeric_limits<int32_t>::min();
			for (auto it = std::next(request.candidates.begin()); it != request.candidates.end(); ++it) {
				if (stopToken.stop_requested()) {
					result.canceled = true;
					return result;
				}
				if (!it->hasDamage) {
					continue;
				}
				const int32_t factionOffset = it->faction * 100000;
				const int32_t damageScore = it->damage + factionOffset;
				if (damageScore > mostDamage) {
					mostDamage = damageScore;
					selected = &*it;
				}
			}
			break;
		}
	}

	result.suggestedCreatureId = selected->creatureId;
	return result;
}
