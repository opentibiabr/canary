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
class PropStream;
class PropWriteStream;

class AnimusMastery {
public:
	explicit AnimusMastery(Player &player);

	void add(const std::string &addMonsterType);
	void remove(const std::string &removeMonsterType);

	bool has(const std::string &searchMonsterType) const;

	float getExperienceMultiplier() const;

	uint16_t getPoints() const;

	const std::vector<std::string> &getAnimusMasteries() const;

	void serialize(PropWriteStream &propWriteStream) const;
	bool unserialize(PropStream &propStream);

private:
	Player &m_player;

	float maxMonsterXpMultiplier = 4.0;
	float monsterXpMultiplier = 2.0;
	float monstersXpMultiplier = 0.1;
	uint16_t monstersAmountToMultiply = 10;

	std::vector<std::string> animusMasteries;
};
