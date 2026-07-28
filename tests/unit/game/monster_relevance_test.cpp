/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_relevance.hpp"

using namespace std::chrono_literals;

TEST(MonsterRelevancePolicyTest, EntersImmediatelyAndUsesDistanceHysteresis) {
	const auto now = MonsterRelevancePolicy::Clock::time_point(10s);
	MonsterRelevanceState state;

	state = MonsterRelevancePolicy::update(state, { .playerSpectators = 1, .nearestPlayerDistance = 10 }, now);
	EXPECT_EQ(state.tier, MonsterRelevanceTier::Visible);

	state = MonsterRelevancePolicy::update(state, { .playerSpectators = 1, .nearestPlayerDistance = 12 }, now + 1s);
	EXPECT_EQ(state.tier, MonsterRelevanceTier::Visible);

	MonsterRelevanceState background;
	background = MonsterRelevancePolicy::update(background, { .playerSpectators = 1, .nearestPlayerDistance = 12 }, now);
	EXPECT_EQ(background.tier, MonsterRelevanceTier::Background);
}

TEST(MonsterRelevancePolicyTest, HoldsVisibilityThenExpiresWithoutSpectators) {
	const auto now = MonsterRelevancePolicy::Clock::time_point(10s);
	MonsterRelevanceState state;
	state = MonsterRelevancePolicy::update(state, { .engagedWithPlayer = true }, now, 3s);

	state = MonsterRelevancePolicy::update(state, {}, now + 2999ms, 3s);
	EXPECT_EQ(state.tier, MonsterRelevanceTier::Visible);

	state = MonsterRelevancePolicy::update(state, {}, now + 3s, 3s);
	EXPECT_EQ(state.tier, MonsterRelevanceTier::Background);
}

TEST(MonsterRelevancePolicyTest, PlayerEngagementOverridesDistance) {
	const auto now = MonsterRelevancePolicy::Clock::time_point(10s);
	const auto state = MonsterRelevancePolicy::update({}, { .nearestPlayerDistance = 100, .engagedWithPlayer = true }, now);
	EXPECT_EQ(state.tier, MonsterRelevanceTier::Visible);
}
