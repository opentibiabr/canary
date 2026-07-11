/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/channel_switch_service.hpp"

std::optional<ChannelSwitchPartyPolicy> parseChannelSwitchPartyPolicy(const std::string &value) {
	if (value == "deny") {
		return ChannelSwitchPartyPolicy::Deny;
	}
	if (value == "leave") {
		return ChannelSwitchPartyPolicy::Leave;
	}
	return std::nullopt;
}

std::optional<PvpChannelExitPolicy> parsePvpChannelExitPolicy(const std::string &value) {
	if (value == "combat-only") {
		return PvpChannelExitPolicy::CombatOnly;
	}
	if (value == "combat-or-skull") {
		return PvpChannelExitPolicy::CombatOrSkull;
	}
	return std::nullopt;
}

namespace {
	ChannelSwitchDecision deny(ChannelSwitchDenyReason reason) {
		ChannelSwitchDecision decision;
		decision.allowed = false;
		decision.denyReason = reason;
		return decision;
	}
} // namespace

ChannelSwitchDecision ChannelSwitchService::evaluate(const ChannelSwitchRequest &request) {
	// 1. Plain relog on the same channel is not a switch at all - no
	// cooldown, no audit row beyond the normal login (spec §6).
	if (request.sourceChannelId.has_value() && *request.sourceChannelId == request.targetChannelId) {
		return deny(ChannelSwitchDenyReason::SameChannel);
	}

	// 2. Cooldown.
	if (request.lastChannelSwitchAt > 0 && (request.nowMs - request.lastChannelSwitchAt) < request.cooldownMs) {
		return deny(ChannelSwitchDenyReason::Cooldown);
	}

	// 3. No login/switch while a cluster session shows this account already
	// online somewhere else - this is the same lock ClusterSessionManager
	// enforces, checked here again so the policy decision is self-contained
	// and cannot be reached by skipping the session check.
	if (request.hasActiveClusterSessionElsewhere) {
		return deny(ChannelSwitchDenyReason::AlreadyOnlineElsewhere);
	}

	// 4. PZ lock / active combat always blocks a switch, unconditionally -
	// this can never be disabled by configuration (spec §4.3, §7).
	if (request.hasActivePzLockOrCombat) {
		return deny(ChannelSwitchDenyReason::CombatOrPzLock);
	}

	// 5. Entering a No-PvP channel: apply the configured exit policy. Combat
	// was already ruled out in step 4, so CombatOnly has nothing further to
	// check here; CombatOrSkull additionally blocks a skulled character from
	// hopping to a calmer channel (spec §2.10).
	if (request.targetIsNoPvp && request.pvpExitPolicy == PvpChannelExitPolicy::CombatOrSkull && request.isSkulled) {
		return deny(ChannelSwitchDenyReason::SkullBlocksNoPvpEntry);
	}

	// 6. Party policy (spec §2.7). Deny blocks the switch outright; Leave
	// allows it but tells the caller to remove the player from the party
	// first.
	bool mustLeavePartyFirst = false;
	if (request.isInParty) {
		if (request.partyPolicy == ChannelSwitchPartyPolicy::Deny) {
			return deny(ChannelSwitchDenyReason::ActiveParty);
		}
		mustLeavePartyFirst = true;
	}

	// 7. Target channel must be enabled, online (fresh heartbeat) and not full.
	if (!request.targetChannelEnabled) {
		return deny(ChannelSwitchDenyReason::TargetDisabled);
	}
	if (!request.targetChannelOnline) {
		return deny(ChannelSwitchDenyReason::TargetOffline);
	}
	if (request.targetChannelFull) {
		return deny(ChannelSwitchDenyReason::TargetFull);
	}

	ChannelSwitchDecision decision;
	decision.allowed = true;
	decision.denyReason = ChannelSwitchDenyReason::None;
	decision.mustLeavePartyFirst = mustLeavePartyFirst;
	return decision;
}
