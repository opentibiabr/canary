/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/components/pvp/expert_pvp.hpp"

#include <gtest/gtest.h>

TEST(ExpertPvpModeTest, AcceptsKnownClientModes) {
	const auto dove = ExpertPvp::modeFromClientByte(0);
	EXPECT_EQ(PVP_MODE_DOVE, dove.mode);
	EXPECT_EQ(ExpertPvpModeSource::ClientByte, dove.source);
	EXPECT_TRUE(dove.accepted);
	EXPECT_FALSE(dove.normalized);

	const auto redFist = ExpertPvp::modeFromClientByte(3);
	EXPECT_EQ(PVP_MODE_RED_FIST, redFist.mode);
	EXPECT_EQ(ExpertPvpModeSource::ClientByte, redFist.source);
	EXPECT_TRUE(redFist.accepted);
	EXPECT_FALSE(redFist.normalized);
}

TEST(ExpertPvpModeTest, NormalizesUnknownClientModeToDove) {
	const auto result = ExpertPvp::modeFromClientByte(99);

	EXPECT_EQ(PVP_MODE_DOVE, result.mode);
	EXPECT_EQ(ExpertPvpModeSource::ClientByte, result.source);
	EXPECT_FALSE(result.accepted);
	EXPECT_TRUE(result.normalized);
	EXPECT_EQ(ExpertPvpDecisionReason::InvalidMode, result.reason);
}

TEST(ExpertPvpModeTest, DefaultClientModeIsDove) {
	const auto result = ExpertPvp::defaultModeForClient();

	EXPECT_EQ(PVP_MODE_DOVE, result.mode);
	EXPECT_EQ(ExpertPvpModeSource::DefaultForClient, result.source);
	EXPECT_TRUE(result.accepted);
	EXPECT_FALSE(result.normalized);
}

TEST(ExpertPvpRelationTest, ClassifiesSelfBeforeOtherRelations) {
	ExpertPvpRelationContext context;
	context.isSelf = true;
	context.directAttacker = true;
	context.skulledTarget = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::Self, result.relation);
	EXPECT_TRUE(result.facts.isSelf);
}

TEST(ExpertPvpRelationTest, ClassifiesPlayerSummonBeforeMonster) {
	ExpertPvpRelationContext context;
	context.subjectIsMonster = true;
	context.subjectIsPlayerSummon = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::PlayerSummon, result.relation);
}

TEST(ExpertPvpRelationTest, ClassifiesNeutralPlayerAsFallback) {
	ExpertPvpRelationContext context;
	context.subjectIsPlayer = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, result.relation);
}
