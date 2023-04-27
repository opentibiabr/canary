

local paleWormExit = MoveEvent()

function paleWormExit.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() == false then
		return true
	end
	if creature:getCondition(CONDITION_HEX, CONDITIONID_COMBAT, 1095) then
		creature:removeCondition(CONDITION_HEX, CONDITIONID_COMBAT, 1095)
	end
	position:sendMagicEffect(CONST_ME_TELEPORT)
	creature:teleportTo(Position(33568, 31445, 10))
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

paleWormExit:type("stepin")
paleWormExit:aid(49611)

paleWormExit:register()