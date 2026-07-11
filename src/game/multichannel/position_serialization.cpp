/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/position_serialization.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <charconv>
	#include <sstream>
	#include <vector>
#endif

std::string multichannel::formatPosition(const Position &position) {
	std::ostringstream stream;
	stream << position.x << ',' << position.y << ',' << static_cast<int>(position.z);
	return stream.str();
}

std::optional<Position> multichannel::parsePosition(const std::string &value) {
	std::vector<std::string> parts;
	std::size_t start = 0;
	while (start <= value.size()) {
		const auto comma = value.find(',', start);
		if (comma == std::string::npos) {
			parts.push_back(value.substr(start));
			break;
		}
		parts.push_back(value.substr(start, comma - start));
		start = comma + 1;
	}
	if (parts.size() != 3) {
		return std::nullopt;
	}

	auto parseComponent = [](const std::string &part, auto &out) -> bool {
		const auto result = std::from_chars(part.data(), part.data() + part.size(), out);
		return result.ec == std::errc() && result.ptr == part.data() + part.size();
	};

	int32_t x = 0;
	int32_t y = 0;
	int32_t z = 0;
	if (!parseComponent(parts[0], x) || !parseComponent(parts[1], y) || !parseComponent(parts[2], z)) {
		return std::nullopt;
	}
	if (x < 0 || x > 0xFFFF || y < 0 || y > 0xFFFF || z < 0 || z > 0xFF) {
		return std::nullopt;
	}

	return Position(static_cast<uint16_t>(x), static_cast<uint16_t>(y), static_cast<uint8_t>(z));
}
