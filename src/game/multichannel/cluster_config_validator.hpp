/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/multichannel/channel_info.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <optional>
	#include <string>
	#include <vector>
#endif

enum class ClusterConfigValidationError : uint8_t {
	LeaseTtlNotGreaterThanHeartbeat,
	InvalidPartyPolicy,
	InvalidPvpExitPolicy,
	RedisClientNotCompiledIn,
	CurrentChannelMissing,
	CurrentChannelDisabled,
	CurrentChannelInvalidPvpType,
};

[[nodiscard]] std::string describeClusterConfigValidationError(ClusterConfigValidationError error);

struct ClusterConfigValidationInput {
	bool multiChannelEnabled = false;
	int64_t sessionLeaseTtlMs = 0;
	int64_t sessionHeartbeatIntervalMs = 0;
	std::string channelSwitchPartyPolicy;
	std::string pvpChannelExitPolicy;
	// Whether this binary was compiled with the optional vcpkg
	// "multichannel" feature (CANARY_MULTICHANNEL_REDIS). See
	// docs/multichannel/ARCHITECTURE.md §9.
	bool redisClientCompiledIn = false;
	// The `channels` row for this process's resolved channel id, if the
	// registry has one.
	std::optional<ChannelInfo> currentChannel;
};

struct ClusterConfigValidationResult {
	// Fail-closed: valid is false if any hard-failure check did not pass.
	// An empty errors list with valid == true means single-channel mode
	// (validation is a no-op) or every check passed.
	bool valid = true;
	std::vector<ClusterConfigValidationError> errors;
	// Soft, non-fatal recommendations (e.g. "lease TTL should be at least
	// 2x the heartbeat interval") - logged as warnings by the caller, never
	// block startup.
	std::vector<std::string> warnings;
};

// Fail-closed startup validation for multi-channel mode (spec §4.4). Pure
// function over caller-supplied values so it's fully unit-testable without
// touching Redis/DB/the real ConfigManager; the real startup sequence
// (Phase 2 hook) is expected to gather these inputs and abort the process
// if `valid` is false, per docs/multichannel/ARCHITECTURE.md §4.4.
class ClusterConfigValidator {
public:
	[[nodiscard]] static ClusterConfigValidationResult validate(const ClusterConfigValidationInput &input);
};
