/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/components/pvp/expert_pvp.hpp"
#include "utils/utils_definitions.hpp"

#include <gtest/gtest.h>

TEST(ExpertPvpWorldTypeTest, EnablesExpertOnlyForExpertPvpWorldType) {
	EXPECT_TRUE(ExpertPvp::isExpertPvpWorldTypeName("expert-pvp"));
	EXPECT_TRUE(ExpertPvp::isExpertPvpWorldTypeName("EXPERT-PVP"));
	EXPECT_FALSE(ExpertPvp::isExpertPvpWorldTypeName("retro-pvp"));
	EXPECT_FALSE(ExpertPvp::isExpertPvpWorldTypeName("pvp"));
	EXPECT_FALSE(ExpertPvp::isExpertPvpWorldTypeName("no-pvp"));
	EXPECT_FALSE(ExpertPvp::isExpertPvpWorldTypeName("pvp-enforced"));
}

TEST(ExpertPvpWorldTypeTest, TreatsLegacyPvpAsRetroCompatibilityAlias) {
	EXPECT_TRUE(ExpertPvp::isRetroPvpWorldTypeName("retro-pvp"));
	EXPECT_TRUE(ExpertPvp::isRetroPvpWorldTypeName("RETRO-PVP"));
	EXPECT_TRUE(ExpertPvp::isRetroPvpWorldTypeName("pvp"));
	EXPECT_FALSE(ExpertPvp::isRetroPvpWorldTypeName("expert-pvp"));
	EXPECT_FALSE(ExpertPvp::isRetroPvpWorldTypeName("no-pvp"));
	EXPECT_FALSE(ExpertPvp::isRetroPvpWorldTypeName("pvp-enforced"));
}

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

TEST(ExpertPvpRelationTest, ClassifiesPlayerSummonOwnerCombatBeforeSummonFallback) {
	ExpertPvpRelationContext context;
	context.subjectIsMonster = true;
	context.subjectIsPlayerSummon = true;
	context.directAttacker = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::DirectAttacker, result.relation);
}

TEST(ExpertPvpRelationTest, ClassifiesNeutralPlayerAsFallback) {
	ExpertPvpRelationContext context;
	context.subjectIsPlayer = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, result.relation);
}

TEST(ExpertPvpRelationTest, ClassifiesProtectedAllyAttacker) {
	ExpertPvpRelationContext context;
	context.subjectIsPlayer = true;
	context.protectedAllyAttacker = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::ProtectedAllyAttacker, result.relation);
}

TEST(ExpertPvpRelationTest, KeepsAlliesAheadOfStaleAggression) {
	ExpertPvpRelationContext context;
	context.subjectIsPlayer = true;
	context.partyAlly = true;
	context.directAttacker = true;

	const auto result = ExpertPvp::classifyRelation(context);

	EXPECT_EQ(ExpertPvpRelation::PartyAlly, result.relation);
}

TEST(ExpertPvpCombatDecisionTest, DoveDeniesNeutralPlayerCombat) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateCombatAction(PVP_MODE_DOVE, ExpertPvpActionKind::DirectAttack, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.allowed);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpCombatDecisionTest, DoveAllowsDirectDefenseWithoutPzLock) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directAttacker = true;

	const auto decision = ExpertPvp::evaluateCombatAction(PVP_MODE_DOVE, ExpertPvpActionKind::DirectAttack, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.allowed);
	EXPECT_TRUE(decision.startsFight);
	EXPECT_FALSE(decision.appliesPzLock);
	EXPECT_EQ(ExpertPvpRelation::DirectAttacker, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::DirectCombat, decision.reason);
}

TEST(ExpertPvpCombatDecisionTest, WhiteProtectsPartyAndGuildMembers) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.protectedAllyAttacker = true;

	const auto doveDecision = ExpertPvp::evaluateCombatAction(PVP_MODE_DOVE, ExpertPvpActionKind::DirectAttack, context);
	const auto whiteDecision = ExpertPvp::evaluateCombatAction(PVP_MODE_WHITE_HAND, ExpertPvpActionKind::DirectAttack, context);

	EXPECT_FALSE(doveDecision.allowed);
	EXPECT_TRUE(whiteDecision.allowed);
	EXPECT_FALSE(whiteDecision.appliesPzLock);
	EXPECT_EQ(ExpertPvpRelation::ProtectedAllyAttacker, whiteDecision.relation);
}

