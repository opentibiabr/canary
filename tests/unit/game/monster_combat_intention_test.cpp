/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_combat_intention.hpp"

TEST(MonsterCombatIntentionEvaluatorTest, ReturnsEnabledInRangeIndicesInSourceOrder) {
	MonsterCombatIntentionRequest request;
	request.origin = Position(100, 100, 7);
	request.target = Position(103, 102, 7);
	request.spells = {
		{ .index = 0, .range = 1, .enabled = true },
		{ .index = 1, .range = 3, .enabled = true },
		{ .index = 2, .range = 0, .enabled = true },
		{ .index = 3, .range = 8, .enabled = false },
	};

	const auto result = MonsterCombatIntentionEvaluator::evaluate(request);
	EXPECT_EQ(result.geometricallyEligibleSpellIndices, (std::vector<uint32_t> { 1, 2 }));
	EXPECT_FALSE(result.canceled);
}

TEST(MonsterCombatIntentionEvaluatorTest, ExcludesMeleeWhileFleeing) {
	MonsterCombatIntentionRequest request;
	request.origin = Position(100, 100, 7);
	request.target = Position(101, 100, 7);
	request.fleeing = true;
	request.spells = {
		{ .index = 4, .range = 1, .enabled = true, .melee = true },
		{ .index = 5, .range = 1, .enabled = true, .melee = false },
	};

	const auto result = MonsterCombatIntentionEvaluator::evaluate(request);
	EXPECT_EQ(result.geometricallyEligibleSpellIndices, (std::vector<uint32_t> { 5 }));
}

TEST(MonsterCombatIntentionEvaluatorTest, RejectsDifferentFloorsAndCancellation) {
	MonsterCombatIntentionRequest request;
	request.origin = Position(100, 100, 7);
	request.target = Position(100, 100, 8);
	request.spells = { { .index = 1, .range = 0, .enabled = true } };
	EXPECT_TRUE(MonsterCombatIntentionEvaluator::evaluate(request).geometricallyEligibleSpellIndices.empty());

	request.target.z = request.origin.z;
	std::stop_source stopSource;
	stopSource.request_stop();
	const auto canceled = MonsterCombatIntentionEvaluator::evaluate(request, stopSource.get_token());
	EXPECT_TRUE(canceled.canceled);
	EXPECT_TRUE(canceled.geometricallyEligibleSpellIndices.empty());
}
