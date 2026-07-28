/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_relevance.hpp"

namespace {
	constexpr uint16_t ENTER_VISIBLE_DISTANCE = 10;
	constexpr uint16_t EXIT_VISIBLE_DISTANCE = 12;
}

MonsterRelevanceState MonsterRelevancePolicy::update(const MonsterRelevanceState &current, const MonsterRelevanceSnapshot &snapshot, Clock::time_point now, std::chrono::milliseconds visibleHold) {
	auto next = current;
	const bool entersVisible = snapshot.engagedWithPlayer
		|| (snapshot.playerSpectators > 0 && snapshot.nearestPlayerDistance <= ENTER_VISIBLE_DISTANCE);
	const bool remainsVisible = entersVisible
		|| (current.tier == MonsterRelevanceTier::Visible && snapshot.playerSpectators > 0 && snapshot.nearestPlayerDistance <= EXIT_VISIBLE_DISTANCE);

	if (remainsVisible) {
		next.tier = MonsterRelevanceTier::Visible;
		next.visibleUntil = now + visibleHold;
	} else if (current.tier == MonsterRelevanceTier::Visible && now < current.visibleUntil) {
		next.tier = MonsterRelevanceTier::Visible;
	} else {
		next.tier = MonsterRelevanceTier::Background;
		next.visibleUntil = {};
	}
	return next;
}