TEST(ExpertPvpCombatDecisionTest, DoveDeniesNeutralPlayerSummonCombat) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsMonster = true;
	context.subjectIsPlayerSummon = true;

	const auto decision = ExpertPvp::evaluateCombatAction(PVP_MODE_DOVE, ExpertPvpActionKind::DirectAttack, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.allowed);
	EXPECT_EQ(ExpertPvpRelation::PlayerSummon, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpCombatDecisionTest, YellowAllowsSkulledTargets) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.skulledTarget = true;

	const auto decision = ExpertPvp::evaluateCombatAction(PVP_MODE_YELLOW_HAND, ExpertPvpActionKind::DirectAttack, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.allowed);
	EXPECT_EQ(ExpertPvpRelation::SkulledTarget, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::SkulledTarget, decision.reason);
}

TEST(ExpertPvpCombatDecisionTest, RedAllowsNeutralPlayerWithSideEffectDescription) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateCombatAction(PVP_MODE_RED_FIST, ExpertPvpActionKind::DirectAttack, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.allowed);
	EXPECT_TRUE(decision.startsFight);
	EXPECT_TRUE(decision.appliesPzLock);
	EXPECT_TRUE(decision.countsUnjustified);
	EXPECT_EQ(100, decision.sideEffectOwnerGuid);
	EXPECT_EQ(ExpertPvpSkullAction::White, decision.skullAction);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpCombatDecisionTest, InvalidModeFailsClosed) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateCombatAction(static_cast<PvpMode_t>(99), ExpertPvpActionKind::DirectAttack, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.allowed);
	EXPECT_EQ(ExpertPvpDecisionReason::InvalidMode, decision.reason);
}

TEST(ExpertPvpWalkthroughDecisionTest, NeutralPlayersCanWalkThrough) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.canWalkThrough);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpWalkthroughDecisionTest, ActiveCombatBlocksWalkthrough) {
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directAttacker = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.canWalkThrough);
	EXPECT_EQ(ExpertPvpRelation::DirectAttacker, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::DirectCombat, decision.reason);
}

TEST(ExpertPvpFieldContextTest, BuildsMagicWallVisualIds) {
	const auto context = ExpertPvp::makeFieldContext(100, PVP_MODE_RED_FIST, ITEM_MAGICWALL_SAFE, true);

	EXPECT_EQ(100, context.ownerGuid);
	EXPECT_EQ(PVP_MODE_RED_FIST, context.ownerMode);
	EXPECT_EQ(ITEM_MAGICWALL, context.canonicalItemId);
	EXPECT_EQ(ITEM_MAGICWALL_SAFE, context.safeVisualItemId);
	EXPECT_EQ(ITEM_MAGICWALL, context.blockingVisualItemId);
	EXPECT_TRUE(context.ownerWasPlayerOrSummon);
}

TEST(ExpertPvpFieldContextTest, BuildsWildGrowthVisualIds) {
	const auto context = ExpertPvp::makeFieldContext(100, PVP_MODE_WHITE_HAND, ITEM_WILDGROWTH_PERSISTENT, true);

	EXPECT_EQ(PVP_MODE_WHITE_HAND, context.ownerMode);
	EXPECT_EQ(ITEM_WILDGROWTH, context.canonicalItemId);
	EXPECT_EQ(ITEM_WILDGROWTH_SAFE, context.safeVisualItemId);
	EXPECT_EQ(ITEM_WILDGROWTH, context.blockingVisualItemId);
}

TEST(ExpertPvpFieldContextTest, IgnoresUnsupportedFieldItems) {
	EXPECT_FALSE(ExpertPvp::isExpertFieldItem(ITEM_GOLD_COIN));

	const auto context = ExpertPvp::makeFieldContext(100, PVP_MODE_RED_FIST, ITEM_GOLD_COIN, true);
	EXPECT_FALSE(context);
}

