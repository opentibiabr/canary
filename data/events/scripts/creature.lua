function Creature:onChangeOutfit(outfit)
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return RETURNVALUE_NOERROR
end

function Creature:onTargetCombat(target)
	if self:isPlayer() then
		if target and target:getName() == staminaBonus.target then
			local playerId = self:getId()
			if not staminaBonus.eventsTrainer[playerId] then
				staminaBonus.eventsTrainer[playerId] = addEvent(addStamina, staminaBonus.period, playerId)
			end
		end
	end
	return true
end
