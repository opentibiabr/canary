/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <optional>
	#include <string>
#endif

enum class ChannelSwitchPartyPolicy : uint8_t {
	Deny,
	Leave,
};

enum class PvpChannelExitPolicy : uint8_t {
	CombatOnly,
	CombatOrSkull,
};

[[nodiscard]] std::optional<ChannelSwitchPartyPolicy> parseChannelSwitchPartyPolicy(const std::string &value);
[[nodiscard]] std::optional<PvpChannelExitPolicy> parsePvpChannelExitPolicy(const std::string &value);

enum class ChannelSwitchDenyReason : uint8_t {
	None,
	SameChannel, // not actually a switch - plain relog on the same channel
	Cooldown,
	AlreadyOnlineElsewhere,
	CombatOrPzLock,
	SkullBlocksNoPvpEntry,
	ActiveParty,
	TargetDisabled,
	TargetOffline,
	TargetFull,
};

[[nodiscard]] std::string describeChannelSwitchDenyReason(ChannelSwitchDenyReason reason);

struct ChannelSwitchRequest {
	int32_t accountId = 0;
	int32_t playerId = 0;
	std::optional<int32_t> sourceChannelId; // unset on first-ever login
	int32_t targetChannelId = 0;

	int64_t lastChannelSwitchAt = 0; // 0 = never switched before
	int64_t nowMs = 0;
	int64_t cooldownMs = 0;

	// Always checked first and unconditionally, per spec §2.9/§2.10 - no
	// config can disable this (see docs/multichannel/ARCHITECTURE.md §4.3).
	bool hasActivePzLockOrCombat = false;
	bool isSkulled = false;

	bool isInParty = false;
	ChannelSwitchPartyPolicy partyPolicy = ChannelSwitchPartyPolicy::Deny;

	PvpChannelExitPolicy pvpExitPolicy = PvpChannelExitPolicy::CombatOrSkull;
	bool targetIsNoPvp = false;

	// Whether a cluster session lock (see ClusterSessionManager) shows this
	// account already ONLINE somewhere other than sourceChannelId.
	bool hasActiveClusterSessionElsewhere = false;

	bool targetChannelEnabled = true;
	bool targetChannelOnline = true; // heartbeat fresh
	bool targetChannelFull = false;
};

struct ChannelSwitchDecision {
	bool allowed = false;
	ChannelSwitchDenyReason denyReason = ChannelSwitchDenyReason::None;
	// True when partyPolicy == Leave and the player is in a party: the
	// switch is allowed, but the caller must remove the player from their
	// party before proceeding (spec §2.7).
	bool mustLeavePartyFirst = false;
};

// Policy engine for spec §6 ("Channel switch"). Pure logic over booleans the
// caller has already computed from the live engine/session state - this
// class has no engine/DB/Redis dependency of its own, so it's fully
// unit-testable. See docs/multichannel/ARCHITECTURE.md §6 for the exact
// check ordering this implements and the PositionResolver this pairs with
// for the actual arrival-position half of a switch.
class ChannelSwitchService {
public:
	[[nodiscard]] static ChannelSwitchDecision evaluate(const ChannelSwitchRequest &request);
};
