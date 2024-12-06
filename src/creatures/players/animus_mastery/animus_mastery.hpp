/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Player;

class AnimusMastery {
public:
	explicit AnimusMastery(Player &player);

	void add(std::string_view addMonsterType);
	void remove(std::string_view removeMonsterType);

	bool has(std::string_view searchMonsterType) const;

	float getExperienceMultiplier() const;

	const std::vector<std::string> &getAnimusMasteries() const;

private:
	Player &m_player;

	float maxMonsterXpMultiplier = 4.0;
	float monsterXpMultiplier = 2.0;
	float monstersXpMultiplier = 0.1;
	uint16_t monstersAmountToMultiply = 10;

	std::vector<std::string> animusMasteries;
};
