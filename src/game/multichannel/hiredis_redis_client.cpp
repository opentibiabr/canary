/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/hiredis_redis_client.hpp"

#ifdef CANARY_MULTICHANNEL_REDIS

	#include <hiredis/hiredis.h>

	#ifndef USE_PRECOMPILED_HEADERS
		#include <algorithm>
		#include <cstdlib>
		#include <cstring>
	#endif

namespace {
	// Embedded verbatim from redis_scripts/*.lua (see docs/multichannel/
	// ARCHITECTURE.md §5) rather than read from disk at runtime, so the
	// production client can never drift from - or be pointed at a tampered
	// copy of - the exact scripts already validated in TEST_PLAN.md against
	// a real redis-server.
	constexpr const char* kAcquireScript = R"lua(
local key = KEYS[1]
local newSessionId = ARGV[1]
local channelId = ARGV[2]
local instanceId = ARGV[3]
local ttlMs = tonumber(ARGV[4])
local nowMs = tonumber(ARGV[5])

local existingExpiresAt = tonumber(redis.call("HGET", key, "expires_at"))
if existingExpiresAt and existingExpiresAt > nowMs then
	local currentSessionId = redis.call("HGET", key, "session_id")
	local currentFencingToken = redis.call("HGET", key, "fencing_token")
	return { 0, currentSessionId, currentFencingToken }
end

local fencingToken = redis.call("HINCRBY", key, "fencing_token", 1)
redis.call("HSET", key, "session_id", newSessionId, "channel_id", channelId, "instance_id", instanceId, "expires_at", tostring(nowMs + ttlMs))
redis.call("PEXPIRE", key, ttlMs * 4)

return { 1, newSessionId, fencingToken }
)lua";

	constexpr const char* kRenewScript = R"lua(
local key = KEYS[1]
local sessionId = ARGV[1]
local ttlMs = tonumber(ARGV[2])
local nowMs = tonumber(ARGV[3])

local currentSessionId = redis.call("HGET", key, "session_id")
if not currentSessionId or currentSessionId ~= sessionId then
	return { 0 }
end

local currentExpiresAt = tonumber(redis.call("HGET", key, "expires_at"))
if not currentExpiresAt or currentExpiresAt <= nowMs then
	return { 0 }
end

redis.call("HSET", key, "expires_at", tostring(nowMs + ttlMs))
redis.call("PEXPIRE", key, ttlMs * 4)

local fencingToken = redis.call("HGET", key, "fencing_token")
return { 1, fencingToken }
)lua";

	constexpr const char* kReleaseScript = R"lua(
local key = KEYS[1]
local sessionId = ARGV[1]

local currentSessionId = redis.call("HGET", key, "session_id")
if not currentSessionId or currentSessionId ~= sessionId then
	return { 0 }
end

redis.call("HSET", key, "expires_at", "0")
return { 1 }
)lua";
} // namespace

HiredisRedisClient::HiredisRedisClient(Options opts) :
	options(std::move(opts)) { }

HiredisRedisClient::~HiredisRedisClient() {
	if (context) {
		redisFree(context);
	}
}

bool HiredisRedisClient::ensureConnected() {
	if (context && context->err == 0) {
		return true;
	}
	if (context) {
		redisFree(context);
		context = nullptr;
	}

	timeval timeout {};
	timeout.tv_sec = options.connectTimeoutMs / 1000;
	timeout.tv_usec = (options.connectTimeoutMs % 1000) * 1000;

	context = redisConnectWithTimeout(options.host.c_str(), options.port, timeout);
	if (!context || context->err) {
		healthy = false;
		if (context) {
			redisFree(context);
			context = nullptr;
		}
		return false;
	}
	redisSetTimeout(context, timeout);

	if (!options.password.empty()) {
		redisReply* reply = nullptr;
		if (!options.username.empty()) {
			reply = static_cast<redisReply*>(redisCommand(context, "AUTH %s %s", options.username.c_str(), options.password.c_str()));
		} else {
			reply = static_cast<redisReply*>(redisCommand(context, "AUTH %s", options.password.c_str()));
		}
		const bool authOk = reply && reply->type != REDIS_REPLY_ERROR;
		if (reply) {
			freeReplyObject(reply);
		}
		if (!authOk) {
			redisFree(context);
			context = nullptr;
			healthy = false;
			return false;
		}
	}

	if (options.database != 0) {
		redisReply* reply = static_cast<redisReply*>(redisCommand(context, "SELECT %d", options.database));
		const bool selectOk = reply && reply->type != REDIS_REPLY_ERROR;
		if (reply) {
			freeReplyObject(reply);
		}
		if (!selectOk) {
			redisFree(context);
			context = nullptr;
			healthy = false;
			return false;
		}
	}

	// Re-cache script SHAs on every fresh connection - a Redis restart (or
	// failover to a replica promoted without the script cache) means any
	// previously-cached SHA is no longer guaranteed to resolve.
	acquireSha.clear();
	renewSha.clear();
	releaseSha.clear();
	healthy = true;
	return true;
}

namespace {
	std::string loadScript(redisContext* context, const char* body) {
		redisReply* reply = static_cast<redisReply*>(redisCommand(context, "SCRIPT LOAD %s", body));
		std::string sha;
		if (reply && reply->type == REDIS_REPLY_STRING) {
			sha.assign(reply->str, reply->len);
		}
		if (reply) {
			freeReplyObject(reply);
		}
		return sha;
	}

