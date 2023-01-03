local ec = EventCallback

function ec.onMoveCreature(player, creature, fromPosition, toPosition)
	local player = creature:getPlayer()
	if player and onExerciseTraining[player:getId()] and player:getGroup():hasFlag(PlayerFlag_CanPushAllCreatures) == false then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end
	return true
end

ec:register(--[[0]])
