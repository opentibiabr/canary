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
	#include <string>
#endif

// Read/write access to the `channel_switch_audit` table (docs/multichannel/
// ARCHITECTURE.md §6), which is both the audit trail the spec requires and -
// as of this PR - the actual handoff mechanism a live channel switch uses:
// the origin channel writes a SUCCESS row with the resolved arrival
// position, and the target channel's login consumes it instead of using
// the stale global `players.loginPosition`. See §6 for why this DB-row
// handoff was chosen over any form of cross-process signaling.
struct ChannelSwitchAuditRecord {
	int32_t playerId = 0;
	int32_t accountId = 0;
	std::optional<int32_t> sourceChannelId; // unset on first-ever login
	int32_t targetChannelId = 0;
	Position sourcePosition;
	Position resolvedPosition;
	// One of PositionResolutionReason's names (SamePosition/
	// NearestPublicTile/LastSafePosition/Temple), or empty when result is
	// not SUCCESS.
	std::string fallbackReason;
	std::string sessionId;
	uint64_t fencingToken = 0;
	// "SUCCESS", "DENIED", or "ERROR" - matches the DB enum's literal values
	// exactly (see schema.sql), kept as a plain string here rather than a
	// dependency on ChannelSwitchDenyReason so this header stays free of
	// engine call site details.
	std::string result;
	std::string denyReason;
};

struct PendingChannelSwitch {
	int64_t auditId = 0;
	Position resolvedPosition;
};

class ChannelSwitchAuditStore {
public:
	// Inserts one row unconditionally (both allowed and denied switches are
	// audited, per spec §6 step 9). Returns false only on a real DB error;
	// the caller should log but does not need to fail the switch attempt
	// itself over an audit-write failure (the switch's actual outcome was
	// already decided).
	static bool write(const ChannelSwitchAuditRecord &record, int64_t nowMs);

	// The most recent still-unconsumed SUCCESS row for this account
	// targeting this channel, if any. A caller finding one should use its
	// resolvedPosition instead of the normal loginPosition, then call
	// markConsumed with the returned auditId - never reuse a row for more
	// than one login.
	static std::optional<PendingChannelSwitch> findPending(int32_t accountId, int32_t targetChannelId);

	static bool markConsumed(int64_t auditId, int64_t nowMs);

	// The `created_at` of the most recent SUCCESS row for this account
	// (any target channel) - the source of truth for
	// ChannelSwitchRequest::lastChannelSwitchAt (spec §6 step 2), since no
	// dedicated "last switch" column exists on `players` and adding one
	// would touch that table's large load/save path unnecessarily. Returns
	// 0 (never switched before) if there is no such row.
	static int64_t getLastSwitchAtMs(int32_t accountId);
};
