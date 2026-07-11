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

#include <mutex>
#include <unordered_map>

// In-memory model of the exact same compare-and-swap semantics implemented
// by src/game/multichannel/redis_scripts/{acquire,renew,release}.lua. Used
// so ClusterSessionManager's state machine can be unit-tested without a
// live Redis; the Lua scripts themselves are separately validated against a
// real local redis-server (see docs/multichannel/TEST_PLAN.md) to prove the
// two implementations agree.
class FakeRedisClient : public IRedisClient {
public:
	LeaseAcquireOutcome acquireLease(const std::string &lockKey, const std::string &sessionId, const std::string &channelId, const std::string &instanceId, int64_t ttlMs, int64_t nowMs) override {
		std::lock_guard lock(mutex);
		if (!healthy) {
			return {};
		}
		auto &entry = entries[lockKey];

		if (entry.expiresAt > nowMs) {
			return { false, entry.sessionId, entry.fencingToken };
		}

		entry.fencingToken += 1; // never reset by release - see below
		entry.sessionId = sessionId;
		entry.channelId = channelId;
		entry.instanceId = instanceId;
		entry.expiresAt = nowMs + ttlMs;

		return { true, entry.sessionId, entry.fencingToken };
	}

	LeaseRenewOutcome renewLease(const std::string &lockKey, const std::string &sessionId, int64_t ttlMs, int64_t nowMs) override {
		std::lock_guard lock(mutex);
		if (!healthy) {
			return {};
		}
		const auto it = entries.find(lockKey);
		if (it == entries.end() || it->second.sessionId != sessionId) {
			return { false, 0 };
		}
		if (it->second.expiresAt <= nowMs) {
			return { false, 0 };
		}
		it->second.expiresAt = nowMs + ttlMs;
		return { true, it->second.fencingToken };
	}

	bool releaseLease(const std::string &lockKey, const std::string &sessionId) override {
		std::lock_guard lock(mutex);
		if (!healthy) {
			return false;
		}
		const auto it = entries.find(lockKey);
		if (it == entries.end() || it->second.sessionId != sessionId) {
			return false;
		}
		// Fencing token is intentionally left untouched, matching
		// release.lua: it must never go backwards for this key.
		it->second.expiresAt = 0;
		return true;
	}

	std::optional<uint64_t> peekFencingToken(const std::string &lockKey) override {
		std::lock_guard lock(mutex);
		if (!healthy) {
			return std::nullopt;
		}
		const auto it = entries.find(lockKey);
		if (it == entries.end()) {
			return std::nullopt;
		}
		return it->second.fencingToken;
	}

	[[nodiscard]] bool isHealthy() const override {
		std::lock_guard lock(mutex);
		return healthy;
	}

	// Test-only: simulate a Redis outage (or recovery) without touching any
	// lease state, so a test can assert on ClusterRuntime's outage handling
	// independent of the CAS semantics above.
	void setHealthyForTesting(bool value) {
		std::lock_guard lock(mutex);
		healthy = value;
	}

private:
	struct Entry {
		std::string sessionId;
		std::string channelId;
		std::string instanceId;
		uint64_t fencingToken = 0;
		int64_t expiresAt = 0;
	};

	mutable std::mutex mutex;
	std::unordered_map<std::string, Entry> entries;
	bool healthy = true;
};
