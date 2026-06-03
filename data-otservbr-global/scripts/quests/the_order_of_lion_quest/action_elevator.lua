local elevatorBounacUp = MoveEvent()
function elevatorBounacUp.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) < 5 then
		player:teleportTo(fromPosition)
		return true
	end
	player:teleportTo(Position(32374, 32497, 3))
	Position(32374, 32497, 3):sendMagicEffect(CONST_ME_POFF)
	return true
end

elevatorBounacUp:aid(59604)
elevatorBounacUp:type("stepin")
elevatorBounacUp:register()

local elevatorBounacDown = MoveEvent()
function elevatorBounacDown.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() then
		creature:teleportTo(Position(32371, 32497, 7))
		Position(32371, 32497, 7):sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

elevatorBounacDown:aid(59605)
elevatorBounacDown:type("stepin")
elevatorBounacDown:register()
