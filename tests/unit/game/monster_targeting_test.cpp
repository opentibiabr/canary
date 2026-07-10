/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_targeting.hpp"

namespace {
	MonsterTargetCandidate candidate(uint32_t id, uint16_t x, int32_t faction = 0, int32_t health = 100, int32_t damage = 0, bool hasDamage = true) {
		return MonsterTargetCandidate {
			.creatureId = id,
			.position = Position(x, 100, 7),
			.faction = faction,
			.health = health,
			.damage = damage,
			.hasDamage = hasDamage,
		};
	}
}

TEST(MonsterTargetRankerTest, PreservesNearestSelectionOffsetsAndCandidateOrder) {
	MonsterTargetRankingRequest request;
	request.mode = MonsterTargetRankMode::Nearest;
	request.origin = Position(100, 100, 7);
	request.candidates = {
		candidate(10, 105, 1),
		candidate(20, 101, 0),
	};

	const auto result = MonsterTargetRanker::rank(request);
	EXPECT_EQ(result.suggestedCreatureId, 10);
	EXPECT_FALSE(result.canceled);
}

TEST(MonsterTargetRankerTest, PreservesHealthSelectionOffsetsAndCandidateOrder) {
	MonsterTargetRankingRequest request;
	request.mode = MonsterTargetRankMode::Health;
	request.origin = Position(100, 100, 7);
	request.candidates = {
		candidate(10, 105, 1, 500),
		candidate(20, 104, 0, 100),
		candidate(30, 103, 0, 50),
	};

	const auto result = MonsterTargetRanker::rank(request);
	EXPECT_EQ(result.suggestedCreatureId, 30);
}

TEST(MonsterTargetRankerTest, PreservesDamageSelectionFallbackToFirstCandidate) {
	MonsterTargetRankingRequest request;
	request.mode = MonsterTargetRankMode::Damage;
	request.origin = Position(100, 100, 7);
	request.candidates = {
		candidate(10, 105, 0, 100, 1000),
		candidate(20, 104, 0, 100, 0),
	};

	const auto result = MonsterTargetRanker::rank(request);
	EXPECT_EQ(result.suggestedCreatureId, 10);
}

TEST(MonsterTargetRankerTest, SelectsHighestLaterDamageCandidate) {
	MonsterTargetRankingRequest request;
	request.mode = MonsterTargetRankMode::Damage;
	request.origin = Position(100, 100, 7);
	request.candidates = {
		candidate(10, 105, 0, 100, 1000),
		candidate(20, 104, 0, 100, 10),
		candidate(30, 103, 0, 100, 20),
	};

	const auto result = MonsterTargetRanker::rank(request);
	EXPECT_EQ(result.suggestedCreatureId, 30);
}

TEST(MonsterTargetRankerTest, PreservesDamageFactionOffsetProgression) {
	MonsterTargetRankingRequest request;
	request.mode = MonsterTargetRankMode::Damage;
	request.origin = Position(100, 100, 7);
	request.candidates = {
		candidate(10, 105, 0, 100, 1000),
		candidate(20, 104, 1, 100, 1),
		candidate(30, 103, 0, 100, 2),
	};

	const auto result = MonsterTargetRanker::rank(request);
	EXPECT_EQ(result.suggestedCreatureId, 30);
}

TEST(MonsterTargetRankerTest, IgnoresFactionOffsetWithoutRecordedDamage) {
	MonsterTargetRankingRequest request;
	request.mode = MonsterTargetRankMode::Damage;
	request.origin = Position(100, 100, 7);
	request.candidates = {
		candidate(10, 105, 0, 100, 1000),
		candidate(20, 104, 1, 100, 0, false),
	};

	const auto result = MonsterTargetRanker::rank(request);
	EXPECT_EQ(result.suggestedCreatureId, 10);
}

TEST(MonsterTargetRankerTest, HonorsCancellationAndEmptyInput) {
	MonsterTargetRankingRequest request;
	EXPECT_EQ(MonsterTargetRanker::rank(request).suggestedCreatureId, 0);

	request.candidates.emplace_back(candidate(10, 105));
	std::stop_source stopSource;
	stopSource.request_stop();
	const auto canceled = MonsterTargetRanker::rank(request, stopSource.get_token());
	EXPECT_TRUE(canceled.canceled);
	EXPECT_EQ(canceled.suggestedCreatureId, 0);
}
