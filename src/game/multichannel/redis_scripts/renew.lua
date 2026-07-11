-- Atomic session-lease renew. Only the current holder (matched by
-- session_id) can renew, and only if the lease had not already expired -
-- an expired lease must not be silently resurrected by a late renew call
-- from a process that may have already been superseded (see
-- docs/multichannel/THREAT_MODEL.md T2).
--
-- KEYS[1] = lock key
-- ARGV[1] = session id the caller believes it holds
-- ARGV[2] = lease ttl in ms
-- ARGV[3] = current time in ms
--
-- Returns { renewed(0|1), fencingToken }

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
