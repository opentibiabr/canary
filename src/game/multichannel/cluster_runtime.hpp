/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/multichannel/cluster_session_manager.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <memory>
	#include <mutex>
	#include <string>
	#include <unordered_map>
	#include <vector>
#endif

// Orchestrates ClusterSessionManager against the live set of accounts this
// process currently believes are online, implementing the Redis-outage
// policy from docs/multichannel/OPERATIONS.md exactly: new logins/switches
// are blocked the instant Redis looks unhealthy (no grace period for those -
// see §Redis outage step 2), already-online accounts get
// `redisFailureGracePeriod` of continued local play while renews keep being
// retried, and any account whose lease is about to expire for real (per the
// lease's own `expires_at`, not local wall-clock guessing) is force-flagged
// so the caller can save+disconnect it before another process could
// legally steal the lease (§Redis outage step 4).
//
// This class only tracks bookkeeping (account -> session/expiry); it does
// not hold references to live Player/Connection objects, hasn't got engine
// dependencies, and does not perform the actual disconnect/save itself -
// Game/ProtocolGame call sites own that, using the account ids this class
// reports back. That split is what keeps this class unit-testable with
// FakeRedisClient (tests/shared/game/multichannel/fake_redis_client.hpp)
// exactly like ClusterSessionManager itself.
class ClusterRuntime {
public:
	static ClusterRuntime &getInstance();

	ClusterRuntime(const ClusterRuntime &) = delete;
	ClusterRuntime &operator=(const ClusterRuntime &) = delete;

	// Must be called once at startup, only when multiChannelEnabled is true
	// (see CanaryServer::initializeMultichannelCluster). A default-
	// constructed (unconfigured) ClusterRuntime always reports isEnabled()
	// == false and every operation is a safe no-op, so call sites that run
	// unconditionally (e.g. Player::onRemoveCreature) never need their own
	// multiChannelEnabled check.
	void configure(std::shared_ptr<IRedisClient> client, int32_t channelId, std::string instanceId, int64_t leaseTtlMs, int64_t heartbeatIntervalMs, int64_t failureGracePeriodMs);

	// Test-only hook mirroring ChannelRegistry::setChannelsForTesting.
	void resetForTesting();

	[[nodiscard]] bool isEnabled() const;

	// False the instant the underlying Redis client looks unhealthy - no
	// grace period for *new* sessions, per OPERATIONS.md step 2. Always true
	// when !isEnabled() (single-channel mode has no such concept).
	[[nodiscard]] bool isAcceptingNewSessions() const;

	// Attempts to acquire the account-wide lease for a fresh login. Returns
	// the handle as-is (acquired == false means "already online elsewhere",
	// the caller must reject the login with a clear message) - unless Redis
	// itself is unreachable, in which case this returns a not-acquired
	// handle immediately without even attempting the call, consistent with
	// isAcceptingNewSessions() being fail-closed.
	ClusterSessionHandle acquireForLogin(int32_t accountId, int32_t channelId, int64_t nowMs);

	// Clean logout: releases the lease and stops tracking the account. Safe
	// to call even if the account was never tracked (no-op).
	void releaseForLogout(int32_t accountId, int64_t nowMs);

	// One renew attempt per tracked account. Returns the account ids that
	// must be force-disconnected *now*: either because this process is no
	// longer the legitimate holder (superseded - Dirty, must relinquish
	// immediately, no grace period applies to a real supersession) or
	// because the lease's own expiry is within `disconnectMarginMs` of
	// `nowMs` and Redis has not answered a renew successfully since the
	// outage began (about to be legally stolen). Removes returned accounts
	// from internal tracking - the caller is now responsible for them.
	std::vector<int32_t> renewAllAndCollectExpired(int64_t nowMs);

	[[nodiscard]] std::size_t trackedCount() const;

private:
	ClusterRuntime() = default;

	struct TrackedSession {
		std::string sessionId;
		uint64_t fencingToken = 0;
		int64_t expiresAtMs = 0; // this process's own record of the lease's expiry
	};

	mutable std::mutex mutex;
	std::shared_ptr<IRedisClient> redisClient;
	std::unique_ptr<ClusterSessionManager> sessionManager;
	int32_t channelId = 0;
	std::string instanceId;
	int64_t leaseTtlMs = 30000;
	int64_t heartbeatIntervalMs = 5000;
	int64_t failureGracePeriodMs = 10000;
	bool enabled = false;

	std::unordered_map<int32_t, TrackedSession> tracked;
};

constexpr auto g_clusterRuntime = ClusterRuntime::getInstance;
