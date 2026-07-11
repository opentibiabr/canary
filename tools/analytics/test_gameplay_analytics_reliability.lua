local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local databaseWritesSucceed = false
local simulatedSessionFailure = true

logger = {
	error = function() end,
}

db = {
	escapeString = function(value)
		return string.format("'%s'", tostring(value):gsub("'", "''"))
	end,
	query = function(query)
		if query:find("analytics_dead_letters", 1, true) then
			return databaseWritesSucceed
		end
		return databaseWritesSucceed
	end,
}

GameplayAnalytics = {
	config = {
		databaseEnabled = true,
		queueLimit = 10,
		maxRetryAttempts = 2,
		retryBaseDelaySeconds = 30,
		retryMaxDelaySeconds = 120,
		deadLetterQueueLimit = 10,
	},
	queue = {},
	running = true,
	lastFlush = 0,
}

function GameplayAnalytics.enqueue(session)
	if GameplayAnalytics.config.databaseEnabled ~= true then
		return true
	end
	if #GameplayAnalytics.queue >= GameplayAnalytics.config.queueLimit then
		return false
	end
	GameplayAnalytics.queue[#GameplayAnalytics.queue + 1] = session
	return true
end

function GameplayAnalytics.flush()
	if GameplayAnalytics.config.databaseEnabled ~= true then
		GameplayAnalytics.queue = {}
		return true
	end

	local pending = GameplayAnalytics.queue
	GameplayAnalytics.queue = {}
	for _, session in ipairs(pending) do
		if simulatedSessionFailure then
			GameplayAnalytics.enqueue(session)
		end
	end
	return true
end

function GameplayAnalytics.status()
	return {
		enabled = true,
		running = GameplayAnalytics.running,
		activeSessions = 0,
		queuedSessions = #GameplayAnalytics.queue,
		lastFlush = GameplayAnalytics.lastFlush,
		detailLevel = 1,
	}
end

function GameplayAnalytics.stopRuntime()
	GameplayAnalytics.running = false
	GameplayAnalytics.flush()
end

local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")

local session = {
	uuid = "00000000-0000-0000-0000-000000000001",
	playerId = 1,
	playerName = "Retry Tester",
	startedAt = os.time() - 60,
	endedAt = os.time(),
	experienceRaw = 100,
	experienceFinal = 150,
	damageDealt = 200,
	damageReceived = 50,
	healingSelf = 25,
	healingOthers = 10,
	manaSpent = 20,
	monstersKilled = 2,
	deaths = 0,
	lootNpc = 0,
	lootMarket = 0,
	suppliesValue = 0,
}

assertEqual(Analytics.enqueue(session), true, "initial enqueue")
assertEqual(#Analytics.queue, 1, "initial queue size")

assertEqual(Analytics.flush(false), false, "first failed flush result")
assertEqual(session.retryCount, 1, "first retry count")
assertEqual(#Analytics.queue, 1, "first retry queued")
assertEqual(Analytics.health.retriedSessions, 1, "retry metric after first failure")
assertEqual(Analytics.health.failedFlushes, 1, "failed flush metric")

Analytics.flush(false)
assertEqual(session.retryCount, 1, "delayed retry must not run early")
assertEqual(Analytics.health.lastFlushProcessed, 0, "delayed retry processing count")

assertEqual(Analytics.flush(true), false, "second forced failure")
assertEqual(session.retryCount, 2, "second retry count")
assertEqual(#Analytics.queue, 1, "second retry queued")

assertEqual(Analytics.flush(true), false, "third forced failure")
assertEqual(session.retryCount, 3, "terminal retry count")
assertEqual(#Analytics.queue, 0, "normal queue after dead-lettering")
assertEqual(#Analytics.deadLetterQueue, 1, "dead-letter queue size")
assertEqual(Analytics.health.deadLetteredSessions, 1, "dead-letter metric")

simulatedSessionFailure = false
databaseWritesSucceed = true
assertEqual(Analytics.persistDeadLetters(), 1, "persist dead letter")
assertEqual(#Analytics.deadLetterQueue, 0, "dead-letter queue drained")
assertEqual(Analytics.health.persistedDeadLetters, 1, "persisted dead-letter metric")

Analytics.config.databaseEnabled = false
Analytics.queue = { session }
Analytics.deadLetterQueue = { { session = session, reason = "test", failedAt = os.time() } }
assertEqual(Analytics.flush(false), true, "database-disabled flush")
assertEqual(#Analytics.queue, 0, "database-disabled normal queue drain")
assertEqual(#Analytics.deadLetterQueue, 0, "database-disabled dead-letter drain")

print("gameplay analytics reliability runtime test passed")
