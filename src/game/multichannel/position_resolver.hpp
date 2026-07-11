/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <optional>
#endif

// Pure abstraction over "is this position legal to land on when switching
// channels" (spec §2.4). Deliberately has zero dependency on the live
// Map/Tile/House engine so PositionResolver is fully unit-testable; the real
// engine-backed implementation is Phase 2 work (see
// docs/multichannel/ARCHITECTURE.md §6).
class IPositionLegality {
public:
	virtual ~IPositionLegality() = default;

	// A standable, non-blocked tile physically exists here on the target
	// channel's map.
	[[nodiscard]] virtual bool tileExists(const Position &position) const = 0;

	// Inside a house the arriving account/player does not have access to on
	// the target channel.
	[[nodiscard]] virtual bool isInaccessibleHouse(const Position &position) const = 0;

	// Inside an instance, boss room or quest room flagged as not permitting a
	// channel-switch arrival.
	[[nodiscard]] virtual bool isRestrictedInstance(const Position &position) const = 0;

	// Inside an explicit NO_CHANNEL_SWITCH zone.
	[[nodiscard]] virtual bool isNoChannelSwitchZone(const Position &position) const = 0;

	// Requires a teleport, fee, or other special entry condition that a bare
	// channel-switch arrival cannot satisfy (e.g. a quest gate).
	[[nodiscard]] virtual bool requiresSpecialEntryCondition(const Position &position) const = 0;
};

enum class PositionResolutionReason : uint8_t {
	SamePosition,
	NearestPublicTile,
	LastSafePosition,
	Temple,
};

struct PositionResolutionResult {
	Position position;
	PositionResolutionReason reason = PositionResolutionReason::Temple;
};

struct PositionResolutionInput {
	// Same (x, y, z) the character occupied on the source channel.
	Position requestedPosition;
	// Player's last persisted safe public position, if one has ever been
	// recorded (spec §2.4 step 3).
	std::optional<Position> lastSafePosition;
	// The target channel's configured temple (spec §2.4 step 4) - always a
	// legal fallback by construction, never itself checked for legality.
	Position templePosition;
	// Bounded Chebyshev search radius (channelSwitchSearchRadius config).
	int32_t searchRadius = 10;
};

// Implements the exact fallback chain from spec §2.4:
//   1. same position, if legal
//   2. nearest legal public tile within a bounded radius
//   3. last persisted safe public position
//   4. the target channel's temple
// Step 2 is a bounded breadth-first-by-ring search — never an unbounded map
// scan — capped by both the configured radius and a hard internal ceiling.
class PositionResolver {
public:
	// Hard ceiling on the search radius regardless of configuration, so a
	// misconfigured channelSwitchSearchRadius can never turn step 2 into an
	// effectively unbounded scan.
	static constexpr int32_t MaxSearchRadius = 50;

	static PositionResolutionResult resolve(const PositionResolutionInput &input, const IPositionLegality &legality);

	[[nodiscard]] static bool isLegal(const Position &position, const IPositionLegality &legality);

	// Exposed for unit testing the search step in isolation.
	static std::optional<Position> findNearestLegalTile(const Position &origin, int32_t radius, const IPositionLegality &legality);
};
