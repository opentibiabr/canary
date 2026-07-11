-- Atomic session-lease release. Only the current holder (matched by
-- session_id) can release. The fencing_token field is deliberately left
-- untouched (not deleted) so the next acquire's HINCRBY continues the
-- sequence - the token stays strictly monotonic for this key's entire
-- lifetime, across any number of clean release/reacquire cycles.
--
-- KEYS[1] = lock key
-- ARGV[1] = session id the caller believes it holds
--
-- Returns { released(0|1) }

local key = KEYS[1]
local sessionId = ARGV[1]

local currentSessionId = redis.call('HGET', key, 'session_id')
if not currentSessionId or currentSessionId ~= sessionId then
	return { 0 }
end

redis.call('HSET', key, 'expires_at', '0')
return { 1 }
