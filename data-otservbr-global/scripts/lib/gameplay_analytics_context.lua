local Analytics = GameplayAnalytics
if not Analytics then
	error("GameplayAnalytics must be loaded before gameplay_analytics_context.lua")
end

if Analytics.contextInstalled then
	return Analytics
end

Analytics.contextInstalled = true
Analytics.contextStats = Analytics.contextStats or {
	samples = 0,
	throttledSamples = 0,
	namedAreaSamples = 0,
	fallbackAreaSamples = 0,
	finalizedSessions = 0,
}

local originalGet = Analytics.get
local originalFinish = Analytics.finish
local originalEnqueue = Analytics.enqueue
local originalStatus = Analytics.status

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

local function trim(value)
	return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function boundedText(value, maximum)
	value = trim(value)
	if value == "" then
		return nil
	end
	if #value > maximum then
		return value:sub(1, maximum)
	end
	return value
end

local function positionInside(position, fromPosition, toPosition)
	if not position or type(fromPosition) ~= "table" or type(toPosition) ~= "table" then
		return false
	end
	local minimumX = math.min(tonumber(fromPosition.x) or 0, tonumber(toPosition.x) or 0)
	local maximumX = math.max(tonumber(fromPosition.x) or 0, tonumber(toPosition.x) or 0)
	local minimumY = math.min(tonumber(fromPosition.y) or 0, tonumber(toPosition.y) or 0)
	local maximumY = math.max(tonumber(fromPosition.y) or 0, tonumber(toPosition.y) or 0)
	local minimumZ = math.min(tonumber(fromPosition.z) or 0, tonumber(toPosition.z) or 0)
	local maximumZ = math.max(tonumber(fromPosition.z) or 0, tonumber(toPosition.z) or 0)
	return position.x >= minimumX and position.x <= maximumX and position.y >= minimumY and position.y <= maximumY and position.z >= minimumZ and position.z <= maximumZ
end

local function resolveArea(player)
	local position = player:getPosition()
	if not position then
		return nil, false
	end

	for _, area in ipairs(Analytics.config.huntAreas or {}) do
		local name = boundedText(area.name, 128)
		if name and positionInside(position, area.from, area.to) then
			return name, true
		end
	end

	if Analytics.config.trackFallbackGridAreas ~= true then
		return nil, false
	end

	local gridSize = clampInteger(Analytics.config.huntAreaGridSize, 16, 1024, 64)
	return string.format("grid:%d:%d:%d", math.floor(position.x / gridSize), math.floor(position.y / gridSize), position.z), false
end

local function vocationId(player)
	if not player or not player:isPlayer() then
		return nil
	end
	local vocation = player:getVocation()
	return vocation and vocation:getId() or 0
end

