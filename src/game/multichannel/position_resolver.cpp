/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/position_resolver.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <limits>
#endif

namespace {
	bool inBounds(int32_t x, int32_t y) {
		return x >= 0 && x <= std::numeric_limits<uint16_t>::max() && y >= 0 && y <= std::numeric_limits<uint16_t>::max();
	}
} // namespace

bool PositionResolver::isLegal(const Position &position, const IPositionLegality &legality) {
	if (!legality.tileExists(position)) {
		return false;
	}
	if (legality.isInaccessibleHouse(position)) {
		return false;
	}
	if (legality.isRestrictedInstance(position)) {
		return false;
	}
	if (legality.isNoChannelSwitchZone(position)) {
		return false;
	}
	if (legality.requiresSpecialEntryCondition(position)) {
		return false;
	}
	return true;
}

std::optional<Position> PositionResolver::findNearestLegalTile(const Position &origin, int32_t radius, const IPositionLegality &legality) {
	const int32_t clampedRadius = std::clamp(radius, 0, MaxSearchRadius);
	const int32_t originX = origin.getX();
	const int32_t originY = origin.getY();

	// Bounded ring-by-ring scan (Chebyshev distance), never an unbounded map
	// scan: total candidates visited is at most (2*radius+1)^2, and radius is
	// itself hard-capped at MaxSearchRadius regardless of configuration.
	for (int32_t r = 1; r <= clampedRadius; ++r) {
		for (const int32_t dy : std::array<int32_t, 2> { -r, r }) {
			const int32_t y = originY + dy;
			for (int32_t dx = -r; dx <= r; ++dx) {
				const int32_t x = originX + dx;
				if (!inBounds(x, y)) {
					continue;
				}
				const Position candidate(static_cast<uint16_t>(x), static_cast<uint16_t>(y), origin.getZ());
				if (isLegal(candidate, legality)) {
					return candidate;
				}
			}
		}

		for (const int32_t dx : std::array<int32_t, 2> { -r, r }) {
			const int32_t x = originX + dx;
			for (int32_t dy = -r + 1; dy <= r - 1; ++dy) {
				const int32_t y = originY + dy;
				if (!inBounds(x, y)) {
					continue;
				}
				const Position candidate(static_cast<uint16_t>(x), static_cast<uint16_t>(y), origin.getZ());
				if (isLegal(candidate, legality)) {
					return candidate;
				}
			}
		}
	}

	return std::nullopt;
}

PositionResolutionResult PositionResolver::resolve(const PositionResolutionInput &input, const IPositionLegality &legality) {
	if (isLegal(input.requestedPosition, legality)) {
		return { input.requestedPosition, PositionResolutionReason::SamePosition };
	}

	if (const auto nearest = findNearestLegalTile(input.requestedPosition, input.searchRadius, legality)) {
		return { *nearest, PositionResolutionReason::NearestPublicTile };
	}

	if (input.lastSafePosition && isLegal(*input.lastSafePosition, legality)) {
		return { *input.lastSafePosition, PositionResolutionReason::LastSafePosition };
	}

	return { input.templePosition, PositionResolutionReason::Temple };
}
