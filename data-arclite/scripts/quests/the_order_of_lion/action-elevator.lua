
local elevatorBounacAction = Action()
function elevatorBounacAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= Position(32371, 32496, 7) then
		Position(32371, 32496, 7):sendMagicEffect(CONST_ME_POFF)
	else
		player:teleportTo(Position(32374, 32497, 3))
		Position(32374, 32497, 3):sendMagicEffect(CONST_ME_POFF)
	end
	return true
end
elevatorBounacAction:aid(59604)
elevatorBounacAction:register()

local elevatorBounacMoveEvent = MoveEvent()
function elevatorBounacMoveEvent.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() then
		creature:teleportTo(Position(32371, 32497, 7))
		Position(32371, 32497, 7):sendMagicEffect(CONST_ME_POFF)
	end
	return true
end
elevatorBounacMoveEvent:aid(59605)
elevatorBounacMoveEvent:register()