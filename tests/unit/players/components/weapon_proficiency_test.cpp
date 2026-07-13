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
