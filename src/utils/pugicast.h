/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#ifndef SRC_UTILS_PUGICAST_H_
#define SRC_UTILS_PUGICAST_H_

namespace pugi {
	/**
	 * @brief Converts a string to a generic type T.
	 *
	 * @tparam T Type to which the string will be converted.
	 * @param str String to be converted.
	 * @return Value converted to type T.
	 */
	template<typename T>
	T cast(const pugi::char_t* str)
	{
		T value; // Value to be returned
		try {
			// Uses std::stoll to convert the string to the generic type T
			value = static_cast<T>(std::stoll(str));
		} catch (std::invalid_argument&) {
			// Value of the string is invalid
			value = T();
		} catch (std::out_of_range&) {
			// Value of the string is too large to fit in the range allowed by type T
			value = T();
		}

		return value;
	}
}

#endif  // SRC_UTILS_PUGICAST_H_
