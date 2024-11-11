local function teleportToDestination(creature, position)
	if not creature:isPlayer() then
		return true
	end

	if position.x == 33216 and position.y == 31126 and position.z == 14 then
		creature:teleportTo(Position(33186, 31190, 7))
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	elseif position.x == 33187 and position.y == 31190 and position.z == 7 then
		creature:teleportTo(Position(33217, 31123, 14))
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	else
		return false
	end
end

local dragoliskTeleport = MoveEvent()
function dragoliskTeleport.onStepIn(creature, item, position, fromPosition)
	return teleportToDestination(creature, position)
end

dragoliskTeleport:position({ x = 33216, y = 31126, z = 14 })
dragoliskTeleport:position({ x = 33187, y = 31190, z = 7 })
dragoliskTeleport:register()
