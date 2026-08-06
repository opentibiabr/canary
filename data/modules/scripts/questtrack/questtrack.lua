function onRecvbyte(player, msg, byte)
	if byte ~= 0xD0 then
		return
	end

	if msg:getUnreadBytes() < 1 then
		logger.debug("[QuestTracker] ignored malformed 0xD0 packet from player='{}': missing mission count", player:getName())
		return
	end

	local trackedMissions = {}
	local missionCount = msg:getByte()
	local requiredBytes = (missionCount * 2) + 2

	if msg:getUnreadBytes() < requiredBytes then
		logger.debug("[QuestTracker] ignored malformed 0xD0 packet from player='{}': missions={} remaining={} required={}", player:getName(), missionCount, msg:getUnreadBytes(), requiredBytes)
		return
	end

	for i = 1, missionCount do
		trackedMissions[#trackedMissions + 1] = msg:getU16()
	end

	local autoTrackNewQuests = msg:getByte() == 1
	local autoUntrackCompletedQuests = msg:getByte() == 1

	local trailingBytes = msg:getUnreadBytes()
	if trailingBytes > 0 then
		logger.debug("[QuestTracker] ignored malformed 0xD0 packet from player='{}': unexpected trailing bytes={}", player:getName(), trailingBytes)
		return
	end

	local isInitialSync = player.isQuestTrackerInitialSync and player:isQuestTrackerInitialSync()
	if isInitialSync then
		if player.reconcileInitialTrackedMissions then
			player:reconcileInitialTrackedMissions(trackedMissions)
		end

		logger.debug("[QuestTracker] reconciled initial client cache player='{}' missions={} autoTrack={} autoUntrack={}", player:getName(), missionCount, autoTrackNewQuests and "true" or "false", autoUntrackCompletedQuests and "true" or "false")
	else
		player:resetTrackedMissions(trackedMissions)

		if player.setQuestTrackerOption then
			player:setQuestTrackerOption("autoTrackNewQuests", autoTrackNewQuests)
			player:setQuestTrackerOption("autoUntrackCompletedQuests", autoUntrackCompletedQuests)
		end
	end

	-- Não chame processAutomaticQuestTracker aqui.
	-- Essa função deve rodar apenas quando storage de quest muda,
	-- dentro de Player.updateStorage.
	logger.debug("[QuestTracker] player='{}' missions={} autoTrack={} autoUntrack={}", player:getName(), missionCount, autoTrackNewQuests and "true" or "false", autoUntrackCompletedQuests and "true" or "false")
end
