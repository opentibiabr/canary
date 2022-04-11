/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#ifndef SRC_UTILS_LEXICAL_CAST_HPP_
#define SRC_UTILS_LEXICAL_CAST_HPP_

#include <stdlib.h>
#include <string>

class Cast {
	public:

	template<class T>
	T static lexicalCast(const char * str) {
		// Reusing has severe (positive) impact on performance
		static std::istringstream stringstream;
		T value;
		stringstream.str(str);
		stringstream>> value;
		stringstream.clear();
		return value;
	}

	// Trivial conversion
	template<> static std::string lexicalCast(const char * str) {
		return str;
	}

	// Conversions that exist in stl
	template<> static float lexicalCast(const char * str) {
		return std::strtof(str, nullptr);
	}
	template<> static long lexicalCast(const char * str) {
		return std::strtol(str, nullptr, 0);
	}
	template<> static long long lexicalCast(const char * str) {
		return std::strtoll(str, nullptr, 0);
	}
	template<> static unsigned long lexicalCast(const char * str) {
		return std::strtoul(str, nullptr, 0);
	}
	template<> static unsigned long long lexicalCast(const char * str) {
		return std::strtoull(str, nullptr, 0);
	}

	// Conversions that need to be truncated
	template<> static short lexicalCast(const char * str) {
		return static_cast <short>(lexicalCast<long>(str));
	}
	template<> static int lexicalCast(const char * str) {
		return static_cast <int>(lexicalCast<long>(str));
	}
	template<> static unsigned short lexicalCast(const char * str) {
		return static_cast <unsigned short>(lexicalCast<unsigned long>(str));
	}
	template<> static unsigned int lexicalCast(const char * str) {
		return static_cast <unsigned int>(lexicalCast<unsigned long>(str));
	}

};

#endif // SRC_UTILS_LEXICAL_CAST_HPP_
