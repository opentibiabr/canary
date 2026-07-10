local Analytics = GameplayAnalytics
if not Analytics then
	error("GameplayAnalytics must be loaded before gameplay_analytics_reliability.lua")
end

if Analytics.reliabilityInstalled then
	return Analytics
end

Analytics.reliabilityInstalled = true
Analytics.deadLetterQueue = Analytics.deadLetterQueue or {}
Analytics.health = Analytics.health or {
	successfulFlushes = 0,
	failedFlushes = 0,
	persistedSessions = 0,
	retriedSessions = 0,
	deadLetteredSessions = 0,
	persistedDeadLetters = 0,
	droppedSessions = 0,
	droppedDeadLetters = 0,
	lastFlushDurationMs = 0,
	lastFlushProcessed = 0,
	lastFlushFailed = 0,
	lastDeadLetterPersistedAt = 0,
}

local originalEnqueue = Analytics.enqueue
local originalFlush = Analytics.flush
local originalStatus = Analytics.status
local originalStopRuntime = Analytics.stopRuntime

local function now()
	return os.time()
end

local function clampInteger(value, minimum, maximum, fallback)
	value = tonumber(value)
	if not value then
		return fallback
	end
	value = math.floor(value)
	if value < minimum then
		return minimum
	end
	if maximum and value > maximum then
		return maximum
	end
	return value
end

local function escaped(value)
	return db.escapeString(tostring(value or ""))
end

local function queueLimit()
	return clampInteger(Analytics.config.queueLimit, 100, nil, 10000)
end

local function deadLetterQueueLimit()
	return clampInteger(Analytics.config.deadLetterQueueLimit, 1, nil, 1000)
end

local function maxRetryAttempts()
	return clampInteger(Analytics.config.maxRetryAttempts, 0, 100, 5)
end

local function retryDelay(attempt)
	local base = clampInteger(Analytics.config.retryBaseDelaySeconds, 1, nil, 30)
	local maximum = clampInteger(Analytics.config.retryMaxDelaySeconds, base, nil, 900)
	local exponent = math.min(math.max(0, attempt - 1), 20)
	return math.min(maximum, base * (2 ^ exponent))
end

local function deadLetterInsert(entry)
	local session = entry.session
	local nameSql = session.playerName and escaped(session.playerName) or "NULL"
	local healingTotal = (tonumber(session.healingSelf) or 0) + (tonumber(session.healingOthers) or 0)
	return string.format(
		[[INSERT INTO `analytics_dead_letters`
        (`session_uuid`,`player_id`,`player_name`,`retry_count`,`last_error`,`failed_at`,`started_at`,`ended_at`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_total`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`)
        VALUES (%s,%d,%s,%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d)
        ON DUPLICATE KEY UPDATE
        `player_id`=VALUES(`player_id`),`player_name`=VALUES(`player_name`),`retry_count`=VALUES(`retry_count`),`last_error`=VALUES(`last_error`),`failed_at`=VALUES(`failed_at`),`started_at`=VALUES(`started_at`),`ended_at`=VALUES(`ended_at`),`experience_raw`=VALUES(`experience_raw`),`experience_final`=VALUES(`experience_final`),`damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`),`healing_total`=VALUES(`healing_total`),`mana_spent`=VALUES(`mana_spent`),`monsters_killed`=VALUES(`monsters_killed`),`deaths`=VALUES(`deaths`),`loot_value_npc`=VALUES(`loot_value_npc`),`loot_value_market`=VALUES(`loot_value_market`),`supplies_value`=VALUES(`supplies_value`)]],
		escaped(session.uuid),
		tonumber(session.playerId) or 0,
		nameSql,
		tonumber(session.retryCount) or 0,
		escaped(entry.reason),
		entry.failedAt,
		tonumber(session.startedAt) or 0,
		tonumber(session.endedAt) or 0,
		tonumber(session.experienceRaw) or 0,
		tonumber(session.experienceFinal) or 0,
		tonumber(session.damageDealt) or 0,
		tonumber(session.damageReceived) or 0,
		healingTotal,
		tonumber(session.manaSpent) or 0,
		tonumber(session.monstersKilled) or 0,
		tonumber(session.deaths) or 0,
		tonumber(session.lootNpc) or 0,
		tonumber(session.lootMarket) or 0,
		tonumber(session.suppliesValue) or 0
	)
end

local function pushDeadLetter(session, reason)
	if #Analytics.deadLetterQueue >= deadLetterQueueLimit() then
		Analytics.health.droppedDeadLetters = Analytics.health.droppedDeadLetters + 1
		logger.error("[GameplayAnalytics] Dead-letter queue limit reached; discarding session {}", session.uuid)
		return false
	end

	Analytics.deadLetterQueue[#Analytics.deadLetterQueue + 1] = {
		session = session,
		reason = tostring(reason or "persistence failure"),
		failedAt = now(),
	}
	Analytics.health.deadLetteredSessions = Analytics.health.deadLetteredSessions + 1
	logger.error("[GameplayAnalytics] Session {} moved to dead-letter queue after {} retries.", session.uuid, session.retryCount or 0)
	return true
