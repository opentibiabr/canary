/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/animus_mastery/animus_mastery.hpp"
#include "creatures/players/player.hpp"
#include "config/configmanager.hpp"

AnimusMastery::AnimusMastery(Player &player) :
	m_player(player),
	maxMonsterXpMultiplier(g_configManager().getFloat(ANIMUS_MASTERY_MAX_MONSTER_XP_MULTIPLIER)),
	monsterXpMultiplier(g_configManager().getFloat(ANIMUS_MASTERY_MONSTER_XP_MULTIPLIER)),
	monstersXpMultiplier(g_configManager().getFloat(ANIMUS_MASTERY_MONSTERS_XP_MULTIPLIER)),
	monstersAmountToMultiply(g_configManager().getFloat(ANIMUS_MASTERY_MONSTERS_TO_INCREASE_XP_MULTIPLIER)) { }

void AnimusMastery::add(std::string_view addMonsterType) {
	if (!has(addMonsterType)) {
		animusMasteries.emplace_back(addMonsterType);
	}
}

void AnimusMastery::remove(std::string_view removeMonsterType) {
	std::erase_if(animusMasteries, [removeMonsterType](const std::string &monsterType) {
		return monsterType == removeMonsterType;
	});
}

bool AnimusMastery::has(std::string_view searchMonsterType) const {
	auto it = std::ranges::find(animusMasteries, searchMonsterType);

	return it != animusMasteries.end();
}

float AnimusMastery::getExperienceMultiplier() const {
	uint16_t monsterAmountMultiplier = animusMasteries.size() / monstersAmountToMultiply;

	return std::min(maxMonsterXpMultiplier, 1 + (monsterAmountMultiplier * monstersXpMultiplier));
}

const std::vector<std::string> &AnimusMastery::getAnimusMasteries() const {
	return animusMasteries;
}
