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
	#include <optional>
	#include <string>
#endif

// Pure, dependency-free Position <-> "x,y,z" string conversion matching the
// `channel_switch_audit.source_position`/`resolved_position` varchar(64)
// columns (docs/multichannel/ARCHITECTURE.md §6). Kept in its own header,
// separate from ChannelSwitchAuditStore, so it can be unit-tested without
// pulling in that class's database.hpp dependency - the same reasoning as
// channel_info.hpp being split out of channel_registry.hpp in Phase 1.
namespace multichannel {
	[[nodiscard]] std::string formatPosition(const Position &position);
	[[nodiscard]] std::optional<Position> parsePosition(const std::string &value);
} // namespace multichannel
