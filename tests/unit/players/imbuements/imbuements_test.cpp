#include "pch.hpp"

#include <gtest/gtest.h>

#include "creatures/players/imbuements/imbuements.hpp"
#include "../../../shared/imbuements/imbuements_test_fixture.hpp"

namespace {

	class ImbuementsUnitTest : public test::imbuements::ImbuementsTestBase {
	};

	TEST_F(ImbuementsUnitTest, LoadsBasePercentAndSkillBonus) {
		auto* base = g_imbuements().getBaseByID(1);
		ASSERT_NE(nullptr, base);
		EXPECT_EQ(42, base->percent);

		auto* imbuement = g_imbuements().getImbuement(1);
		ASSERT_NE(nullptr, imbuement);
		EXPECT_EQ("Precision", imbuement->getName());
		EXPECT_EQ("Boosts distance.", imbuement->getDescription());
		EXPECT_EQ(3, imbuement->skills[SKILL_DISTANCE]);
	}

} // namespace
