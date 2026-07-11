local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local function assertContains(value, expected, message)
	if not value:find(expected, 1, true) then
		error(string.format("%s: '%s' not found", message or "assertion failed", expected), 2)
	end
end

local function runScenario(batchSize, failingQueryFragment)
	local queries = {}

	logger = {
		error = function() end,
	}

	db = {
		escapeString = function(value)
			return string.format("'%s'", tostring(value):gsub("'", "''"))
		end,
		query = function(query)
			queries[#queries + 1] = query
			if failingQueryFragment and query:find(failingQueryFragment, 1, true) then
				return false
			end
			return true
		end,
		storeQuery = function()
			return {}
		end,
	}

	result = {
		getNumber = function()
			return 77
		end,
		free = function() end,
	}

	GameplayAnalytics = {
		VERSION = 1,
		config = {
			databaseEnabled = true,
			detailBatchSize = batchSize,
			detailLevel = 1,
			trackMonsters = true,
			trackSpells = true,
			trackDamageTypes = true,
			trackSupplies = true,
			trackLoot = true,
		},
		queue = {},
		lastFlush = 0,
	}

	function GameplayAnalytics.enqueue(session)
		GameplayAnalytics.queue[#GameplayAnalytics.queue + 1] = session
		return true
	end

	function GameplayAnalytics.status()
		return {
			queuedSessions = #GameplayAnalytics.queue,
		}
	end

	local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")
	Analytics.queue = {
		{
			uuid = "00000000-0000-0000-0000-000000000010",
			playerId = 1,
			playerName = "Batch Tester",
			vocationId = 1,
			levelStart = 100,
			levelEnd = 101,
			startedAt = 1000,
			endedAt = 1060,
			combatSeconds = 50,
			experienceRaw = 1000,
			experienceFinal = 1500,
			damageDealt = 2000,
			damageReceived = 500,
			healingSelf = 300,
			healingOthers = 100,
			overhealing = 20,
			manaSpent = 250,
			monstersKilled = 10,
			deaths = 0,
			lootNpc = 10000,
			lootMarket = 12000,
			suppliesValue = 2000,
			partySize = 3,
			partySizeMin = 1,
			partySizeMax = 3,
			partySizeAvg = 2.0,
			sharedExperience = true,
			sharedExperienceSeconds = 5,
			sharedExperienceRatio = 0.5,
			partyVocations = "1:1,2:1,3:1",
			serverVersion = "context-test-build",
			huntArea = "area-beta",
			monsters = {
				["alpha monster"] = { kills = 2, damageDealt = 100, damageReceived = 20, experienceRaw = 50 },
				["beta monster"] = { kills = 3, damageDealt = 200, damageReceived = 30, experienceRaw = 75 },
			},
			spells = {
				["alpha spell"] = { casts = 4, targets = 5, damage = 600, healing = 0, mana = 100, critical = 1 },
				["beta spell"] = { casts = 6, targets = 7, damage = 800, healing = 10, mana = 150, critical = 2 },
			},
			damageTypes = {
				[1] = { dealt = 900, received = 100 },
				[2] = { dealt = 1200, received = 150 },
			},
			supplies = {
				[268] = { amount = 10, unitValue = 50, totalValue = 500 },
				[269] = { amount = 12, unitValue = 50, totalValue = 600 },
			},
			loot = {
				[3031] = { amount = 20, npcValue = 2000, marketValue = 2200 },
				[3032] = { amount = 25, npcValue = 2500, marketValue = 2750 },
			},
		},
	}

	Analytics.flush()
	return Analytics, queries
end

local batched, batchedQueries = runScenario(250)
assertEqual(#batchedQueries, 6, "one session plus five detail batches")
assertEqual(batched.batchStats.detailBatchQueries, 5, "batched detail query count")
assertEqual(batched.batchStats.detailRowsPersisted, 10, "batched detail row count")
assertEqual(batched.batchStats.largestDetailBatch, 2, "largest typical batch")
assertEqual(#batched.queue, 0, "successful batched queue drain")
assertContains(batchedQueries[1], "`party_size_min`", "session query context columns")
assertContains(batchedQueries[1], "`shared_experience_ratio`", "session query shared ratio")
assertContains(batchedQueries[1], "`hunt_area`", "session query hunt area column")
assertContains(batchedQueries[1], "'1:1,2:1,3:1'", "session query party composition")
assertContains(batchedQueries[1], "'context-test-build'", "session query server version")
assertContains(batchedQueries[1], "'area-beta'", "session query hunt area value")
for index = 2, #batchedQueries do
	if not batchedQueries[index]:find("),(", 1, true) then
		error("detail query did not contain multiple value rows: " .. batchedQueries[index])
	end
end

local chunked, chunkedQueries = runScenario(1)
assertEqual(#chunkedQueries, 11, "one session plus ten bounded detail chunks")
assertEqual(chunked.batchStats.detailBatchQueries, 10, "chunked detail query count")
assertEqual(chunked.batchStats.detailRowsPersisted, 10, "chunked detail row count")
assertEqual(chunked.batchStats.largestDetailBatch, 1, "bounded chunk size")

local failed, failedQueries = runScenario(250, "analytics_session_spells")
assertEqual(#failedQueries, 6, "failed batch still evaluates all detail categories")
assertEqual(#failed.queue, 1, "failed batch requeues complete session")
assertEqual(failed.batchStats.detailRowsPersisted, 8, "only successful detail rows counted")

print("gameplay analytics detail batching runtime test passed")
