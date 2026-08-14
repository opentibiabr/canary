/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monsters.hpp"

TEST(MonsterSpellTest, RejectsUnsupportedDamageCondition) {
	auto spell = std::make_shared<MonsterSpell>();
	spell->name = "combat";
	spell->conditionType = CONDITION_AGONY;
	spellBlock_t spellBlock;

	EXPECT_FALSE(g_monsters().deserializeSpell(spell, spellBlock, "agony monster"));
	EXPECT_FALSE(spellBlock.spell);
}

TEST(MonsterSpellTest, RejectsNonDamageCondition) {
	auto spell = std::make_shared<MonsterSpell>();
	spell->name = "combat";
	spell->conditionType = CONDITION_HASTE;
	spellBlock_t spellBlock;

	EXPECT_FALSE(g_monsters().deserializeSpell(spell, spellBlock, "haste monster"));
	EXPECT_FALSE(spellBlock.spell);
}
