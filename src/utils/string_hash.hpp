/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_UTILS_STRING_HASH_HPP_
#define SRC_UTILS_STRING_HASH_HPP_

// Custom hasher object for enabling heterogeneous lookup with std::string_view
struct StringHash {
	// Enables heterogeneous lookup
	using is_transparent = void;
	std::size_t operator()(std::string_view sv) const {
		// Hash the std::string_view using std::hash<std::string_view>
		std::hash<std::string_view> hasher;
		return hasher(sv);
	}
};

#endif
