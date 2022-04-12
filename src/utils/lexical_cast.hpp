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

#include "spdlog/spdlog.h"
#include <cstdlib>

class LexicalCast : public std::string {
public:
	/**
	 * @brief Convert from char* to int/uint
	 * @param charString Value to convert
	 * @return int
	 */
	static int intFromChar(const char* charString) { 
		try {
			return std::atoi(charString);
		} catch (std::exception& exception) {
			SPDLOG_ERROR("[LexicalCast::intFromChar] - Cannot convert {}", exception.what());
		}
	}
	/**
	 * @brief Convert from char* to float
	 * 
	 * @param charString Value to convert
	 * @return float
	 */
	static float floatFromChar(const char* charString) { 
		try {
			return std::stof(charString);
		} catch (std::exception& exception) {
			SPDLOG_ERROR("[LexicalCast::floatFromChar] - Cannot convert {}", exception.what());
		}
	}
};

#endif // SRC_UTILS_LEXICAL_CAST_HPP_
