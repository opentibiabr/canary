function Creature:onChangeOutfit(outfit)
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return RETURNVALUE_NOERROR
end

function Creature:onTargetCombat(target)
	if not self then
		return true
	end

	self:addEventStamina(target)
	return true
end
