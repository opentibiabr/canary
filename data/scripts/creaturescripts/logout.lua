local logout = CreatureEvent("PlayerLogout")

function logout.onLogout(player)
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = nil
	end

	if onExerciseTraining[playerId] then
		stopEvent(onExerciseTraining[playerId].event)
		onExerciseTraining[playerId] = nil
		player:setTraining(false)
	end
	return true
end

logout:register()
