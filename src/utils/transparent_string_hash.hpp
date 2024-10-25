/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class TransparentStringHasher {
public:
	using is_transparent = void;
	size_t operator()(const std::string &key) const noexcept {
		return std::hash<std::string> {}(key);
	}
	size_t operator()(std::string_view key) const noexcept {
		return std::hash<std::string_view> {}(key);
	}
	size_t operator()(const char* key) const noexcept {
		return std::hash<std::string_view> {}(key);
	}
};
