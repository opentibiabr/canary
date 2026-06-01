require(DATA_DIRECTORY .. ".lib.core.quests")

if not LastQuestlogUpdate then
	LastQuestlogUpdate = {}
end

if not PlayerTrackedMissionsData then
	PlayerTrackedMissionsData = {}
end

if not PlayerTrackedMissionRemovalEvents then
	PlayerTrackedMissionRemovalEvents = {}
end

if not PlayerQuestTrackerInitialSync then
	PlayerQuestTrackerInitialSync = {}
end

-- Text functions

local function evaluateText(value, player)
	if type(value) == "function" then
		return tostring(value(player))
	end

	return tostring(value)
end

-- Quest tracker server-side automation / persistence
QuestTrackerServerConfig = QuestTrackerServerConfig or {
	kvScope = "quest-tracker",
	trackedMissionsKey = "tracked-missions",
	knownQuestsKey = "known-quests",
	autoTrackNewQuestsKey = "auto-track-new-quests",
	autoUntrackCompletedQuestsKey = "auto-untrack-completed-quests",
	completedMissionRemovalDelay = 5 * 1000,
	loginLoadDelay = 500,
	initialSyncWindow = 3000,
}

local function getQuestTrackerKV(player)
	return player:kv():scoped(QuestTrackerServerConfig.kvScope)
end

local function makeTrackedMissionKey(questId, missionId)
	return string.format("%s:%s", tostring(questId), tostring(missionId))
end

local function copyTrackedMissionData(mission)
	if not mission then
		return nil
	end

	return {
		questId = tonumber(mission.questId),
		missionId = tonumber(mission.missionId),
		questName = tostring(mission.questName or ""),
		missionName = tostring(mission.missionName or ""),
		missionDesc = tostring(mission.missionDesc or ""),
	}
end

local function normalizeBoolean(value)
	return value == true or value == 1 or value == "1" or value == "true"
end

local function getTrackedMissions(player)
	local playerId = player:getId()
	if not PlayerTrackedMissionsData[playerId] then
		PlayerTrackedMissionsData[playerId] = {}
	end
	return PlayerTrackedMissionsData[playerId]
end

