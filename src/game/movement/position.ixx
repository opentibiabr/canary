module;

#pragma once
#include <cmath>
#include <cstdint>
#include <iostream>
#include <map>
#include <random>
#include <string>
#include <vector>
#include <algorithm>
#include <functional>
#include <numeric>
#include <iterator>
#include <array>

export module game_movement;

export enum class Direction : uint8_t {
	NORTH = 0,
	EAST = 1,
	SOUTH = 2,
	WEST = 3,

	DIAGONAL_MASK = 4,
	SOUTHWEST = DIAGONAL_MASK | 0,
	SOUTHEAST = DIAGONAL_MASK | 1,
	NORTHWEST = DIAGONAL_MASK | 2,
	NORTHEAST = DIAGONAL_MASK | 3,

	LAST = NORTHEAST,
	NONE = 8,
};

export constexpr auto DIRECTION_LAST = static_cast<uint8_t>(Direction::LAST);

export uint8_t directionToValue(Direction type) {
	return static_cast<uint8_t>(type);
}

export Direction directionFromValue(uint8_t value) {
	return static_cast<Direction>(value);
}

export struct Position {
	constexpr Position() = default;
	constexpr Position(uint16_t initX, uint16_t initY, uint8_t initZ) :
		x(initX), y(initY), z(initZ) { }

	template <int_fast32_t deltax, int_fast32_t deltay>
	static bool areInRange(const Position &p1, const Position &p2) {
		return Position::getDistanceX(p1, p2) <= deltax && Position::getDistanceY(p1, p2) <= deltay;
	}

	template <int_fast32_t deltax, int_fast32_t deltay, int_fast16_t deltaz>
	static bool areInRange(const Position &p1, const Position &p2) {
		return Position::getDistanceX(p1, p2) <= deltax && Position::getDistanceY(p1, p2) <= deltay && Position::getDistanceZ(p1, p2) <= deltaz;
	}

	static int_fast32_t getOffsetX(const Position &p1, const Position &p2) {
		return p1.getX() - p2.getX();
	}
	static int_fast32_t getOffsetY(const Position &p1, const Position &p2) {
		return p1.getY() - p2.getY();
	}
	static int_fast16_t getOffsetZ(const Position &p1, const Position &p2) {
		return p1.getZ() - p2.getZ();
	}

	static int32_t getDistanceX(const Position &p1, const Position &p2) {
		return std::abs(Position::getOffsetX(p1, p2));
	}
	static int32_t getDistanceY(const Position &p1, const Position &p2) {
		return std::abs(Position::getOffsetY(p1, p2));
	}
	static int16_t getDistanceZ(const Position &p1, const Position &p2) {
		return std::abs(Position::getOffsetZ(p1, p2));
	}
	static int32_t getDiagonalDistance(const Position &p1, const Position &p2) {
		return std::max(Position::getDistanceX(p1, p2), Position::getDistanceY(p1, p2));
	}
	static double getEuclideanDistance(const Position &p1, const Position &p2);

	static Direction getRandomDirection();

	uint16_t x = 0;
	uint16_t y = 0;
	uint8_t z = 0;

	bool operator<(const Position &p) const {
		return (z < p.z) || (z == p.z && y < p.y) || (z == p.z && y == p.y && x < p.x);
	}

	bool operator>(const Position &p) const {
		return !(*this < p);
	}

	bool operator==(const Position &p) const {
		return p.x == x && p.y == y && p.z == z;
	}

	bool operator!=(const Position &p) const {
		return p.x != x || p.y != y || p.z != z;
	}

	Position operator+(const Position &p1) const {
		return Position(x + p1.x, y + p1.y, z + p1.z);
	}

	Position operator-(const Position &p1) const {
		return Position(x - p1.x, y - p1.y, z - p1.z);
	}

	std::string toString() const {
		std::string str;
		return str.append("( ")
			.append(std::to_string(getX()))
			.append(", ")
			.append(std::to_string(getY()))
			.append(", ")
			.append(std::to_string(getZ()))
			.append(" )");
	}

	int_fast32_t getX() const {
		return x;
	}
	int_fast32_t getY() const {
		return y;
	}
	int_fast16_t getZ() const {
		return z;
	}

    static inline std::vector<Direction> getDirectionVector() {
        static std::vector<Direction> directionVector {
            Direction::NORTH,
            Direction::NORTHEAST,
            Direction::EAST,
            Direction::SOUTHEAST,
            Direction::SOUTH,
            Direction::SOUTHWEST,
            Direction::WEST,
            Direction::NORTHWEST
        };

        return directionVector;
    }

};

export namespace std {
	template <>
	struct hash<Position> {
		std::size_t operator()(const Position &p) const {
			return static_cast<std::size_t>(p.x) | (static_cast<std::size_t>(p.y) << 16) | (static_cast<std::size_t>(p.z) << 32);
		}
	};
}

export std::ostream &operator<<(std::ostream &, const Position &);
export std::ostream &operator<<(std::ostream &, const Direction &);

namespace {
std::mt19937 &getRandomGenerator() {
	static std::random_device rd;
	static std::mt19937 generator(rd());
	return generator;
}
} // namespace

double Position::getEuclideanDistance(const Position &p1, const Position &p2) {
	int32_t dx = Position::getDistanceX(p1, p2);
	int32_t dy = Position::getDistanceY(p1, p2);
	return std::sqrt(dx * dx + dy * dy);
}

Direction Position::getRandomDirection() {
	static std::vector<Direction> dirList {
		Direction::NORTH,
		Direction::WEST,
		Direction::EAST,
		Direction::SOUTH
	};
	std::shuffle(dirList.begin(), dirList.end(), getRandomGenerator());

	return dirList.front();
}

export std::ostream &operator<<(std::ostream &os, const Position &pos) {
	return os << pos.toString();
}

export std::ostream &operator<<(std::ostream &os, const Direction &dir) {
	static const std::map<Direction, std::string> directionStrings = {
		{ Direction::NORTH, "North" },
		{ Direction::EAST, "East" },
		{ Direction::WEST, "West" },
		{ Direction::SOUTH, "South" },
		{ Direction::SOUTHWEST, "South-West" },
		{ Direction::SOUTHEAST, "South-East" },
		{ Direction::NORTHWEST, "North-West" },
		{ Direction::NORTHEAST, "North-East" }
	};

	auto it = directionStrings.find(dir);
	if (it != directionStrings.end()) {
		return os << it->second;
	}

	return os;
}
