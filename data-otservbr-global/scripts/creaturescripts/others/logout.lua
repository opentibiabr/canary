local playerLogout = CreatureEvent("PlayerLogout")
function playerLogout.onLogout(player)
	local playerId = player:getId()

	if _G.NextUseStaminaTime[playerId] ~= nil then
		_G.NextUseStaminaTime[playerId] = nil
	end

	player:saveSpecialStorage()
	player:setStorageValue(Storage.ExerciseDummyExhaust, 0)

	local stats = player:inBossFight()
	if stats then
		local boss = Monster(stats.bossId)
		-- Player logged out (or died) in the middle of a boss fight, store his damageOut and stamina
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

	player:setStorageValue(17101, 0)
	return true
end

playerLogout:register()