local function sendTrackedMissionsUpdate(player)
	local trackedMissions = getTrackedMissions(player)
	player:sendTrackedQuests(player:getAllowedTrackedQuestCount() - #trackedMissions, trackedMissions)
	player:saveTrackedMissions()
end

local questHasMissionId
local buildMissionTrackerData

local function getMissionIndexByTrackedMissionId(questId, trackedMissionId)
	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return nil
	end

	for missionIndex = 1, #quest.missions do
		local mission = quest.missions[missionIndex]
		if mission and mission.missionId == trackedMissionId then
			return missionIndex
		end
	end

	return nil
end

local function trackedMissionIsCompleted(player, questId, trackedMissionId)
	local missionIndex = getMissionIndexByTrackedMissionId(questId, trackedMissionId)
	if not missionIndex then
		return false
	end

	return player:missionIsCompleted(questId, missionIndex)
end

local function removeCompletedTrackedMission(playerId, questId, missionId, sendUpdate)
	local pendingRemovals = PlayerTrackedMissionRemovalEvents[playerId]
	if pendingRemovals then
		pendingRemovals[makeTrackedMissionKey(questId, missionId)] = nil
		if not next(pendingRemovals) then
			PlayerTrackedMissionRemovalEvents[playerId] = nil
		end
	end

	local player = Player(playerId)
	if not player or not player:getQuestTrackerOption("autoUntrackCompletedQuests") or not trackedMissionIsCompleted(player, questId, missionId) then
		return false
	end

	local trackedMissions = PlayerTrackedMissionsData[playerId]
	if not trackedMissions or #trackedMissions == 0 then
		return false
	end

	local refreshedMissions = {}
	local removed = false
	for i = 1, #trackedMissions do
		local mission = trackedMissions[i]
		if mission and mission.questId == questId and mission.missionId == missionId then
			removed = true
		else
			refreshedMissions[#refreshedMissions + 1] = mission
		end
	end

	if not removed then
		return false
	end

	PlayerTrackedMissionsData[playerId] = refreshedMissions
	if sendUpdate ~= false then
		player:sendTrackedQuests(player:getAllowedTrackedQuestCount() - #refreshedMissions, refreshedMissions)
	end
	player:saveTrackedMissions()
	return true
end

function Player.flushTrackedMissionRemovalEvents(self, sendUpdate)
	local playerId = self:getId()
	local pendingRemovals = PlayerTrackedMissionRemovalEvents[playerId]
	if not pendingRemovals then
		return false
	end

	local removals = {}
	for key, eventId in pairs(pendingRemovals) do
		removals[#removals + 1] = { key = key, eventId = eventId }
	end

	local removed = false
	for i = 1, #removals do
		local removal = removals[i]
		if removal.eventId then
			stopEvent(removal.eventId)
		end

		local questId, missionId = tostring(removal.key):match("^([^:]+):([^:]+)$")
		questId = tonumber(questId)
		missionId = tonumber(missionId)
		if questId and missionId and removeCompletedTrackedMission(playerId, questId, missionId, sendUpdate) then
			removed = true
		end
	end

	PlayerTrackedMissionRemovalEvents[playerId] = nil
	return removed
end

-- Game functions

function Player.hasTrackingQuest(self, questId, missionId)
	-- Backward compatibility: allows calls as hasTrackingQuest(missionId).
	-- New/correct identification should use the pair questId + missionId.
	if missionId == nil then
		missionId = questId
		questId = nil
	end

	local trackedQuests = PlayerTrackedMissionsData[self:getId()]
	if trackedQuests then
		for i = 1, #trackedQuests do
			local mission = trackedQuests[i]
			if mission and mission.missionId == missionId and (questId == nil or mission.questId == questId) then
				return true
			end
		end
	end
	return false
end

function Player.getQuestDataByMissionId(self, missionId)
	for questId, quest in pairs(Quests) do
		local quest = Game.getQuest(questId)
		if quest then
			if quest.missions then
				for i = 1, #quest.missions do
					local mission = quest.missions[i]
					if mission and mission.missionId == missionId then
						return quest.name, questId, i
					end
				end
			end
		end
	end
	return false
end

local function buildTrackedMissionDataFromMissionId(player, missionId)
	local questName, questId, missionIndex = player:getQuestDataByMissionId(missionId)
	if questName and questId and missionIndex and player:missionIsStarted(questId, missionIndex) then
		return {
			questId = questId,
			missionId = missionId,
			questName = questName,
			missionName = player:getMissionName(questId, missionIndex),
			missionDesc = player:getMissionDescription(questId, missionIndex),
		}
	end
	return nil
end

function Player.resetTrackedMissions(self, missions)
	local maxAllowed = self:getAllowedTrackedQuestCount()
	PlayerTrackedMissionsData[self:getId()] = {}
	for i = 1, #missions do
		local data = buildTrackedMissionDataFromMissionId(self, missions[i])
		if data then
			table.insert(PlayerTrackedMissionsData[self:getId()], data)
			if #PlayerTrackedMissionsData[self:getId()] >= maxAllowed then
				break
			end
		end
	end

	self:sendTrackedQuests(maxAllowed - #PlayerTrackedMissionsData[self:getId()], PlayerTrackedMissionsData[self:getId()])
	self:saveTrackedMissions()
end

function Player.getQuestTrackerOption(self, option)
	if option ~= "autoTrackNewQuests" and option ~= "autoUntrackCompletedQuests" then
		return false
	end

	local kvKey = option == "autoTrackNewQuests" and QuestTrackerServerConfig.autoTrackNewQuestsKey or QuestTrackerServerConfig.autoUntrackCompletedQuestsKey
	return normalizeBoolean(getQuestTrackerKV(self):get(kvKey))
end

function Player.setQuestTrackerOption(self, option, enabled, _silent)
	if option ~= "autoTrackNewQuests" and option ~= "autoUntrackCompletedQuests" then
		return false
	end

	local oldEnabled = self:getQuestTrackerOption(option)
	local newEnabled = normalizeBoolean(enabled)
	local kvKey = option == "autoTrackNewQuests" and QuestTrackerServerConfig.autoTrackNewQuestsKey or QuestTrackerServerConfig.autoUntrackCompletedQuestsKey
	getQuestTrackerKV(self):set(kvKey, newEnabled)

	-- Quando ligar auto-track, marca as quests atuais como conhecidas.
	-- Isso evita adicionar no tracker todas as quests antigas do player.
	-- Faz somente quando muda de desligado para ligado.
	if option == "autoTrackNewQuests" and newEnabled and not oldEnabled then
		self:updateQuestTrackerKnownQuests(false)
	end

	-- Não remova completed missions só porque ligou o toggle.
	-- O client oficial permite rastrear manualmente quests/missions completas.
	-- O auto-untrack deve agir somente na missão/quest afetada por progresso de storage.

	return true
end

function Player.beginQuestTrackerInitialSync(self)
	PlayerQuestTrackerInitialSync[self:getId()] = true
end

function Player.finishQuestTrackerInitialSync(self)
	PlayerQuestTrackerInitialSync[self:getId()] = nil
end

function Player.isQuestTrackerInitialSync(self)
	return PlayerQuestTrackerInitialSync[self:getId()] == true
end

function Player.reconcileInitialTrackedMissions(self, missions)
	if self.loadTrackedMissions then
		self:loadTrackedMissions(false)
	end

	local playerId = self:getId()
	local trackedMissions = PlayerTrackedMissionsData[playerId]
	if not trackedMissions then
		trackedMissions = {}
		PlayerTrackedMissionsData[playerId] = trackedMissions
	end

	local maxAllowed = self:getAllowedTrackedQuestCount()
	local added = {}
	for i = 1, #trackedMissions do
		local mission = trackedMissions[i]
		if mission and mission.questId and mission.missionId then
			added[makeTrackedMissionKey(mission.questId, mission.missionId)] = true
		end
	end

	local changed = false
	for i = 1, #missions do
		if #trackedMissions >= maxAllowed then
			break
		end

		local data = buildTrackedMissionDataFromMissionId(self, missions[i])
		if data then
			local key = makeTrackedMissionKey(data.questId, data.missionId)
			if not added[key] then
				trackedMissions[#trackedMissions + 1] = data
				added[key] = true
				changed = true
			end
		end
	end

	self:sendTrackedQuests(maxAllowed - #trackedMissions, trackedMissions)

	if changed then
		self:saveTrackedMissions()
	end
	return true
end

function Player.saveTrackedMissions(self)
	local trackedMissions = PlayerTrackedMissionsData[self:getId()]
	local payload = {}
	local added = {}

	if trackedMissions then
		for i = 1, #trackedMissions do
			local mission = copyTrackedMissionData(trackedMissions[i])
			if mission and mission.questId and mission.missionId then
				local key = makeTrackedMissionKey(mission.questId, mission.missionId)
				if not added[key] then
					payload[#payload + 1] = mission
					added[key] = true
				end
			end
		end
	end

	getQuestTrackerKV(self):set(QuestTrackerServerConfig.trackedMissionsKey, payload)
	return true
end

function Player.loadTrackedMissions(self, sendUpdate)
	local storedMissions = getQuestTrackerKV(self):get(QuestTrackerServerConfig.trackedMissionsKey)
	if type(storedMissions) ~= "table" then
		storedMissions = {}
	end

	local maxAllowed = self:getAllowedTrackedQuestCount()
	local restoredMissions = {}
	local added = {}

	for i = 1, #storedMissions do
		local storedMission = storedMissions[i]
		if type(storedMission) == "table" then
			local questId = tonumber(storedMission.questId)
			local missionId = tonumber(storedMission.missionId)
			if questId and missionId then
				local currentMission = self:getTrackedMissionDataByIds(questId, missionId)
				if not currentMission and questHasMissionId(questId, missionId) then
					currentMission = copyTrackedMissionData(storedMission)
				end

				if currentMission then
					local key = makeTrackedMissionKey(currentMission.questId, currentMission.missionId)
					if not added[key] then
						restoredMissions[#restoredMissions + 1] = currentMission
						added[key] = true
						if #restoredMissions >= maxAllowed then
							break
						end
					end
				end
			end
		end
	end

	PlayerTrackedMissionsData[self:getId()] = restoredMissions
	local shouldSendUpdate = sendUpdate ~= false
	if shouldSendUpdate and #restoredMissions == 0 and self.isQuestTrackerInitialSync and self:isQuestTrackerInitialSync() then
		shouldSendUpdate = false
	end
	if shouldSendUpdate then
		self:sendTrackedQuests(maxAllowed - #restoredMissions, restoredMissions)
	end
	self:saveTrackedMissions()
	return true
end

local getActiveMissionEntriesForQuest

local function readKnownMissionEntries(player)
	local list = getQuestTrackerKV(player):get(QuestTrackerServerConfig.knownQuestsKey)
	local known = {}

	if type(list) == "table" then
		for i = 1, #list do
			local entry = list[i]
			if type(entry) == "table" then
				local questId = tonumber(entry.questId)
				local missionId = tonumber(entry.missionId)
				if questId and missionId then
					known[makeTrackedMissionKey(questId, missionId)] = true
				end
			else
				local key = tostring(entry)
				if key:match("^%d+:%d+$") then
					known[key] = true
				else
					-- Backward compatibility with the first implementation, which stored only questId.
					-- Convert an old quest-level entry into all currently open mission entries.
					local questId = tonumber(entry)
					if questId and getActiveMissionEntriesForQuest then
						local activeMissions = getActiveMissionEntriesForQuest(player, questId)
						for j = 1, #activeMissions do
							local mission = activeMissions[j]
							known[makeTrackedMissionKey(mission.questId, mission.missionId)] = true
						end
					end
				end
			end
		end
	end

	return known
end

local function saveKnownMissionEntries(player, known)
	local list = {}
	for key in pairs(known) do
		if tostring(key):match("^%d+:%d+$") then
			list[#list + 1] = tostring(key)
		end
	end
	table.sort(list)

	getQuestTrackerKV(player):set(QuestTrackerServerConfig.knownQuestsKey, list)
	return true
end

getActiveMissionEntriesForQuest = function(player, questId)
	local missions = {}
	if not questId or player:questIsCompleted(questId) then
		return missions
	end

	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return missions
	end

	local added = {}
	for missionIndex = 1, #quest.missions do
		if player:missionIsStarted(questId, missionIndex) and not player:missionIsCompleted(questId, missionIndex) then
			local mission = buildMissionTrackerData(player, questId, missionIndex)
			if mission and mission.questId and mission.missionId then
				local key = makeTrackedMissionKey(mission.questId, mission.missionId)
				if not added[key] then
					missions[#missions + 1] = mission
					added[key] = true
				end
			end
		end
	end

	return missions
end

function Player.updateQuestTrackerKnownQuests(self, _autoTrackNew)
	local known = readKnownMissionEntries(self)
	local changedKnown = false

	for questId in pairs(Quests) do
		local activeMissions = getActiveMissionEntriesForQuest(self, questId)
		for i = 1, #activeMissions do
			local mission = activeMissions[i]
			local key = makeTrackedMissionKey(mission.questId, mission.missionId)
			if not known[key] then
				known[key] = true
				changedKnown = true
			end
		end
	end

	if changedKnown then
		saveKnownMissionEntries(self, known)
	end

	return changedKnown
end

function Player.addTrackedMissionData(self, data, sendUpdate)
	data = copyTrackedMissionData(data)
	if not data or not data.questId or not data.missionId then
		return false
	end

	local trackedMissions = getTrackedMissions(self)
	local maxAllowed = self:getAllowedTrackedQuestCount()
	if #trackedMissions >= maxAllowed then
		return false
	end

	if self:hasTrackingQuest(data.questId, data.missionId) then
		return false
	end

	trackedMissions[#trackedMissions + 1] = data

	if sendUpdate ~= false then
		self:sendTrackedQuests(maxAllowed - #trackedMissions, trackedMissions)
		self:saveTrackedMissions()
	end
	return true
end

function Player.addCurrentQuestMissionToTracker(self, questId, sendUpdate)
	if not questId or self:questIsCompleted(questId) then
		return false
	end

	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return false
	end

	for missionIndex = 1, #quest.missions do
		if self:missionIsStarted(questId, missionIndex) and not self:missionIsCompleted(questId, missionIndex) then
			return self:addTrackedMissionData(buildMissionTrackerData(self, questId, missionIndex), sendUpdate)
		end
	end

	return false
end

local function questUsesStorageKey(quest, key)
	key = tonumber(key)
	if not quest or not key then
		return false
	end

	if tonumber(quest.startStorageId) == key or tonumber(quest.endStorageId) == key then
		return true
	end

	if quest.missions then
		for missionIndex = 1, #quest.missions do
			local mission = quest.missions[missionIndex]
			if mission and tonumber(mission.storageId) == key then
				return true
			end
		end
	end

	return false
end

local function retryAutoTrackCurrentQuestMissions(playerId, questId)
	local player = Player(playerId)
	if not player or not player:getQuestTrackerOption("autoTrackNewQuests") then
		return false
	end

	local activeMissions = getActiveMissionEntriesForQuest(player, questId)
	if #activeMissions == 0 then
		return false
	end

	local known = readKnownMissionEntries(player)
	local changedKnown = false
	local changedTracker = false

	for i = 1, #activeMissions do
		local mission = activeMissions[i]
		local missionKey = makeTrackedMissionKey(mission.questId, mission.missionId)

		if not known[missionKey] then
			if player:hasTrackingQuest(mission.questId, mission.missionId) then
				known[missionKey] = true
				changedKnown = true
			elseif player:addTrackedMissionData(mission, false) then
				known[missionKey] = true
				changedKnown = true
				changedTracker = true
			end
		end
	end

	if changedKnown then
		saveKnownMissionEntries(player, known)
	end

	if changedTracker then
		sendTrackedMissionsUpdate(player)
	end

	return changedKnown or changedTracker
end

function Player.autoTrackStartedQuestByStorage(self, key, value, oldValue)
	if key == nil or value == nil or oldValue == nil then
		return false
	end

	local known = readKnownMissionEntries(self)
	local changedKnown = false
	local changedTracker = false
	local playerId = self:getId()

	for questId in pairs(Quests) do
		local quest = Game.getQuest(questId)
		if quest and questUsesStorageKey(quest, key) and self:questIsStarted(questId) and not self:questIsCompleted(questId) then
			local activeMissions = getActiveMissionEntriesForQuest(self, questId)
			if #activeMissions == 0 then
				addEvent(retryAutoTrackCurrentQuestMissions, 100, playerId, questId)
			else
				for i = 1, #activeMissions do
					local mission = activeMissions[i]
					local missionKey = makeTrackedMissionKey(mission.questId, mission.missionId)

					if not known[missionKey] then
						if self:hasTrackingQuest(mission.questId, mission.missionId) then
							known[missionKey] = true
							changedKnown = true
						elseif self:addTrackedMissionData(mission, false) then
							known[missionKey] = true
							changedKnown = true
							changedTracker = true
						else
							addEvent(retryAutoTrackCurrentQuestMissions, 100, playerId, questId)
						end
					end
				end
			end
		end
	end

	if changedKnown then
		saveKnownMissionEntries(self, known)
	end

	if changedTracker then
		sendTrackedMissionsUpdate(self)
	end

	return changedKnown or changedTracker
end

function Player.removeCompletedTrackedMissions(self, sendUpdate)
	local playerId = self:getId()
	local trackedMissions = PlayerTrackedMissionsData[playerId]
	if not trackedMissions or #trackedMissions == 0 then
		return false
	end

	local delay = QuestTrackerServerConfig.completedMissionRemovalDelay or 5000
	local pendingRemovals = PlayerTrackedMissionRemovalEvents[playerId]
	if not pendingRemovals then
		pendingRemovals = {}
		PlayerTrackedMissionRemovalEvents[playerId] = pendingRemovals
	end

	local scheduled = false
	for i = 1, #trackedMissions do
		local mission = trackedMissions[i]
		if mission and mission.questId and mission.missionId and trackedMissionIsCompleted(self, mission.questId, mission.missionId) then
			local key = makeTrackedMissionKey(mission.questId, mission.missionId)
			if not pendingRemovals[key] then
				pendingRemovals[key] = addEvent(removeCompletedTrackedMission, delay, playerId, mission.questId, mission.missionId, sendUpdate ~= false)
				scheduled = true
			end
		end
	end

	if not scheduled and not next(pendingRemovals) then
		PlayerTrackedMissionRemovalEvents[playerId] = nil
	end

	return scheduled
end

function Player.processAutomaticQuestTracker(self, key, value, oldValue)
	local changed = false

	if self:getQuestTrackerOption("autoUntrackCompletedQuests") then
		if self:removeCompletedTrackedMissions(true) then
			changed = true
		end
	end

	if self:getQuestTrackerOption("autoTrackNewQuests") then
		if self:autoTrackStartedQuestByStorage(key, value, oldValue) then
			changed = true
		end
	end

	return changed
end

function Player.getAllowedTrackedQuestCount(self)
	return self:isPremium() and 20 or 5
end

function Game.isValidQuest(questId)
	return (Quests and Quests[questId])
end

function Game.isValidMission(questId, missionId)
	return (Game.isValidQuest(questId) and Quests[questId].missions and Quests[questId].missions[missionId])
end

function Game.getQuest(questId)
	if Game.isValidQuest(questId) then
		return Quests[questId]
	end
	return false
end

function Game.getQuestIdByName(name)
	for questId, quest in pairs(Quests) do
		local quest = Game.getQuest(questId)
		if quest and quest.name:lower() == name:lower() then
			return questId
		end
	end
	return false
end

function Game.getMission(questId, missionId)
	if Game.isValidMission(questId, missionId) then
		return Quests[questId].missions[missionId]
	end
	return false
end

function Player.getMissionsData(self, storage)
	local missions = {}
	for questId, quest in pairs(Quests) do
		local quest = Game.getQuest(questId)
		if quest and quest.missions then
			for missionId = 1, #quest.missions do
				local started = self:missionIsStarted(questId, missionId)
				if started then
					local mission = quest.missions[missionId]
					if mission.storageId == storage then
						local data = {
							questId = questId,
							missionId = mission.missionId,
							missionName = self:getMissionName(questId, missionId),
							missionDesc = self:getMissionDescription(questId, missionId),
						}
						missions[#missions + 1] = data
					end
				end
			end
		end
	end
	return missions
end

buildMissionTrackerData = function(player, questId, missionIndex)
	local quest = Game.getQuest(questId)
	local mission = Game.getMission(questId, missionIndex)
	if not quest or not mission then
		return nil
	end

	return {
		questId = questId,
		missionId = mission.missionId,
		questName = quest.name,
		missionName = player:getMissionName(questId, missionIndex),
		missionDesc = player:getMissionDescription(questId, missionIndex),
	}
end

function Player.getCurrentTrackedMissionData(self, questId)
	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return nil
	end

	local lastCompletedMission = nil
	for missionIndex = 1, #quest.missions do
		if self:missionIsStarted(questId, missionIndex) then
			local data = buildMissionTrackerData(self, questId, missionIndex)
			if not self:missionIsCompleted(questId, missionIndex) then
				return data
			end
			lastCompletedMission = data
		end
	end

	return lastCompletedMission
end

function Player.getTrackedMissionDataByIds(self, questId, trackedMissionId)
	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return nil
	end

	local trackedMissionIndex = getMissionIndexByTrackedMissionId(questId, trackedMissionId)
	if not trackedMissionIndex then
		return nil
	end

	-- Keep the tracked entry tied to its own questId:missionId.
	-- The mission text can still refresh through catalog/storage changes, including
	-- the final completed state before auto-untrack removes it after the delay.
	if self:missionIsStarted(questId, trackedMissionIndex) or self:missionIsCompleted(questId, trackedMissionIndex) then
		return buildMissionTrackerData(self, questId, trackedMissionIndex)
	end

	-- GM/admin regression support: if storage was moved backwards,
	-- the previously tracked mission may no longer be started. In that
	-- case, search backwards and update the tracker to the nearest valid
	-- previous mission instead of removing it or keeping stale text.
	local previousMission = nil
	for missionIndex = 1, trackedMissionIndex - 1 do
		if self:missionIsStarted(questId, missionIndex) then
			previousMission = buildMissionTrackerData(self, questId, missionIndex)
		end
	end

	return previousMission
end

questHasMissionId = function(questId, trackedMissionId)
	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return false
	end

	for missionIndex = 1, #quest.missions do
		local mission = quest.missions[missionIndex]
		if mission and mission.missionId == trackedMissionId then
			return true
		end
	end

	return false
end

function Player.refreshTrackedMissions(self)
	local playerId = self:getId()
	local trackedMissions = PlayerTrackedMissionsData[playerId]
	if not trackedMissions or #trackedMissions == 0 then
		return
	end

	local maxAllowed = self:getAllowedTrackedQuestCount()
	local refreshedMissions = {}
	local addedMissions = {}

	for i = 1, #trackedMissions do
		local trackedMission = trackedMissions[i]
		if trackedMission and trackedMission.questId then
			local currentMission = nil
			if trackedMission.missionId then
				currentMission = self:getTrackedMissionDataByIds(trackedMission.questId, trackedMission.missionId)

				-- If the storage was regressed before any mission in this quest is
				-- considered started, keep the tracked mission instead of removing it.
				-- This is only a last fallback; when a previous mission is valid,
				-- getTrackedMissionDataByIds already returns fresh data for it.
				if not currentMission and questHasMissionId(trackedMission.questId, trackedMission.missionId) then
					currentMission = trackedMission
				end
			else
				currentMission = self:getCurrentTrackedMissionData(trackedMission.questId)
			end

			if currentMission then
				local key = string.format("%s:%s", currentMission.questId, currentMission.missionId)
				if not addedMissions[key] then
					refreshedMissions[#refreshedMissions + 1] = currentMission
					addedMissions[key] = true
					if #refreshedMissions >= maxAllowed then
						break
					end
				end
			end
		end
	end

	PlayerTrackedMissionsData[playerId] = refreshedMissions
	self:sendTrackedQuests(maxAllowed - #refreshedMissions, refreshedMissions)
	self:saveTrackedMissions()
end

function Game.isQuestStorage(key, value, oldValue)
	for questId, quest in pairs(Quests) do
		local quest = Game.getQuest(questId)
		if quest then
			if quest.startStorageId == key and quest.startStorageValue == value then
				return true
			end

			if quest.missions then
				for missionId = 1, #quest.missions do
					local mission = Game.getMission(questId, missionId)
					if mission then
						if mission.storageId == key and value >= mission.startValue and value <= mission.endValue then
							return mission.description or oldValue < mission.storageId or oldValue > mission.endValue
						end
					end
				end
			end
		end
	end
	return false
end

function Game.isQuestStorageKey(key)
	for questId, quest in pairs(Quests) do
		local quest = Game.getQuest(questId)
		if quest then
			if quest.startStorageId == key or quest.endStorageId == key then
				return true
			end

			if quest.missions then
				for missionId = 1, #quest.missions do
					local mission = Game.getMission(questId, missionId)
					if mission and mission.storageId == key then
						return true
					end
				end
			end
		end
	end
	return false
end

function Game.getQuestsCount(player)
	local count = 0
	if Quests then
		for id = 1, #Quests do
			if player:questIsStarted(id) then
				count = count + 1
			end
		end
	end
	return count
end

function Game.getMissionsCount(player, questId)
	local quest = Game.getQuest(questId)
	local count = 0
	if quest then
		local missions = quest.missions
		if missions then
			for missionId = 1, #missions do
				if player:missionIsStarted(questId, missionId) then
					count = count + 1
				end
			end
		end
	end
	return count
end

function Game.addQuest(quest)
	local findQuest = Game.getQuestIdByName(quest.name)
	if findQuest then
		Quests[findQuest] = quest
		return findQuest
	end

	local questId = #Quests + 1
	Quests[questId] = quest
	return questId
end

-- Player functions

function Player.questIsStarted(self, questId)
	local quest = Game.getQuest(questId)
	if not quest then
		return false
	end

	local value = self:getStorageValue(quest.startStorageId)
	return value ~= -1 and value >= quest.startStorageValue
end

local function hasLaterMissionStarted(player, questId, missionIndex)
	local quest = Game.getQuest(questId)
	if not quest or not quest.missions then
		return false
	end

	for index = missionIndex + 1, #quest.missions do
		local nextMission = quest.missions[index]
		if nextMission and player:missionIsStarted(questId, index) then
			return true
		end
	end

	return false
end

function Player.missionIsStarted(self, questId, missionId)
	local mission = Game.getMission(questId, missionId)
	if mission then
		local value = self:getStorageValue(mission.storageId)
		if value == -1 or value < mission.startValue or (not mission.ignoreendvalue and value > mission.endValue) then
			return false
		end

		if mission.hideWhenNextStarted and self:missionIsCompleted(questId, missionId) and hasLaterMissionStarted(self, questId, missionId) then
			return false
		end

		return true
	end
	return false
end

function Player.questIsCompleted(self, questId)
	local quest = Game.getQuest(questId)
	if not quest then
		return false
	end

	if quest.endStorageId and quest.endStorageValue then
		local value = self:getStorageValue(quest.endStorageId)
		return value ~= -1 and value >= quest.endStorageValue
	end

	local missions = quest.missions
	if missions then
		for missionId = 1, #missions do
			if not self:missionIsCompleted(questId, missionId) then
				return false
			end
		end
	end

	return true
end

function Player.questIsCompletedByStorageKey(self, key)
	local trackedMissions = PlayerTrackedMissionsData[self:getId()]
	if not trackedMissions or #trackedMissions == 0 then
		return false
	end

	local checkedQuests = {}
	for i = 1, #trackedMissions do
		local trackedMission = trackedMissions[i]
		local questId = trackedMission and trackedMission.questId
		if questId and not checkedQuests[questId] then
			checkedQuests[questId] = true

			local quest = Game.getQuest(questId)
			if quest and self:questIsCompleted(questId) then
				if quest.endStorageId and quest.endStorageValue then
					if quest.endStorageId == key then
						return true
					end
				elseif quest.missions then
					for missionId = 1, #quest.missions do
						local mission = Game.getMission(questId, missionId)
						if mission and mission.storageId == key then
							return true
						end
					end
				end

				if not quest.endStorageId and not quest.missions and quest.startStorageId == key then
					return true
				end
			end
		end
	end

	return false
end

function Player.missionIsCompleted(self, questId, missionId)
	local mission = Game.getMission(questId, missionId)
	if mission then
		local value = self:getStorageValue(mission.storageId)
		if value == -1 then
			return false
		end

		return value >= mission.endValue
	end
	return false
end

function Player.getMissionName(self, questId, missionId)
	local mission = Game.getMission(questId, missionId)
	if mission then
		if self:missionIsCompleted(questId, missionId) then
			return mission.name .. " (completed)"
		end
		return mission.name
	end
	return ""
end

function Player.getMissionId(self, questId, missionId)
	local mission = Game.getMission(questId, missionId)
	if mission then
		return mission.missionId
	end
	return 0
end

function Player.getMissionDescription(self, questId, missionId)
	local mission = Game.getMission(questId, missionId)
	if mission then
		if mission.description then
			return evaluateText(mission.description, self)
		end

		local value = self:getStorageValue(mission.storageId)
		local state = value
		if mission.ignoreendvalue and value > table.maxn(mission.states) then
			state = table.maxn(mission.states)
		end
		return evaluateText(mission.states[state], self)
	end
	return "An error has occurred, please contact a gamemaster."
end

function Player.sendQuestLog(self)
	local msg = NetworkMessage()
	msg:addByte(0xF0)
	local questCount = 0
	local questIds = {}
	for questId, quest in pairs(Quests) do
		if self:questIsStarted(questId) then
			questCount = questCount + 1
			table.insert(questIds, questId)
		end
	end
	msg:addU16(questCount)
	for _, questId in ipairs(questIds) do
		msg:addU16(questId)
		msg:addString(Quests[questId].name, "Player.sendQuestLog")
		msg:addByte(self:questIsCompleted(questId) and 0x01 or 0x00)
	end
	msg:sendToPlayer(self)
	msg:delete()
end

function Player.sendQuestLine(self, questId)
	local quest = Game.getQuest(questId)
	if quest then
		local missions = quest.missions
		local msg = NetworkMessage()
		msg:addByte(0xF1)
		msg:addU16(questId)
		msg:addByte(Game.getMissionsCount(self, questId))
		if missions then
			for missionId = 1, #missions do
				if self:missionIsStarted(questId, missionId) then
					if self:getClient().version >= 1200 then
						msg:addU16(self:getMissionId(questId, missionId))
					end
					msg:addString(self:getMissionName(questId, missionId), "Player.sendQuestLine - self:getMissionName(questId, missionId)")
					msg:addString(self:getMissionDescription(questId, missionId), "Player.sendQuestLine - self:getMissionDescription(questId, missionId)")
				end
			end
		end

		msg:sendToPlayer(self)
		msg:delete()
	end
end

function Player.sendTrackedQuests(self, remainingQuests, missions)
	local msg = NetworkMessage()
	msg:addByte(0xD0)
	msg:addByte(0x01)
	msg:addByte(remainingQuests)
	msg:addByte(#missions)
	for _, mission in ipairs(missions) do
		msg:addU16(mission.missionId)
		msg:addU16(mission.questId)
		msg:addString(mission.questName, "Player.sendTrackedQuests - mission.questName")
		msg:addString(mission.missionName, "Player.sendTrackedQuests - mission.missionName")
		msg:addString(mission.missionDesc, "Player.sendTrackedQuests - mission.missionDesc")
	end
	msg:sendToPlayer(self)
	msg:delete()
end

function Player.sendUpdateTrackedQuest(self, mission)
	local msg = NetworkMessage()
	msg:addByte(0xD0)
	msg:addByte(0x00)
	msg:addU16(mission.questId)
	msg:addU16(mission.missionId)
	msg:addString(mission.questName)
	msg:addString(mission.missionName, "Player.sendUpdateTrackedQuest - mission.missionName")
	msg:addString(mission.missionDesc, "Player.sendUpdateTrackedQuest - mission.missionDesc")
	msg:sendToPlayer(self)
	msg:delete()
end

function Player.updateStorage(self, key, value, oldValue, currentFrameTime)
	local playerId = self:getId()
	local isQuestStorage = Game.isQuestStorage(key, value, oldValue)
	local isQuestStorageKey = isQuestStorage or Game.isQuestStorageKey(key)
	if LastQuestlogUpdate[playerId] ~= currentFrameTime and isQuestStorage then
		LastQuestlogUpdate[playerId] = currentFrameTime
		if value ~= oldValue then
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your questlog has been updated.")
		end
	end
	if isQuestStorageKey then
		self:refreshTrackedMissions()

		self:processAutomaticQuestTracker(key, value, oldValue)
	end
end

local function sendPrint(questId, index)
	logger.warn("[sendPrint] - Quest id:[{}]] mission:[{}]", questId, index)
end

for questId, quest in pairs(Quests) do
	local quest = Game.getQuest(questId)
	if quest then
		for index, value in ipairs(quest.missions) do
			if index then
				if not value.name then
					logger.error("Quest.load: Wrong mission name found")
					sendPrint(questId, index)
				end
				if not value.storageId then
					logger.error("Quest.load: Wrong mission storage found")
					sendPrint(questId, index)
				end
				if not value.missionId then
					logger.error("Quest.load: Wrong mission id found")
					sendPrint(questId, index)
				end
				if not value.startValue then
					logger.error("Quest.load: Wrong mission start value found")
					sendPrint(questId, index)
				end
				if not value.endValue then
					logger.error("Quest.load: Wrong mission end value found")
					sendPrint(questId, index)
				end
			end
		end
	end
end
