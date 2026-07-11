/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/multichannel/position_resolver.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <memory>
#endif

class Player;

// Real, engine-backed IPositionLegality (docs/multichannel/ARCHITECTURE.md
// §6), replacing the pure-logic-only abstraction Phase 1 shipped. Answers
// every check against this process's own already-loaded live Map/Tile/House
// state - correct by construction for a target channel that shares this
// channel's map (see ChannelInfo::mapHash), which is the only case a caller
// should ever ask this class to resolve for (see DECISION_MATRIX.md: a
// caller must check mapHash equality itself and fall back to temple-only
// when it differs, since this class has no way to answer for a map it
// hasn't loaded).
//
// Two of the five checks (tileExists, isInaccessibleHouse) map directly onto
// existing engine primitives. The other three
// (isRestrictedInstance/isNoChannelSwitchZone/requiresSpecialEntryCondition)
// have no dedicated schema or authoring convention anywhere in this project
// yet, so they are answered via an explicit, documented opt-in: a `Zone`
// (game/zones/zone.hpp) covering the position whose name starts with the
// matching reserved prefix. This is honestly a convention, not a first-class
// feature - see docs/multichannel/DECISION_MATRIX.md.
class EnginePositionLegality final : public IPositionLegality {
public:
	// arrivingPlayer must be non-null and is only read from, never mutated;
	// it is the player whose house access is being checked (isInvited() is
	// player-specific, not account-specific - matches how house access
	// already works everywhere else in this codebase).
	explicit EnginePositionLegality(std::shared_ptr<Player> arrivingPlayer);

	[[nodiscard]] bool tileExists(const Position &position) const override;
	[[nodiscard]] bool isInaccessibleHouse(const Position &position) const override;
	[[nodiscard]] bool isRestrictedInstance(const Position &position) const override;
	[[nodiscard]] bool isNoChannelSwitchZone(const Position &position) const override;
	[[nodiscard]] bool requiresSpecialEntryCondition(const Position &position) const override;

	// Reserved zone-name prefixes for the opt-in convention above. Exposed
	// so tests and operator documentation share the exact same strings.
	static constexpr const char* RestrictedInstanceZonePrefix = "restrictedinstance";
	static constexpr const char* NoChannelSwitchZonePrefix = "nochannelswitch";
	static constexpr const char* SpecialEntryZonePrefix = "specialentry";

private:
	std::shared_ptr<Player> player;
};