local function partySnapshot(player)
	local uniquePlayers = {}
	local players = {}
	local function addPlayer(member)
		if not member or not member:isPlayer() then
			return
		end
		local guid = member:getGuid()
		if uniquePlayers[guid] then
			return
		end
		uniquePlayers[guid] = true
		players[#players + 1] = member
	end

	addPlayer(player)
	local party = player:getParty()
	if party then
		local leaderOk, leader = pcall(function()
			return party:getLeader()
		end)
		if leaderOk then
			addPlayer(leader)
		end
		for _, member in ipairs(party:getMembers() or {}) do
			addPlayer(member)
		end
	end

	local vocationCounts = {}
	for _, member in ipairs(players) do
		local id = vocationId(member) or 0
		vocationCounts[id] = (vocationCounts[id] or 0) + 1
	end

	local vocationIds = {}
	for id in pairs(vocationCounts) do
		vocationIds[#vocationIds + 1] = id
	end
	table.sort(vocationIds)
	local composition = {}
	for _, id in ipairs(vocationIds) do
		composition[#composition + 1] = string.format("%d:%d", id, vocationCounts[id])
	end

	return #players, party and party:isSharedExperienceActive() or false, table.concat(composition, ",")
end

local function addScore(scores, key, value)
	if not key or key == "" or value <= 0 then
		return
	end
	scores[key] = (scores[key] or 0) + value
end

local function dominantScore(scores)
	local selected = nil
	local selectedScore = -1
	for key, value in pairs(scores or {}) do
		if value > selectedScore or (value == selectedScore and (not selected or key < selected)) then
			selected = key
			selectedScore = value
		end
	end
	return selected
end

local function initializeContext(session, player, timestamp)
	local partySize, sharedExperience, composition = partySnapshot(player)
	local area, named = resolveArea(player)
	session.contextLastAt = timestamp
	session.contextPartySize = partySize
	session.contextSharedExperience = sharedExperience
	session.contextComposition = composition
	session.contextArea = area
	session.contextSeconds = 0
	session.contextPartySizeWeighted = 0
	session.contextSharedSeconds = 0
	session.contextAreaScores = {}
	session.contextCompositionScores = {}
	session.partySizeMin = partySize
	session.partySizeMax = partySize
	addScore(session.contextAreaScores, area, 1)
	addScore(session.contextCompositionScores, composition, 1)
	if named then
		Analytics.contextStats.namedAreaSamples = Analytics.contextStats.namedAreaSamples + 1
	elseif area then
		Analytics.contextStats.fallbackAreaSamples = Analytics.contextStats.fallbackAreaSamples + 1
	end
end

function Analytics.sampleContext(player, session, force)
	if not player or not session or session.contextFinalized then
		return session
	end

	local timestamp = now()
	local sampleInterval = clampInteger(Analytics.config.contextSampleIntervalSeconds, 1, 60, 1)
	if session.contextLastAt and not force and timestamp - session.contextLastAt < sampleInterval then
		Analytics.contextStats.throttledSamples = Analytics.contextStats.throttledSamples + 1
		return session
	end

	Analytics.contextStats.samples = Analytics.contextStats.samples + 1
	if not session.contextLastAt then
		initializeContext(session, player, timestamp)
		return session
	end

	local delta = math.max(0, timestamp - session.contextLastAt)
	delta = math.min(delta, clampInteger(Analytics.config.contextMaxGapSeconds, 1, 120, 10))
	if delta > 0 then
		session.contextSeconds = session.contextSeconds + delta
		session.contextPartySizeWeighted = session.contextPartySizeWeighted + session.contextPartySize * delta
		if session.contextSharedExperience then
			session.contextSharedSeconds = session.contextSharedSeconds + delta
		end
		addScore(session.contextAreaScores, session.contextArea, delta)
		addScore(session.contextCompositionScores, session.contextComposition, delta)
	end

	local partySize, sharedExperience, composition = partySnapshot(player)
	local area, named = resolveArea(player)
	session.partySizeMin = math.min(session.partySizeMin or partySize, partySize)
	session.partySizeMax = math.max(session.partySizeMax or partySize, partySize)
	session.contextPartySize = partySize
	session.contextSharedExperience = sharedExperience
	session.contextComposition = composition
	session.contextArea = area
	session.contextLastAt = timestamp
	addScore(session.contextAreaScores, area, 1)
	addScore(session.contextCompositionScores, composition, 1)
	if named then
		Analytics.contextStats.namedAreaSamples = Analytics.contextStats.namedAreaSamples + 1
	elseif area then
		Analytics.contextStats.fallbackAreaSamples = Analytics.contextStats.fallbackAreaSamples + 1
	end
	return session
end

function Analytics.finalizeContext(session)
	if not session or session.contextFinalized then
		return session
	end

	local contextSeconds = tonumber(session.contextSeconds) or 0
	local currentPartySize = tonumber(session.contextPartySize) or tonumber(session.partySize) or 1
	session.partySizeMin = tonumber(session.partySizeMin) or currentPartySize
	session.partySizeMax = tonumber(session.partySizeMax) or currentPartySize
	if contextSeconds > 0 then
		session.partySizeAvg = session.contextPartySizeWeighted / contextSeconds
		session.sharedExperienceSeconds = math.min(contextSeconds, tonumber(session.contextSharedSeconds) or 0)
		session.sharedExperienceRatio = session.sharedExperienceSeconds / contextSeconds
	else
		session.partySizeAvg = currentPartySize
		session.sharedExperienceSeconds = 0
		session.sharedExperienceRatio = session.contextSharedExperience and 1 or 0
	end

	session.partySize = session.partySizeMax
	session.sharedExperience = session.sharedExperienceSeconds > 0 or session.contextSharedExperience == true
	session.huntArea = dominantScore(session.contextAreaScores)
	session.partyVocations = boundedText(dominantScore(session.contextCompositionScores), 128)
	session.serverVersion = boundedText(Analytics.config.serverVersion, 64)
	session.contextFinalized = true
	Analytics.contextStats.finalizedSessions = Analytics.contextStats.finalizedSessions + 1
	return session
end

function Analytics.get(player)
	local session = originalGet(player)
	if session then
		Analytics.sampleContext(player, session, false)
	end
	return session
end

function Analytics.finish(player, reason)
	if player then
		local session = Analytics.sessions[player:getGuid()]
		if session then
			Analytics.sampleContext(player, session, true)
		end
	end
	return originalFinish(player, reason)
end

function Analytics.enqueue(session)
	Analytics.finalizeContext(session)
	return originalEnqueue(session)
end

function Analytics.status()
	local status = originalStatus()
	for key, value in pairs(Analytics.contextStats) do
		status["context" .. key:sub(1, 1):upper() .. key:sub(2)] = value
	end
	return status
end

return Analytics
