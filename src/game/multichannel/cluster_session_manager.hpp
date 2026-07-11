/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/multichannel/redis_client.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <string>
#endif

// Lifecycle states from docs/multichannel/ARCHITECTURE.md §5.1. Dirty is
// reachable from Acquiring/Online/Saving (a fencing conflict or lease loss
// can be detected at any point); the happy path is
// Offline -> Acquiring -> Online -> Saving -> Offline.
enum class ClusterSessionStatus : uint8_t {
	Acquiring,
	Online,
	Saving,
	Dirty,
	Offline,
};

struct ClusterSessionHandle {
	bool acquired = false;
	std::string sessionId;
	uint64_t fencingToken = 0;
	ClusterSessionStatus status = ClusterSessionStatus::Offline;
	// Set when acquired == false: describes who currently holds the lease,
	// so the caller can report a meaningful "already online elsewhere"
	// error instead of a bare rejection.
	std::string currentHolderSessionId;
	uint64_t currentHolderFencingToken = 0;
};

// One online character per account, cluster-wide, enforced via an atomic
// Redis lease with a monotonic fencing token (docs/multichannel/
// ARCHITECTURE.md §5, THREAT_MODEL.md T1/T2). This class is the fast-path
// coordinator; the `cluster_sessions` DB table (PRIMARY KEY(account_id) +
// UNIQUE(player_id)) is the defense-in-depth layer that holds even if Redis
// is wiped, wrong, or bypassed entirely - see docs/multichannel/MIGRATION.md
// for that table's shape. Wiring this class into the actual login/logout
// call sites is Phase 2 (docs/multichannel/ARCHITECTURE.md §5).
class ClusterSessionManager {
public:
	explicit ClusterSessionManager(IRedisClient &client) :
		redisClient(client) { }

	ClusterSessionManager(const ClusterSessionManager &) = delete;
	ClusterSessionManager &operator=(const ClusterSessionManager &) = delete;

	// Attempts to acquire the lease for accountId. On success, the returned
	// handle's status is Online and fencingToken is the new, strictly
	// greater-than-before token for this account. On failure, acquired is
	// false and currentHolder* describes the existing lease.
	[[nodiscard]] ClusterSessionHandle acquire(int32_t accountId, int32_t channelId, const std::string &instanceId, int64_t ttlMs, int64_t nowMs);

	// Renews an already-acquired lease. Returns false (and the caller must
	// treat the session as no longer safely held) if this sessionId is not
	// the current holder or the lease had already expired - never silently
	// resurrects a lost lease.
	[[nodiscard]] bool renew(int32_t accountId, const std::string &sessionId, int64_t ttlMs, int64_t nowMs);

	// Releases an already-acquired lease. Returns false if sessionId is not
	// the current holder (e.g. it was already superseded) - the caller must
	// not treat that as a successful clean release.
	[[nodiscard]] bool release(int32_t accountId, const std::string &sessionId);

	// True if fencingToken is still the current token for accountId. A
	// persistent write performed under a stale token must be rejected, not
	// merged or retried - see THREAT_MODEL.md T2.
	[[nodiscard]] bool isFencingTokenCurrent(int32_t accountId, uint64_t fencingToken);

	// Validates a lifecycle transition per the state diagram above. Pure and
	// side-effect free, used both by tests and by whatever Phase 2 code
	// drives the actual `cluster_sessions.status` column.
	[[nodiscard]] static bool isValidTransition(ClusterSessionStatus from, ClusterSessionStatus to);

	[[nodiscard]] static std::string makeLockKey(int32_t accountId);
	[[nodiscard]] static std::string generateSessionId();

private:
	IRedisClient &redisClient;
};
