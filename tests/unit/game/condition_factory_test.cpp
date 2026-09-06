/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/combat/condition.hpp"

TEST(ConditionFactoryTest, CreatesSupportedDamageConditions) {
	constexpr uint32_t testSubId = 42;
	constexpr std::array damageConditionTypes {
		CONDITION_POISON,
		CONDITION_FIRE,
		CONDITION_ENERGY,
		CONDITION_DROWN,
		CONDITION_FREEZING,
		CONDITION_DAZZLED,
		CONDITION_CURSED,
		CONDITION_BLEEDING,
	};

	for (const auto conditionType : damageConditionTypes) {
		const auto condition = Condition::createDamageCondition(CONDITIONID_COMBAT, conditionType, false, testSubId);

		ASSERT_TRUE(condition);
		EXPECT_EQ(conditionType, condition->getType());
		EXPECT_EQ(CONDITIONID_COMBAT, condition->getId());
		EXPECT_EQ(testSubId, condition->getSubId());
	}
}

TEST(ConditionFactoryTest, RejectsNonDamageCondition) {
	EXPECT_FALSE(Condition::createDamageCondition(CONDITIONID_COMBAT, CONDITION_HASTE));
}

TEST(ConditionFactoryTest, RejectsUnsupportedCondition) {
	EXPECT_FALSE(Condition::createDamageCondition(CONDITIONID_COMBAT, CONDITION_AGONY));
}

TEST(ConditionFactoryTest, PreservesGenericDamageConditionCreation) {
	const auto condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_FIRE, 0);

	ASSERT_TRUE(condition);
	EXPECT_EQ(CONDITION_FIRE, condition->getType());
	EXPECT_EQ(CONDITIONID_COMBAT, condition->getId());
}
