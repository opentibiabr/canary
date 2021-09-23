function Creature:onChangeOutfit(outfit)
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return RETURNVALUE_NOERROR
end

function Creature:onTargetCombat(target)
	local player = target:getPlayer()
	if player and player:getName() == staminaBonus.player then
		local playerId = player:getId()
		if not staminaBonus.eventsTrainer[playerId] then
			staminaBonus.eventsTrainer[playerId] = addEvent(addStamina, staminaBonus.period, playerId)
		end
	end
	return true
end
