/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstddef>
	#include <cstdint>
	#include <functional>
	#include <unordered_map>
	#include <utility>
#endif

/**
 * @brief Custom hash function for std::pair<uint16_t, uint8_t> to be used in unordered_map.
 */
struct TierCountPairHash {
	size_t operator()(const std::pair<uint16_t, uint8_t> &p) const {
		return std::hash<uint16_t> {}(p.first) ^ (std::hash<uint8_t> {}(p.second) << 1);
	}
};

/**
 * @brief Represents a mapping of items with their tiers and associated counts.
 *
 * The key is a pair where:
 * - first: uint16_t representing the item ID.
 * - second: uint8_t representing the item tier.
 *
 * The value is a uint32_t representing the total count of that item-tier combination.
 *
 * Example:
 * {
 *   {100, 0} => 3,  // 3 items with ID 100 and tier 0
 *   {100, 2} => 1,  // 1 item with ID 100 and tier 2
 *   {200, 1} => 5   // 5 items with ID 200 and tier 1
 * }
 */
using ItemsTierKey = std::pair<uint16_t, uint8_t>;
using ItemsTierCountList = std::unordered_map<ItemsTierKey, uint32_t, TierCountPairHash>;
