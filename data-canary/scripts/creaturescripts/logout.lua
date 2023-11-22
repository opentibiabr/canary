local logout = CreatureEvent("PlayerLogout")

function logout.onLogout(player)
	local playerId = player:getId()
	if _G.NextUseStaminaTime[playerId] then
		_G.NextUseStaminaTime[playerId] = nil
	end

	if _G.OnExerciseTraining[playerId] then
		stopEvent(_G.OnExerciseTraining[playerId].event)
		_G.OnExerciseTraining[playerId] = nil
		player:setTraining(false)
	end
	return true
end

logout:register()
