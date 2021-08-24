function Creature:onChangeOutfit(outfit)
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return RETURNVALUE_NOERROR
end

function Creature:onTargetCombat(target)
	if self:isPlayer() then
		if target and target:getName() == staminaBonus.target then
			local id = self:getId()
			if not staminaBonus.eventsTrainer[id] then
				staminaBonus.eventsTrainer[id] = addEvent(addStamina, staminaBonus.period, id)
			end
		end
	end
	return true
end
