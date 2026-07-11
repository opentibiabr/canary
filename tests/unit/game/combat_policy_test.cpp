#include "creatures/combat/functions/chain_target_policy.hpp"
#include "game/functions/wheel_damage_policy.hpp"

TEST(ChainTargetPolicyTest, RejectsNpcCasterAndAggressiveProtectionZoneTargets) {
	EXPECT_TRUE(ChainTargetPolicy::shouldRejectDefaultTarget(true, false, false, false));
	EXPECT_TRUE(ChainTargetPolicy::shouldRejectDefaultTarget(false, true, false, false));
	EXPECT_TRUE(ChainTargetPolicy::shouldRejectDefaultTarget(false, false, true, true));
	EXPECT_FALSE(ChainTargetPolicy::shouldRejectDefaultTarget(false, false, false, true));
	EXPECT_FALSE(ChainTargetPolicy::shouldRejectDefaultTarget(false, false, true, false));
}

TEST(WheelDamagePolicyTest, SkipsReflectedDamage) {
	EXPECT_TRUE(WheelDamagePolicy::shouldApplyWheelEffects(false));
	EXPECT_FALSE(WheelDamagePolicy::shouldApplyWheelEffects(true));
}
