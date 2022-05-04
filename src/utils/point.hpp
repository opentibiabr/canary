/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 * <https://github.com/opentibiabr/canary>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef POINT_H
#define POINT_H

#include <array>
#include <cmath>
#include <ostream>

template<class T>
class TSize;

template<class T>
class TPoint
{
public:
	TPoint() : x(0), y(0) {}
	TPoint(T xy) : x(xy), y(xy) {}
	TPoint(T x, T y) : x(x), y(y) {}
	TPoint(const TPoint<T>& other) : x(other.x), y(other.y) {}

	bool isNull() const { return x == 0 && y == 0; }
	TSize<T> toSize() const { return TSize<T>(x, y); }
	TPoint<T> translated(T dx, T dy) const { TPoint<T> point = *this; point.x += dx; point.y += dy; return point; }

	TPoint<T> operator-() const { return TPoint<T>(-x, -y); }

	TPoint<T> operator+(const TPoint<T>& other) const { return TPoint<T>(x + other.x, y + other.y); }
	TPoint<T>& operator+=(const TPoint<T>& other) { x += other.x; y += other.y; return *this; }
	TPoint<T> operator-(const TPoint<T>& other) const { return TPoint<T>(x - other.x, y - other.y); }
	TPoint<T>& operator-=(const TPoint<T>& other) { x -= other.x; y -= other.y; return *this; }
	TPoint<T> operator*(const TPoint<T>& other) const { return TPoint<T>(x * other.x, y * other.y); }
	TPoint<T>& operator*=(const TPoint<T>& other) { x *= other.x; y *= other.y; return *this; }
	TPoint<T> operator/(const TPoint<T>& other) const { return TPoint<T>(x / other.x, y / other.y); }
	TPoint<T>& operator/=(const TPoint<T>& other) { x /= other.x; y /= other.y; return *this; }

	TPoint<T> operator+(T other) const { return TPoint<T>(x + other, y + other); }
	TPoint<T>& operator+=(T other) { x += other; y += other; return *this; }
	TPoint<T> operator-(T other) const { return TPoint<T>(x - other, y - other); }
	TPoint<T>& operator-=(T other) { x -= other; y -= other; return *this; }
	TPoint<T> operator*(float v) const { return TPoint<T>(x * v, y * v); }
	TPoint<T>& operator*=(float v) { x *= v; y *= v; return *this; }
	TPoint<T> operator/(float v) const { return TPoint<T>(x / v, y / v); }
	TPoint<T>& operator/=(float v) { x /= v; y /= v; return *this; }

	TPoint<T> operator&(int a) { return TPoint<T>(x & a, y & a); }
	TPoint<T>& operator&=(int a) { x &= a; y &= a; return *this; }

	bool operator<=(const TPoint<T>& other) const { return x <= other.x && y <= other.y; }
	bool operator>=(const TPoint<T>& other) const { return x >= other.x && y >= other.y; }
	bool operator<(const TPoint<T>& other) const { return x < other.x&& y < other.y; }
	bool operator>(const TPoint<T>& other) const { return x > other.x && y > other.y; }

	TPoint<T>& operator=(const TPoint<T>& other) { x = other.x; y = other.y; return *this; }
	bool operator==(const TPoint<T>& other) const { return other.x == x && other.y == y; }
	bool operator!=(const TPoint<T>& other) const { return other.x != x || other.y != y; }

	float length() const { return sqrt(static_cast<float>(x * x + y * y)); }
	T manhattanLength() const { return std::abs(x) + std::abs(y); }

	float distanceFrom(const TPoint<T>& other) const
	{
		return TPoint<T>(x - other.x, y - other.y).length();
	}

	std::size_t hash() const { return (7 * 15 + x) * 15 + y; }

	std::array<TPoint<T>, static_cast<uint8_t>(8)> getPointsAround(const uint8_t pixel) const
	{
		std::array<TPoint<T>, static_cast<uint8_t>(8)> positions;
		int_fast8_t i = -1;
		for (int_fast32_t xi = -1; xi <= 1; ++xi) {
			for (int_fast32_t yi = -1; yi <= 1; ++yi) {
				const TPoint<T>& pos = translated(xi * pixel, yi * pixel, xi, yi);
				if (pos == *this)
					continue;

				positions[++i] = pos;
			}
		}

		return positions;
	}

	T x, y;;
};

using Point = TPoint<int>;
using PointF = TPoint<float>;

template<class T>
std::ostream& operator<<(std::ostream& out, const TPoint<T>& point)
{
	out << point.x << " " << point.y;
	return out;
}

template<class T>
std::istream& operator>>(std::istream& in, TPoint<T>& point)
{
	in >> point.x;
	in >> point.y;
	return in;
}

#endif
