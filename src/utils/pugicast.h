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

#include <boost/lexical_cast.hpp>

namespace pugi {
	template<typename T>
	T cast(const pugi::char_t* str)
	{
		T value;
		try {
			value = boost::lexical_cast<T>(str);
		} catch (boost::bad_lexical_cast&) {
			value = T();
		}
		return value;
	}
}

#endif  // SRC_UTILS_PUGICAST_H_