	std::vector<std::string> flattenReply(redisReply* reply) {
		std::vector<std::string> out;
		if (!reply || reply->type != REDIS_REPLY_ARRAY) {
			return out;
		}
		out.reserve(reply->elements);
		for (std::size_t i = 0; i < reply->elements; ++i) {
			redisReply* element = reply->element[i];
			if (!element) {
				out.emplace_back();
			} else if (element->type == REDIS_REPLY_INTEGER) {
				out.push_back(std::to_string(element->integer));
			} else if (element->type == REDIS_REPLY_STRING || element->type == REDIS_REPLY_STATUS) {
				out.emplace_back(element->str, element->len);
			} else {
				out.emplace_back();
			}
		}
		return out;
	}
} // namespace

std::vector<std::string> HiredisRedisClient::evalScript(std::string &cachedSha, const char* scriptBody, const std::string &key, const std::vector<std::string> &argv) {
	std::lock_guard<std::mutex> lock(mutex);

	if (!ensureConnected()) {
		return {};
	}
	if (cachedSha.empty()) {
		cachedSha = loadScript(context, scriptBody);
		if (cachedSha.empty()) {
			healthy = false;
			return {};
		}
	}

	std::vector<std::string> args;
	args.reserve(4 + argv.size());
	args.emplace_back("EVALSHA");
	args.push_back(cachedSha);
	args.emplace_back("1");
	args.push_back(key);
	for (const auto &arg : argv) {
		args.push_back(arg);
	}

	std::vector<const char*> argv_c(args.size());
	std::vector<std::size_t> argvlen(args.size());
	for (std::size_t i = 0; i < args.size(); ++i) {
		argv_c[i] = args[i].c_str();
		argvlen[i] = args[i].size();
	}

	redisReply* reply = static_cast<redisReply*>(redisCommandArgv(context, static_cast<int>(argv_c.size()), argv_c.data(), argvlen.data()));
	if (!reply) {
		healthy = false;
		return {};
	}

	if (reply->type == REDIS_REPLY_ERROR && reply->str && std::strstr(reply->str, "NOSCRIPT") != nullptr) {
		freeReplyObject(reply);
		// Script cache miss (e.g. a Redis restart/failover) - reload and
		// retry once via EVAL directly, which also re-populates the cache
		// for subsequent EVALSHA calls.
		cachedSha = loadScript(context, scriptBody);
		if (cachedSha.empty()) {
			healthy = false;
			return {};
		}
		args[0] = "EVAL";
		args[1] = scriptBody;
		for (std::size_t i = 0; i < args.size(); ++i) {
			argv_c[i] = args[i].c_str();
			argvlen[i] = args[i].size();
		}
		reply = static_cast<redisReply*>(redisCommandArgv(context, static_cast<int>(argv_c.size()), argv_c.data(), argvlen.data()));
		if (!reply) {
			healthy = false;
			return {};
		}
	}

	if (reply->type == REDIS_REPLY_ERROR) {
		freeReplyObject(reply);
		// A real Lua error is not a connectivity problem - the scripts are
		// fixed and already validated, so this should not happen in
		// practice, but do not mask it as "healthy" silently either.
		healthy = false;
		return {};
	}

	auto result = flattenReply(reply);
	freeReplyObject(reply);
	healthy = true;
	return result;
}

LeaseAcquireOutcome HiredisRedisClient::acquireLease(const std::string &lockKey, const std::string &sessionId, const std::string &channelId, const std::string &instanceId, int64_t ttlMs, int64_t nowMs) {
	auto reply = evalScript(acquireSha, kAcquireScript, lockKey, { sessionId, channelId, instanceId, std::to_string(ttlMs), std::to_string(nowMs) });
	LeaseAcquireOutcome outcome;
	if (reply.size() < 3) {
		return outcome;
	}
	outcome.acquired = reply[0] == "1";
	outcome.sessionId = outcome.acquired ? sessionId : reply[1];
	outcome.fencingToken = strtoull(reply[2].c_str(), nullptr, 10);
	return outcome;
}

LeaseRenewOutcome HiredisRedisClient::renewLease(const std::string &lockKey, const std::string &sessionId, int64_t ttlMs, int64_t nowMs) {
	auto reply = evalScript(renewSha, kRenewScript, lockKey, { sessionId, std::to_string(ttlMs), std::to_string(nowMs) });
	LeaseRenewOutcome outcome;
	if (reply.empty()) {
		return outcome;
	}
	outcome.renewed = reply[0] == "1";
	if (outcome.renewed && reply.size() >= 2) {
		outcome.fencingToken = strtoull(reply[1].c_str(), nullptr, 10);
	}
	return outcome;
}

bool HiredisRedisClient::releaseLease(const std::string &lockKey, const std::string &sessionId) {
	auto reply = evalScript(releaseSha, kReleaseScript, lockKey, { sessionId });
	return !reply.empty() && reply[0] == "1";
}

std::optional<uint64_t> HiredisRedisClient::peekFencingToken(const std::string &lockKey) {
	std::lock_guard<std::mutex> lock(mutex);
	if (!ensureConnected()) {
		return std::nullopt;
	}
	const char* argv_c[] = { "HGET", lockKey.c_str(), "fencing_token" };
	std::size_t argvlen[] = { 4, lockKey.size(), 13 };
	redisReply* reply = static_cast<redisReply*>(redisCommandArgv(context, 3, argv_c, argvlen));
	if (!reply) {
		healthy = false;
		return std::nullopt;
	}
	std::optional<uint64_t> result;
	if (reply->type == REDIS_REPLY_STRING) {
		result = strtoull(reply->str, nullptr, 10);
	}
	freeReplyObject(reply);
	healthy = true;
	return result;
}

bool HiredisRedisClient::isHealthy() const {
	std::lock_guard<std::mutex> lock(mutex);
	return healthy;
}

#endif // CANARY_MULTICHANNEL_REDIS
