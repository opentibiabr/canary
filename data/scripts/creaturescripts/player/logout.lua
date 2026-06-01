local playerLogout = CreatureEvent("PlayerLogout")

function playerLogout.onLogout(player)
	local playerId = player:getId()

	if _G.NextUseStaminaTime[playerId] then
		_G.NextUseStaminaTime[playerId] = nil
	end

	if LastQuestlogUpdate then
		LastQuestlogUpdate[playerId] = nil
	end

	if PlayerTrackedMissionRemovalEvents and PlayerTrackedMissionRemovalEvents[playerId] and player.flushTrackedMissionRemovalEvents then
		player:flushTrackedMissionRemovalEvents(false)
	end

	if PlayerTrackedMissionsData then
		if PlayerTrackedMissionsData[playerId] and player.saveTrackedMissions then
			player:saveTrackedMissions()
		end
		PlayerTrackedMissionsData[playerId] = nil
	end

	if PlayerTrackedMissionRemovalEvents then
		PlayerTrackedMissionRemovalEvents[playerId] = nil
	end

	if PlayerQuestTrackerInitialSync then
		PlayerQuestTrackerInitialSync[playerId] = nil
	end

	local stats = player:inBossFight()
	if stats then
		local boss = Monster(stats.bossId)
		if boss then
			local dmgOut = boss:getDamageMap()[playerId]
			if dmgOut then
				stats.damageOut = (stats.damageOut or 0) + dmgOut.total
			end

			stats.stamina = player:getStamina()
		end
	end

	if _G.OnExerciseTraining[playerId] then
		stopEvent(_G.OnExerciseTraining[playerId].event)
		_G.OnExerciseTraining[playerId] = nil
		player:setTraining(false)
	end
	return true
end

playerLogout:register()
