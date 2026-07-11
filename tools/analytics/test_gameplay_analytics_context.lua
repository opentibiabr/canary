local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local function assertNear(actual, expected, tolerance, message)
	if math.abs(actual - expected) > tolerance then
		error(string.format("%s: expected %.4f, got %.4f", message or "assertion failed", expected, actual), 2)
	end
end

local realTime = os.time
local clock = 1000
os.time = function()
	return clock
end

local function vocation(id)
	return {
		getId = function()
			return id
		end,
	}
end

local function player(guid, vocationId, position)
	local value = {
		guid = guid,
		vocation = vocation(vocationId),
		position = position,
		party = nil,
	}

	function value:isPlayer()
		return true
	end

	function value:getGuid()
		return self.guid
	end

	function value:getVocation()
		return self.vocation
	end

	function value:getPosition()
		return self.position
	end

	function value:getParty()
		return self.party
	end

	return value
end

local leader = player(1, 1, { x = 10, y = 10, z = 7 })
local memberTwo = player(2, 2, { x = 110, y = 10, z = 7 })
local memberThree = player(3, 3, { x = 110, y = 10, z = 7 })

local party = {
	members = { memberTwo, memberThree },
	shared = true,
}

function party:getLeader()
	return leader
end

function party:getMembers()
	return self.members
end

function party:isSharedExperienceActive()
	return self.shared
end

GameplayAnalytics = {
	config = {
		serverVersion = "context-test-build",
		contextSampleIntervalSeconds = 1,
		contextMaxGapSeconds = 10,
		huntAreaGridSize = 64,
		trackFallbackGridAreas = true,
		huntAreas = {
			{
				name = "area-alpha",
				from = { x = 0, y = 0, z = 7 },
				to = { x = 99, y = 99, z = 7 },
			},
			{
				name = "area-beta",
				from = { x = 100, y = 0, z = 7 },
				to = { x = 199, y = 99, z = 7 },
			},
		},
	},
	sessions = {},
	queue = {},
}

local function sessionFor(subject)
	return {
		uuid = string.format("00000000-0000-0000-0000-%012d", subject:getGuid()),
		playerId = subject:getGuid(),
		partySize = 1,
		sharedExperience = false,
	}
end

function GameplayAnalytics.get(subject)
	return GameplayAnalytics.sessions[subject:getGuid()]
end

function GameplayAnalytics.enqueue(session)
	GameplayAnalytics.queue[#GameplayAnalytics.queue + 1] = session
	return true
end

function GameplayAnalytics.finish(subject)
	local session = GameplayAnalytics.sessions[subject:getGuid()]
	GameplayAnalytics.sessions[subject:getGuid()] = nil
	if session then
		GameplayAnalytics.enqueue(session)
	end
end

function GameplayAnalytics.status()
	return {
		queuedSessions = #GameplayAnalytics.queue,
	}
end

GameplayAnalytics.sessions[leader:getGuid()] = sessionFor(leader)
local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_context.lua")

local active = Analytics.get(leader)
assertEqual(active.contextArea, "area-alpha", "initial named area")
assertEqual(active.contextPartySize, 1, "initial solo party size")
assertEqual(active.contextComposition, "1:1", "initial solo vocation composition")

Analytics.get(leader)
assertEqual(Analytics.contextStats.throttledSamples, 1, "same-second sample throttling")

clock = 1005
leader.position = { x = 110, y = 10, z = 7 }
leader.party = party
Analytics.get(leader)
assertEqual(active.contextArea, "area-beta", "updated named area")
assertEqual(active.contextPartySize, 3, "updated party size")
assertEqual(active.contextSharedExperience, true, "updated shared experience")
assertEqual(active.contextComposition, "1:1,2:1,3:1", "updated party composition")

clock = 1010
Analytics.finish(leader, "test")
assertEqual(#Analytics.queue, 1, "finalized session queued")
local finalized = Analytics.queue[1]
assertEqual(finalized.partySizeMin, 1, "minimum party size")
assertEqual(finalized.partySizeMax, 3, "maximum party size")
assertNear(finalized.partySizeAvg, 2.0, 0.0001, "time-weighted average party size")
assertEqual(finalized.sharedExperienceSeconds, 5, "shared experience seconds")
assertNear(finalized.sharedExperienceRatio, 0.5, 0.0001, "shared experience ratio")
assertEqual(finalized.partySize, 3, "legacy party size remains representative")
assertEqual(finalized.sharedExperience, true, "legacy shared experience remains representative")
assertEqual(finalized.huntArea, "area-beta", "dominant hunt area")
assertEqual(finalized.partyVocations, "1:1,2:1,3:1", "dominant party composition")
assertEqual(finalized.serverVersion, "context-test-build", "server version")
assertEqual(finalized.contextFinalized, true, "context finalized flag")
assertEqual(Analytics.contextStats.samples, 3, "accepted context samples")
assertEqual(Analytics.contextStats.namedAreaSamples, 3, "named-area samples")
assertEqual(Analytics.contextStats.finalizedSessions, 1, "finalized session metric")

local fallbackPlayer = player(4, 4, { x = 640, y = 704, z = 8 })
GameplayAnalytics.sessions[fallbackPlayer:getGuid()] = sessionFor(fallbackPlayer)
clock = 1020
local fallbackSession = Analytics.get(fallbackPlayer)
assertEqual(fallbackSession.contextArea, "grid:10:11:8", "fallback grid area")
Analytics.finish(fallbackPlayer, "test")
assertEqual(Analytics.queue[2].huntArea, "grid:10:11:8", "finalized fallback grid area")
assertEqual(Analytics.contextStats.fallbackAreaSamples, 2, "fallback samples include initialization and finish")

memberTwo.party = party
GameplayAnalytics.sessions[memberTwo:getGuid()] = sessionFor(memberTwo)
clock = 1030
local memberSession = Analytics.get(memberTwo)
assertEqual(memberSession.contextPartySize, 3, "member-perspective party size includes leader")
assertEqual(memberSession.contextComposition, "1:1,2:1,3:1", "member-perspective composition includes leader")
Analytics.finish(memberTwo, "test")
assertEqual(Analytics.queue[3].partySizeMax, 3, "member-perspective finalized party size")

local directSession = {
	uuid = "00000000-0000-0000-0000-000000000099",
	playerId = 99,
	partySize = 1,
	sharedExperience = false,
}
assertEqual(Analytics.enqueue(directSession), true, "direct enqueue")
assertEqual(directSession.contextFinalized, true, "direct enqueue finalizes context")
assertEqual(directSession.partySizeMin, 1, "direct enqueue party minimum")
assertEqual(directSession.partySizeMax, 1, "direct enqueue party maximum")
assertNear(directSession.partySizeAvg, 1.0, 0.0001, "direct enqueue party average")
assertEqual(directSession.sharedExperienceSeconds, 0, "direct enqueue shared seconds")
assertEqual(directSession.huntArea, nil, "direct enqueue has no invented hunt area")

local status = Analytics.status()
assertEqual(status.contextSamples, 7, "status context sample count")
assertEqual(status.contextFinalizedSessions, 4, "status finalized session count")

os.time = realTime
print("gameplay analytics hunt context runtime test passed")