TEST(ExpertPvpFieldContextTest, BuildsDamagingFieldOwnershipContext) {
	const auto context = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_FIREFIELD_PVP_FULL, true);

	EXPECT_TRUE(ExpertPvp::isExpertFieldItem(ITEM_FIREFIELD_PVP_FULL));
	EXPECT_EQ(100, context.ownerGuid);
	EXPECT_EQ(PVP_MODE_DOVE, context.ownerMode);
	EXPECT_EQ(ITEM_FIREFIELD_PVP_FULL, context.canonicalItemId);
	EXPECT_EQ(ITEM_FIREFIELD_PVP_FULL, context.safeVisualItemId);
	EXPECT_EQ(ITEM_FIREFIELD_PVP_FULL, context.blockingVisualItemId);
}

TEST(ExpertPvpFieldDamageDecisionTest, DoveFieldDoesNotDamageNeutralPlayers) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_FIREFIELD_PVP_FULL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateFieldDamage(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.applyDamage);
	EXPECT_FALSE(decision.setConditionOwner);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpFieldDamageDecisionTest, RedFieldDamagesNeutralPlayersWithOwnerGuid) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_RED_FIST, ITEM_FIREFIELD_PVP_FULL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateFieldDamage(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.applyDamage);
	EXPECT_TRUE(decision.setConditionOwner);
	EXPECT_EQ(100, decision.conditionOwnerGuid);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpFieldStepDecisionTest, DoveFieldLetsNeutralPlayersStep) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.canStep);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpFieldStepDecisionTest, FieldOwnerIsBlockedByOwnWall) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 100;
	context.subjectIsPlayer = true;
	context.isSelf = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.canStep);
	EXPECT_EQ(ExpertPvpRelation::Self, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Self, decision.reason);
}

TEST(ExpertPvpFieldStepDecisionTest, ActiveCombatPlayersAreBlockedByWall) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directAttacker = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.canStep);
	EXPECT_EQ(ExpertPvpRelation::DirectAttacker, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::DirectCombat, decision.reason);
}

TEST(ExpertPvpFieldStepDecisionTest, WhiteFieldBlocksProtectedAllyAttacker) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_WHITE_HAND, ITEM_MAGICWALL, true);
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.protectedAllyAttacker = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_FALSE(decision.canStep);
	EXPECT_FALSE(decision.appliesPzLock);
	EXPECT_EQ(ExpertPvpRelation::ProtectedAllyAttacker, decision.relation);
}

TEST(ExpertPvpFieldStepDecisionTest, YellowFieldBlocksSkulledNonAlly) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_YELLOW_HAND, ITEM_WILDGROWTH, true);
	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.skulledTarget = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_FALSE(decision.canStep);
	EXPECT_FALSE(decision.appliesPzLock);
	EXPECT_EQ(ExpertPvpRelation::SkulledTarget, decision.relation);
}

TEST(ExpertPvpWalkthroughDecisionTest, DoveDoesNotBlockProtectedAllyAttacker) {
	ExpertPvpRelationContext context;
	context.actorMode = PVP_MODE_DOVE;
	context.subjectIsPlayer = true;
	context.protectedAllyAttacker = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_TRUE(decision.canWalkThrough);
}

TEST(ExpertPvpWalkthroughDecisionTest, WhiteBlocksProtectedAllyAttacker) {
	ExpertPvpRelationContext context;
	context.actorMode = PVP_MODE_WHITE_HAND;
	context.subjectIsPlayer = true;
	context.protectedAllyAttacker = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_FALSE(decision.canWalkThrough);
	EXPECT_EQ(ExpertPvpRelation::ProtectedAllyAttacker, decision.relation);
}

TEST(ExpertPvpWalkthroughDecisionTest, YellowBlocksSkulledNonAlly) {
	ExpertPvpRelationContext context;
	context.actorMode = PVP_MODE_YELLOW_HAND;
	context.subjectIsPlayer = true;
	context.skulledTarget = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_FALSE(decision.canWalkThrough);
	EXPECT_EQ(ExpertPvpDecisionReason::SkulledTarget, decision.reason);
}

TEST(ExpertPvpWalkthroughDecisionTest, RedBlocksNeutralNonAlly) {
	ExpertPvpRelationContext context;
	context.actorMode = PVP_MODE_RED_FIST;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_FALSE(decision.canWalkThrough);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
}

