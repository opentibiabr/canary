local cultsCarlinTeleportExit = MoveEvent()

function cultsCarlinTeleportExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
		creature:teleportTo(Position(32403, 31813, 8))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    return true
end

cultsCarlinTeleportExit:position({x = 32351, y = 31679, z = 8})
cultsCarlinTeleportExit:register()
