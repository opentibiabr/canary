/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"

TEST(WeaponProficiencyTest, HomingMissilePerkKeepsOfficialTypeAndFields) {
	static_assert(static_cast<uint8_t>(WeaponProficiencyBonus_t::HOMING_MISSILE) == 32);

	Player player;
	ProficiencyPerk perk;
	perk.type = WeaponProficiencyBonus_t::HOMING_MISSILE;
	perk.element = COMBAT_HOLYDAMAGE;
	perk.missileId = 74;
	perk.multiplier = 2.0;
	perk.probability = 0.01;

	const auto serialized = player.weaponProficiency().serializePerk(perk);
	const auto deserialized = WeaponProficiency::deserializePerk(serialized);

	EXPECT_EQ(deserialized.type, WeaponProficiencyBonus_t::HOMING_MISSILE);
	EXPECT_EQ(deserialized.element, COMBAT_HOLYDAMAGE);
	EXPECT_EQ(deserialized.missileId, 74);
	EXPECT_DOUBLE_EQ(deserialized.multiplier, 2.0);
	EXPECT_DOUBLE_EQ(deserialized.probability, 0.01);
}

TEST(WeaponProficiencyTest, ShapingPoolMatchesCurrentClientCatalog) {
	std::vector<uint16_t> allPerkIds;
	for (uint16_t vocationId = VOCATION_KNIGHT_CIP; vocationId <= VOCATION_MONK_CIP; ++vocationId) {
		auto perkIds = WeaponProficiency::getShapingPerkPool(vocationId);
		ASSERT_EQ(perkIds.size(), 64);
		allPerkIds.insert(allPerkIds.end(), perkIds.begin(), perkIds.end());

		std::ranges::sort(perkIds);
		const auto uniqueIds = std::ranges::unique(perkIds);
		EXPECT_EQ(std::ranges::distance(perkIds.begin(), uniqueIds.begin()), perkIds.size());
		EXPECT_TRUE(std::ranges::binary_search(perkIds, 251));
		EXPECT_TRUE(std::ranges::binary_search(perkIds, 323));

		const auto vocationBaseId = static_cast<uint16_t>(1 + (vocationId - VOCATION_KNIGHT_CIP) * 50);
		EXPECT_TRUE(std::ranges::binary_search(perkIds, vocationBaseId));
		EXPECT_TRUE(std::ranges::binary_search(perkIds, static_cast<uint16_t>(vocationBaseId + 45)));
	}

	std::ranges::sort(allPerkIds);
	const auto uniquePerkIds = std::ranges::unique(allPerkIds);
	EXPECT_EQ(std::ranges::distance(allPerkIds.begin(), uniquePerkIds.begin()), 184);
	EXPECT_TRUE(WeaponProficiency::getShapingPerkPool(VOCATION_NONE).empty());
}

TEST(WeaponProficiencyTest, ShapedPerkDefinitionsUseDocumentedRankValues) {
	const auto bestiaryRankZero = WeaponProficiency::getShapedPerkDefinition(251, 0, SKILL_DISTANCE);
	ASSERT_TRUE(bestiaryRankZero.has_value());
	EXPECT_EQ(bestiaryRankZero->type, WeaponProficiencyBonus_t::WEAPON_PROFICIENCY_BESTIARY);
	EXPECT_EQ(bestiaryRankZero->bestiaryId, 1);
	EXPECT_EQ(bestiaryRankZero->bestiaryName, "Amphibic");
	EXPECT_DOUBLE_EQ(bestiaryRankZero->value, 0.005);

	const auto skillRankTen = WeaponProficiency::getShapedPerkDefinition(292, 10, SKILL_MAGLEVEL);
	ASSERT_TRUE(skillRankTen.has_value());
	EXPECT_EQ(skillRankTen->type, WeaponProficiencyBonus_t::SKILL_PERCENTAGE_SPELL_DAMAGE);
	EXPECT_EQ(skillRankTen->skillId, SKILL_MAGLEVEL);
	EXPECT_DOUBLE_EQ(skillRankTen->value, 0.08);

	const auto knightAugment = WeaponProficiency::getShapedPerkDefinition(1, 10, SKILL_SWORD);
	ASSERT_TRUE(knightAugment.has_value());
	EXPECT_EQ(knightAugment->type, WeaponProficiencyBonus_t::SPELL_AUGMENT);
	EXPECT_EQ(knightAugment->spellId, 80);
	EXPECT_EQ(knightAugment->augmentType, 17);
	EXPECT_DOUBLE_EQ(knightAugment->value, 0.03);

	EXPECT_FALSE(WeaponProficiency::getShapedPerkDefinition(999, 0, SKILL_FIST).has_value());
	EXPECT_FALSE(WeaponProficiency::getShapedPerkDefinition(251, 11, SKILL_FIST).has_value());
}

TEST(WeaponProficiencyTest, ShapingCostsFollowOfficialProgression) {
	EXPECT_EQ(WeaponProficiency::getShapingSlotCost(0), 250);
	EXPECT_EQ(WeaponProficiency::getShapingSlotCost(1), 1000);
	EXPECT_EQ(WeaponProficiency::getShapingSlotCost(2), 0);

	uint32_t totalRefineCost = 0;
	for (uint8_t rank = 0; rank < 10; ++rank) {
		totalRefineCost += WeaponProficiency::getShapingRefineCost(rank);
	}
	EXPECT_EQ(totalRefineCost, 4625);
	EXPECT_EQ(WeaponProficiency::getShapingRefineCost(10), 0);
}