TEST(ExpertPvpWalkthroughDecisionTest, RedLetsPartyAllyPass) {
	ExpertPvpRelationContext context;
	context.actorMode = PVP_MODE_RED_FIST;
	context.subjectIsPlayer = true;
	context.partyAlly = true;

	const auto decision = ExpertPvp::evaluateWalkthrough(context);

	EXPECT_TRUE(decision.canWalkThrough);
	EXPECT_EQ(ExpertPvpRelation::PartyAlly, decision.relation);
}

TEST(ExpertPvpFieldStepDecisionTest, RedFieldVictimWhoHasNotRetaliatedCanStep) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_RED_FIST, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directTarget = true;
	context.skulledTarget = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_TRUE(decision.canStep);
	EXPECT_EQ(ExpertPvpRelation::DirectTarget, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::DirectCombat, decision.reason);
}

TEST(ExpertPvpFieldStepDecisionTest, RedFieldBlocksNeutralPlayersWithSideEffectDescription) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_RED_FIST, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::evaluateFieldStep(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_FALSE(decision.canStep);
	EXPECT_EQ(100, decision.sideEffectOwnerGuid);
	EXPECT_EQ(ExpertPvpSkullAction::White, decision.skullAction);
	EXPECT_TRUE(decision.appliesPzLock);
	EXPECT_FALSE(decision.startsFight);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
	EXPECT_EQ(ExpertPvpDecisionReason::Neutral, decision.reason);
}

TEST(ExpertPvpFieldVisualDecisionTest, NeutralPlayersSeeSafeWallVisual) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;

	const auto decision = ExpertPvp::getFieldClientId(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_EQ(ITEM_MAGICWALL_SAFE, decision.clientItemId);
	EXPECT_EQ(ExpertPvpRelation::NeutralPlayer, decision.relation);
}

TEST(ExpertPvpFieldVisualDecisionTest, OwnerSeesBlockingWallVisual) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 100;
	context.subjectIsPlayer = true;
	context.isSelf = true;

	const auto decision = ExpertPvp::getFieldClientId(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_EQ(ITEM_MAGICWALL, decision.clientItemId);
	EXPECT_EQ(ExpertPvpRelation::Self, decision.relation);
}

TEST(ExpertPvpFieldVisualDecisionTest, OwnerSeesBlockingWallVisualFromSafeBackedField) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL_SAFE, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 100;
	context.subjectIsPlayer = true;
	context.isSelf = true;

	const auto decision = ExpertPvp::getFieldClientId(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_EQ(ITEM_MAGICWALL, decision.clientItemId);
	EXPECT_EQ(ExpertPvpRelation::Self, decision.relation);
}

TEST(ExpertPvpFieldVisualDecisionTest, ActiveCombatPlayersSeeBlockingWallVisual) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directAttacker = true;

	const auto decision = ExpertPvp::getFieldClientId(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_EQ(ITEM_MAGICWALL, decision.clientItemId);
	EXPECT_EQ(ExpertPvpRelation::DirectAttacker, decision.relation);
}

TEST(ExpertPvpFieldVisualDecisionTest, RedFieldVictimWhoHasNotRetaliatedSeesSafeWallVisual) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_RED_FIST, ITEM_MAGICWALL_SAFE, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directTarget = true;
	context.skulledTarget = true;

	const auto decision = ExpertPvp::getFieldClientId(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_EQ(ITEM_MAGICWALL_SAFE, decision.clientItemId);
	EXPECT_EQ(ExpertPvpRelation::DirectTarget, decision.relation);
}

TEST(ExpertPvpFieldVisualDecisionTest, ActiveCombatPlayersSeeBlockingWallVisualFromSafeBackedField) {
	const auto field = ExpertPvp::makeFieldContext(100, PVP_MODE_DOVE, ITEM_MAGICWALL_SAFE, true);

	ExpertPvpRelationContext context;
	context.actorGuid = 100;
	context.actorMode = field.ownerMode;
	context.subjectGuid = 200;
	context.subjectIsPlayer = true;
	context.directAttacker = true;

	const auto decision = ExpertPvp::getFieldClientId(field, context);

	EXPECT_TRUE(decision.handled);
	EXPECT_EQ(ITEM_MAGICWALL, decision.clientItemId);
	EXPECT_EQ(ExpertPvpRelation::DirectAttacker, decision.relation);
}
