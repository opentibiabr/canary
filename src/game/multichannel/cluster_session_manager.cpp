/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/cluster_session_manager.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <iomanip>
	#include <random>
	#include <sstream>
#endif

ClusterSessionHandle ClusterSessionManager::acquire(int32_t accountId, int32_t channelId, const std::string &instanceId, int64_t ttlMs, int64_t nowMs) {
	const std::string lockKey = makeLockKey(accountId);
	const std::string sessionId = generateSessionId();

	const auto outcome = redisClient.acquireLease(lockKey, sessionId, std::to_string(channelId), instanceId, ttlMs, nowMs);

	ClusterSessionHandle handle;
	if (outcome.acquired) {
		handle.acquired = true;
		handle.sessionId = outcome.sessionId;
		handle.fencingToken = outcome.fencingToken;
		handle.status = ClusterSessionStatus::Online;
	} else {
		handle.acquired = false;
		handle.status = ClusterSessionStatus::Offline;
		handle.currentHolderSessionId = outcome.sessionId;
		handle.currentHolderFencingToken = outcome.fencingToken;
	}
	return handle;
}

bool ClusterSessionManager::renew(int32_t accountId, const std::string &sessionId, int64_t ttlMs, int64_t nowMs) {
	const std::string lockKey = makeLockKey(accountId);
	const auto outcome = redisClient.renewLease(lockKey, sessionId, ttlMs, nowMs);
	return outcome.renewed;
}

bool ClusterSessionManager::release(int32_t accountId, const std::string &sessionId) {
	const std::string lockKey = makeLockKey(accountId);
	return redisClient.releaseLease(lockKey, sessionId);
}

bool ClusterSessionManager::isFencingTokenCurrent(int32_t accountId, uint64_t fencingToken) {
	const auto current = redisClient.peekFencingToken(makeLockKey(accountId));
	return current.has_value() && *current == fencingToken;
}

bool ClusterSessionManager::isValidTransition(ClusterSessionStatus from, ClusterSessionStatus to) {
	switch (from) {
		case ClusterSessionStatus::Offline:
			return to == ClusterSessionStatus::Acquiring;
		case ClusterSessionStatus::Acquiring:
			return to == ClusterSessionStatus::Online || to == ClusterSessionStatus::Offline || to == ClusterSessionStatus::Dirty;
		case ClusterSessionStatus::Online:
			return to == ClusterSessionStatus::Saving || to == ClusterSessionStatus::Dirty;
		case ClusterSessionStatus::Saving:
			return to == ClusterSessionStatus::Offline || to == ClusterSessionStatus::Dirty;
		case ClusterSessionStatus::Dirty:
			// Only an explicit recovery step may clear a dirty session - see
			// docs/multichannel/ARCHITECTURE.md §5.3. There is no automatic
			// path out of Dirty.
			return to == ClusterSessionStatus::Offline;
	}
	return false;
}

std::string ClusterSessionManager::makeLockKey(int32_t accountId) {
	return "cluster:session:" + std::to_string(accountId);
}

std::string ClusterSessionManager::generateSessionId() {
	// Random 128-bit token. This is a CAS-ownership tag, not a security
	// credential, so std::random_device-seeded std::mt19937_64 is
	// appropriate - no need for a cryptographic RNG here.
	static thread_local std::mt19937_64 engine(std::random_device {}());
	std::uniform_int_distribution<uint64_t> distribution;

	const uint64_t high = distribution(engine);
	const uint64_t low = distribution(engine);

	// Zero-padded to a fixed width: without padding, variable-width hex
	// concatenation could let two different (high, low) pairs render to the
	// same string (e.g. 0x1/0x23 and 0x12/0x3 would both be "123"), which
	// would be a real collision risk for a value whose entire job is
	// uniqueness.
	std::ostringstream stream;
	stream << std::hex << std::setfill('0') << std::setw(16) << high << std::setw(16) << low;
	return stream.str();
}
