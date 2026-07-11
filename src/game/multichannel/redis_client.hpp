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

struct LeaseAcquireOutcome {
	bool acquired = false;
	std::string sessionId;
	uint64_t fencingToken = 0;
};

struct LeaseRenewOutcome {
	bool renewed = false;
	uint64_t fencingToken = 0;
};

// Abstraction over the atomic Redis operations ClusterSessionManager needs.
// Every method here corresponds 1:1 to one of the Lua scripts in
// src/game/multichannel/redis_scripts/ — the production implementation
// (hiredis-backed, built only when the optional vcpkg "multichannel" feature
// is enabled) issues a single EVAL per call; tests use FakeRedisClient
// (tests/shared/game/multichannel/fake_redis_client.hpp), an in-memory model
// of the exact same compare-and-swap semantics, so ClusterSessionManager's
// state machine is fully unit-testable without a live Redis. The scripts
// themselves are additionally validated against a real local redis-server
// (see docs/multichannel/TEST_PLAN.md) — this interface is the seam between
// that real integration proof and the C++ state machine logic.
//
// The production hiredis-backed implementation is intentionally not
// included in this PR (see docs/multichannel/ARCHITECTURE.md §5): writing
// it against an API this sandbox cannot compile or test would be exactly
// the kind of blind, unverified change the spec asks this project to avoid
// for anti-dupe-critical code.
class IRedisClient {
public:
	virtual ~IRedisClient() = default;

	// Atomically acquires the lease at lockKey if unheld or expired. On
	// success, issues a fencing token that is monotonically increasing for
	// the lifetime of lockKey (it is never reset by acquire/release, only by
	// operator intervention - see redis_scripts/acquire.lua).
	virtual LeaseAcquireOutcome acquireLease(const std::string &lockKey, const std::string &sessionId, const std::string &channelId, const std::string &instanceId, int64_t ttlMs, int64_t nowMs) = 0;

	// Atomically extends the lease's expiry, but only if sessionId is still
	// the current holder and the lease had not already expired.
	virtual LeaseRenewOutcome renewLease(const std::string &lockKey, const std::string &sessionId, int64_t ttlMs, int64_t nowMs) = 0;

	// Atomically releases the lease, but only if sessionId is still the
	// current holder. The fencing token counter is preserved (not reset) so
	// a subsequent acquire always issues a strictly greater token.
	virtual bool releaseLease(const std::string &lockKey, const std::string &sessionId) = 0;

	// Read-only: the current fencing token for lockKey, if any has ever been
	// issued. Used to check whether a token a caller is holding is still
	// current (anti-zombie-write check, see THREAT_MODEL.md T2).
	virtual std::optional<uint64_t> peekFencingToken(const std::string &lockKey) = 0;

	// True if the connection itself is currently usable. This is the signal
	// ClusterRuntime (docs/multichannel/OPERATIONS.md "Redis outage") needs
	// to tell "Redis is unreachable, retry within the failure grace period"
	// apart from "Redis answered fine and legitimately rejected this call"
	// (e.g. someone else holds the lease) - the two must never be handled
	// the same way, since the first should not immediately relinquish a
	// still-legitimately-held session and the second must relinquish it
	// immediately, with no grace period at all.
	[[nodiscard]] virtual bool isHealthy() const = 0;
};
