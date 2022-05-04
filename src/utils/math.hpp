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

#include "otpch.h"

#ifndef SRC_UTILS_MATH_HPP_
#define SRC_UTILS_MATH_HPP_

namespace stdext
{
	inline bool is_power_of_two(size_t v) { return ((v != 0) && !(v & (v - 1))); }
	inline size_t to_power_of_two(size_t v) { if (v == 0) return 0; size_t r = 1; while (r < v && r != 0xffffffff) r <<= 1; return r; }

	inline uint16_t readULE16(const unsigned char* addr) { return static_cast<uint16_t>(addr[1]) << 8 | addr[0]; }
	inline uint32_t readULE32(const unsigned char* addr) { return static_cast<uint32_t>(readULE16(addr + 2)) << 16 | readULE16(addr); }
	inline uint64_t readULE64(const unsigned char* addr) { return static_cast<uint64_t>(readULE32(addr + 4)) << 32 | readULE32(addr); }

	inline void writeULE16(unsigned char* addr, uint16_t value) { addr[1] = value >> 8; addr[0] = static_cast<uint8_t>(value); }
	inline void writeULE32(unsigned char* addr, uint32_t value) { writeULE16(addr + 2, value >> 16); writeULE16(addr, static_cast<uint16_t>(value)); }
	inline void writeULE64(unsigned char* addr, uint64_t value) { writeULE32(addr + 4, value >> 32); writeULE32(addr, static_cast<uint32_t>(value)); }

	inline int16_t readSLE16(const unsigned char* addr) { return static_cast<int16_t>(addr[1]) << 8 | addr[0]; }
	inline int32_t readSLE32(const unsigned char* addr) { return static_cast<int32_t>(readSLE16(addr + 2)) << 16 | readSLE16(addr); }
	inline int64_t readSLE64(const unsigned char* addr) { return static_cast<int64_t>(readSLE32(addr + 4)) << 32 | readSLE32(addr); }

	inline void writeSLE16(unsigned char* addr, int16_t value) { addr[1] = value >> 8; addr[0] = static_cast<int8_t>(value); }
	inline void writeSLE32(unsigned char* addr, int32_t value) { writeSLE16(addr + 2, value >> 16); writeSLE16(addr, static_cast<int16_t>(value)); }
	inline void writeSLE64(unsigned char* addr, int64_t value) { writeSLE32(addr + 4, value >> 32); writeSLE32(addr, static_cast<int32_t>(value)); }

	uint32_t adler32(const uint8_t* buffer, size_t size);

	long random_range(long min, long max);
	float random_range(float min, float max);
}

#endif  // SRC_UTILS_MATH_HPP_
