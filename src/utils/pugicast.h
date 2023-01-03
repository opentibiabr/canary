/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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
