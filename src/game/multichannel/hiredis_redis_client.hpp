/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

// Only declared when the optional "multichannel" vcpkg feature (hiredis) was
// actually compiled in (see docs/multichannel/ARCHITECTURE.md §9). Nothing
// outside a matching `#ifdef CANARY_MULTICHANNEL_REDIS` block may name
// HiredisRedisClient - the same macro already gates
// ClusterConfigValidator's redisClientCompiledIn check in canary_server.cpp.
#ifdef CANARY_MULTICHANNEL_REDIS

	#include "game/multichannel/redis_client.hpp"

	#ifndef USE_PRECOMPILED_HEADERS
		#include <mutex>
		#include <string>
		#include <vector>
	#endif

struct redisContext;

// Production IRedisClient backed by hiredis. One instance per process, one
// physical connection, guarded by a mutex: ClusterSessionManager is called
// from the dispatcher thread for the common case, but startup/shutdown and
// the heartbeat cycleEvent may call it from different points in the task
// queue, so this class does not assume single-threaded access even though
// hiredis' own synchronous API is not internally thread-safe.
//
// Reconnects lazily and with a bounded backoff on the next call after a
// connection is lost, rather than retrying in a background thread - keeps
// the failure mode simple and observable (a call either succeeds, or it
// throws RedisUnavailableError and the caller - ClusterRuntimeGuard, see
// cluster_runtime_guard.hpp - decides what "unavailable" means for gameplay,
// per docs/multichannel/OPERATIONS.md's Redis outage policy).
class HiredisRedisClient final : public IRedisClient {
public:
	struct Options {
		std::string host = "127.0.0.1";
		int port = 6379;
		int database = 0;
		std::string username;
		std::string password;
		int connectTimeoutMs = 2000;
	};

	explicit HiredisRedisClient(Options options);
	~HiredisRedisClient() override;

	HiredisRedisClient(const HiredisRedisClient &) = delete;
	HiredisRedisClient &operator=(const HiredisRedisClient &) = delete;

	LeaseAcquireOutcome acquireLease(const std::string &lockKey, const std::string &sessionId, const std::string &channelId, const std::string &instanceId, int64_t ttlMs, int64_t nowMs) override;
	LeaseRenewOutcome renewLease(const std::string &lockKey, const std::string &sessionId, int64_t ttlMs, int64_t nowMs) override;
	bool releaseLease(const std::string &lockKey, const std::string &sessionId) override;
	std::optional<uint64_t> peekFencingToken(const std::string &lockKey) override;

	// True if the last operation succeeded (or none has run yet and the
	// initial connect succeeded). Used by ClusterRuntimeGuard to detect an
	// outage without needing a separate PING poll loop - every real call
	// already tells us.
	[[nodiscard]] bool isHealthy() const;

private:
	bool ensureConnected();

	// Runs EVALSHA, transparently falling back to EVAL + re-caching the SHA
	// on a NOSCRIPT reply (e.g. after a Redis restart flushed the script
	// cache). The returned vector holds the Lua script's flat reply array
	// (integers as their decimal string form, bulk strings as-is); empty on
	// any connection-level failure, which the caller treats as "Redis
	// unavailable", not as a normal lease rejection.
	std::vector<std::string> evalScript(std::string &cachedSha, const char* scriptBody, const std::string &key, const std::vector<std::string> &argv);

	Options options;
	redisContext* context = nullptr;
	mutable std::mutex mutex;
	bool healthy = false;

	std::string acquireSha;
	std::string renewSha;
	std::string releaseSha;
};

#endif // CANARY_MULTICHANNEL_REDIS
