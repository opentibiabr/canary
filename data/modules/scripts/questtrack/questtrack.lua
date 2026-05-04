function onRecvbyte(player, msg, byte)
	if byte ~= 0xD0 then
		return
	end

	local trackedMissions = {}
	local missionCount = msg:getByte()

	for i = 1, missionCount do
		trackedMissions[#trackedMissions + 1] = msg:getU16()
	end

	-- Client oficial envia 3 bytes extras após a lista:
	-- autoTrackNewQuests, autoUntrackCompletedQuests, extra/desconhecido.
	local autoTrackNewQuests = msg:getByte() == 1
	local autoUntrackCompletedQuests = msg:getByte() == 1
	local extra = msg:getByte()

	local oldAutoTrackNewQuests = false

	if player.getQuestTrackerOption then
		oldAutoTrackNewQuests = player:getQuestTrackerOption("autoTrackNewQuests")
	end

	local isInitialSync = player.isQuestTrackerInitialSync and player:isQuestTrackerInitialSync()
	if isInitialSync then
		if player.reconcileInitialTrackedMissions then
			player:reconcileInitialTrackedMissions(trackedMissions)
		end

		logger.debug("[QuestTracker] reconciled initial client cache player='{}' missions={} autoTrack={} autoUntrack={} extra={}", player:getName(), missionCount, autoTrackNewQuests and "true" or "false", autoUntrackCompletedQuests and "true" or "false", extra)
	else
		player:resetTrackedMissions(trackedMissions)
	end

	if player.setQuestTrackerOption then
		player:setQuestTrackerOption("autoTrackNewQuests", autoTrackNewQuests)
		player:setQuestTrackerOption("autoUntrackCompletedQuests", autoUntrackCompletedQuests)
	end

	-- Importante:
	-- Quando o player liga "Automatically track new quests",
	-- marca as quests atuais como conhecidas para não adicionar tudo no tracker.
	if autoTrackNewQuests and not oldAutoTrackNewQuests and player.updateQuestTrackerKnownQuests then
		player:updateQuestTrackerKnownQuests(false)
	end

	-- Não chame processAutomaticQuestTracker aqui.
	-- Essa função deve rodar apenas quando storage de quest muda,
	-- dentro de Player.updateStorage.
	logger.debug("[QuestTracker] player='{}' missions={} autoTrack={} autoUntrack={} extra={}", player:getName(), missionCount, autoTrackNewQuests and "true" or "false", autoUntrackCompletedQuests and "true" or "false", extra)
end
