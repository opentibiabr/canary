/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/cluster_runtime.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <tuple>
#endif

ClusterRuntime &ClusterRuntime::getInstance() {
	static ClusterRuntime instance;
	return instance;
}

void ClusterRuntime::configure(std::shared_ptr<IRedisClient> client, int32_t newChannelId, std::string newInstanceId, int64_t newLeaseTtlMs, int64_t newHeartbeatIntervalMs, int64_t newFailureGracePeriodMs) {
	std::lock_guard lock(mutex);
	redisClient = std::move(client);
	sessionManager = std::make_unique<ClusterSessionManager>(*redisClient);
	channelId = newChannelId;
	instanceId = std::move(newInstanceId);
	leaseTtlMs = newLeaseTtlMs;
	heartbeatIntervalMs = newHeartbeatIntervalMs;
	failureGracePeriodMs = newFailureGracePeriodMs;
	tracked.clear();
	enabled = true;
}

void ClusterRuntime::resetForTesting() {
	std::lock_guard lock(mutex);
	redisClient.reset();
	sessionManager.reset();
	tracked.clear();
	enabled = false;
}

bool ClusterRuntime::isEnabled() const {
	std::lock_guard lock(mutex);
	return enabled;
}

bool ClusterRuntime::isAcceptingNewSessions() const {
	std::lock_guard lock(mutex);
	if (!enabled) {
		return true;
	}
	return redisClient->isHealthy();
}

ClusterSessionHandle ClusterRuntime::acquireForLogin(int32_t accountId, int32_t forChannelId, int64_t nowMs) {
	std::lock_guard lock(mutex);
	if (!enabled) {
		ClusterSessionHandle handle;
		handle.acquired = true;
		handle.status = ClusterSessionStatus::Online;
		return handle;
	}

	// Fail closed for *new* sessions the instant Redis looks unhealthy - no
	// grace period here, per docs/multichannel/OPERATIONS.md "Redis outage"
	// step 2. Do not even attempt the call: acquire() would either time out
	// (slow) or, if it somehow "succeeded" against a half-broken connection,
	// hand out a session this process cannot safely renew later.
	if (!redisClient->isHealthy()) {
		ClusterSessionHandle handle;
		handle.acquired = false;
		handle.status = ClusterSessionStatus::Offline;
		return handle;
	}

	auto handle = sessionManager->acquire(accountId, forChannelId, instanceId, leaseTtlMs, nowMs);
	if (handle.acquired) {
		tracked[accountId] = TrackedSession { handle.sessionId, handle.fencingToken, nowMs + leaseTtlMs };
	}
	return handle;
}

void ClusterRuntime::releaseForLogout(int32_t accountId, int64_t /*nowMs*/) {
	std::lock_guard lock(mutex);
	if (!enabled) {
		return;
	}
	const auto it = tracked.find(accountId);
	if (it == tracked.end()) {
		return;
	}
	// Best-effort: a failed release (e.g. Redis unreachable at the exact
	// moment of logout) still removes local tracking, since this process is
	// giving up the player either way (it's disconnecting). The lease's own
	// TTL in Redis is what protects against a stale entry outliving it -
	// see redis_scripts/acquire.lua's PEXPIRE belt-and-suspenders.
	std::ignore = sessionManager->release(accountId, it->second.sessionId);
	tracked.erase(it);
}

std::vector<int32_t> ClusterRuntime::renewAllAndCollectExpired(int64_t nowMs) {
	std::lock_guard lock(mutex);
	std::vector<int32_t> expired;
	if (!enabled || tracked.empty()) {
		return expired;
	}

	for (auto it = tracked.begin(); it != tracked.end();) {
		const int32_t accountId = it->first;
		auto &session = it->second;

		const bool renewed = sessionManager->renew(accountId, session.sessionId, leaseTtlMs, nowMs);
		if (renewed) {
			session.expiresAtMs = nowMs + leaseTtlMs;
			++it;
			continue;
		}

		if (redisClient->isHealthy()) {
			// Redis answered fine and still said no: this session was
			// legitimately superseded (someone else now holds the lease,
			// or it had already expired on Redis's own clock). There is no
			// grace period for a real supersession - relinquish now.
			expired.push_back(accountId);
			it = tracked.erase(it);
			continue;
		}

		// Redis is unreachable (isHealthy() above just came back false for
		// this account's renew attempt). Keep playing locally, but only up
		// to whichever comes first: the configured failure grace period
		// since this lease was last genuinely renewed, or this lease's own
		// remaining validity running out (leaving no margin for one more
		// renew attempt before another process could legally steal it) -
		// see OPERATIONS.md "Redis outage" steps 3-4.
		const int64_t lastRenewedAtMs = session.expiresAtMs - leaseTtlMs;
		const bool pastGracePeriod = (nowMs - lastRenewedAtMs) >= failureGracePeriodMs;
		const bool lastChanceBeforeExpiry = nowMs >= (session.expiresAtMs - heartbeatIntervalMs);
		if (pastGracePeriod || lastChanceBeforeExpiry) {
			expired.push_back(accountId);
			it = tracked.erase(it);
			continue;
		}

		++it;
	}

	return expired;
}

std::size_t ClusterRuntime::trackedCount() const {
	std::lock_guard lock(mutex);
	return tracked.size();
}

std::optional<ClusterRuntime::TrackedSessionInfo> ClusterRuntime::getTrackedSessionInfo(int32_t accountId) const {
	std::lock_guard lock(mutex);
	const auto it = tracked.find(accountId);
	if (it == tracked.end()) {
		return std::nullopt;
	}
	return TrackedSessionInfo { it->second.sessionId, it->second.fencingToken };
}
