/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

enum Direction : uint8_t {
	DIRECTION_NORTH = 0,
	DIRECTION_EAST = 1,
	DIRECTION_SOUTH = 2,
	DIRECTION_WEST = 3,

	DIRECTION_DIAGONAL_MASK = 4,
	DIRECTION_SOUTHWEST = DIRECTION_DIAGONAL_MASK | 0,
	DIRECTION_SOUTHEAST = DIRECTION_DIAGONAL_MASK | 1,
	DIRECTION_NORTHWEST = DIRECTION_DIAGONAL_MASK | 2,
	DIRECTION_NORTHEAST = DIRECTION_DIAGONAL_MASK | 3,

	DIRECTION_LAST = DIRECTION_NORTHEAST,
	DIRECTION_NONE = 8,
};

struct Position {
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
};

namespace std {
	template <>
	struct hash<Position> {
		std::size_t operator()(const Position &p) const noexcept {
			return static_cast<std::size_t>(p.x) | (static_cast<std::size_t>(p.y) << 16) | (static_cast<std::size_t>(p.z) << 32);
		}
	};
}

std::ostream &operator<<(std::ostream &, const Position &);
std::ostream &operator<<(std::ostream &, const Direction &);
