/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/movement/position.hpp"
#include "utils/tools.hpp"

Direction Position::getRandomDirection() {
	static std::vector<Direction> dirList {
		DIRECTION_NORTH,
		DIRECTION_WEST,
		DIRECTION_EAST,
		DIRECTION_SOUTH
	};
	std::shuffle(dirList.begin(), dirList.end(), getRandomGenerator());

	return dirList.front();
}

std::ostream &operator<<(std::ostream &os, const Position &pos) {
	return os << pos.toString();
}

std::ostream &operator<<(std::ostream &os, const Direction &dir) {
	static const std::map<Direction, std::string> directionStrings = {
		{ DIRECTION_NORTH, "North" },
		{ DIRECTION_EAST, "East" },
		{ DIRECTION_WEST, "West" },
		{ DIRECTION_SOUTH, "South" },
		{ DIRECTION_SOUTHWEST, "South-West" },
		{ DIRECTION_SOUTHEAST, "South-East" },
		{ DIRECTION_NORTHWEST, "North-West" },
		{ DIRECTION_NORTHEAST, "North-East" }
	};

	auto it = directionStrings.find(dir);
	if (it != directionStrings.end()) {
		return os << it->second;
	}

	return os;
}

std::unordered_set<Position> Position::getSurroundingPositions(uint32_t radius /*= 1*/) const {
	std::unordered_set<Position> positions;
	int centerX = getX();
	int centerY = getY();

	for (int x = centerX - radius; x <= centerX + radius; ++x) {
		for (int y = centerY - radius; y <= centerY + radius; ++y) {
			int distanceSquared = (x - centerX) * (x - centerX) + (y - centerY) * (y - centerY);
			if (distanceSquared <= radius * radius) {
				positions.insert(Position(x, y, getZ()));
			}
		}
	}

	return positions;
}