end

function Analytics.persistDeadLetters()
	if Analytics.config.databaseEnabled ~= true then
		Analytics.deadLetterQueue = {}
		return 0
	end
	if #Analytics.deadLetterQueue == 0 then
		return 0
	end

	local pending = Analytics.deadLetterQueue
	Analytics.deadLetterQueue = {}
	local persisted = 0
	for _, entry in ipairs(pending) do
		if db.query(deadLetterInsert(entry)) == true then
			persisted = persisted + 1
			Analytics.health.persistedDeadLetters = Analytics.health.persistedDeadLetters + 1
			Analytics.health.lastDeadLetterPersistedAt = now()
		elseif #Analytics.deadLetterQueue < deadLetterQueueLimit() then
			Analytics.deadLetterQueue[#Analytics.deadLetterQueue + 1] = entry
		else
			Analytics.health.droppedDeadLetters = Analytics.health.droppedDeadLetters + 1
			logger.error("[GameplayAnalytics] Dead-letter queue overflow while retrying session {}", entry.session.uuid)
		end
	end
	return persisted
end

function Analytics.enqueue(session)
	if Analytics.config.databaseEnabled ~= true then
		return originalEnqueue(session)
	end

	session.retryCount = tonumber(session.retryCount) or 0
	session.nextRetryAt = tonumber(session.nextRetryAt) or 0

	if Analytics._reliabilityRetrying then
		Analytics._reliabilityCurrentFlushFailures = (Analytics._reliabilityCurrentFlushFailures or 0) + 1
		session.retryCount = session.retryCount + 1
		if session.retryCount > maxRetryAttempts() then
			return pushDeadLetter(session, "persistence failed after maximum retry attempts")
		end
		session.nextRetryAt = now() + retryDelay(session.retryCount)
		Analytics.health.retriedSessions = Analytics.health.retriedSessions + 1
	end

	if #Analytics.queue >= queueLimit() then
		Analytics.health.droppedSessions = Analytics.health.droppedSessions + 1
		pushDeadLetter(session, "analytics queue limit reached")
		return false
	end

	return originalEnqueue(session)
end

local function appendQueue(target, source)
	for _, session in ipairs(source) do
		target[#target + 1] = session
	end
end

function Analytics.flush(force)
	local started = os.clock()
	if Analytics.config.databaseEnabled ~= true then
		local queued = #Analytics.queue
		Analytics.deadLetterQueue = {}
		local resultValue = originalFlush()
		Analytics.health.lastFlushProcessed = queued
		Analytics.health.lastFlushFailed = 0
		Analytics.health.lastFlushDurationMs = math.max(0, math.floor((os.clock() - started) * 1000 + 0.5))
		return resultValue
	end

	local timestamp = now()
	local ready = {}
	local delayed = {}

	for _, session in ipairs(Analytics.queue) do
		if force or (tonumber(session.nextRetryAt) or 0) <= timestamp then
			ready[#ready + 1] = session
		else
			delayed[#delayed + 1] = session
		end
	end

	Analytics.queue = ready
	Analytics._reliabilityCurrentFlushFailures = 0
	Analytics._reliabilityRetrying = true
	local resultValue = originalFlush()
	Analytics._reliabilityRetrying = false
	local failed = Analytics._reliabilityCurrentFlushFailures or 0
	Analytics._reliabilityCurrentFlushFailures = nil

	local generated = Analytics.queue
	Analytics.queue = {}
	appendQueue(Analytics.queue, generated)
	appendQueue(Analytics.queue, delayed)

	Analytics.health.lastFlushProcessed = #ready
	Analytics.health.lastFlushFailed = failed
	Analytics.health.lastFlushDurationMs = math.max(0, math.floor((os.clock() - started) * 1000 + 0.5))

	if #ready > 0 then
		if failed > 0 then
			Analytics.health.failedFlushes = Analytics.health.failedFlushes + 1
		else
			Analytics.health.successfulFlushes = Analytics.health.successfulFlushes + 1
		end
		Analytics.health.persistedSessions = Analytics.health.persistedSessions + math.max(0, #ready - failed)
	end

	Analytics.persistDeadLetters()
	return resultValue and failed == 0
end

function Analytics.stopRuntime()
	originalStopRuntime()
	Analytics.flush(true)
	Analytics.persistDeadLetters()
end

function Analytics.status()
	local status = originalStatus()
	local timestamp = now()
	local oldestAge = 0
	local retrying = 0
	for _, session in ipairs(Analytics.queue) do
		oldestAge = math.max(oldestAge, timestamp - (tonumber(session.endedAt) or timestamp))
		if (tonumber(session.nextRetryAt) or 0) > timestamp then
			retrying = retrying + 1
		end
	end

	status.retryingSessions = retrying
	status.deadLetterQueueSize = #Analytics.deadLetterQueue
	status.oldestQueuedAgeSeconds = oldestAge
	for key, value in pairs(Analytics.health) do
		status[key] = value
	end
	return status
end

return Analytics
