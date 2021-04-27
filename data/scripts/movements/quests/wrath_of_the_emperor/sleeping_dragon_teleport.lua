local sleepingDragonTeleport = MoveEvent()

function sleepingDragonTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.WrathoftheEmperor.Mission09) == -1 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local sleepingDragon = Position(33240, 31247, 10)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(sleepingDragon)
	sleepingDragon:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

sleepingDragonTeleport:type("stepin")
sleepingDragonTeleport:uid(9263)
sleepingDragonTeleport:register()
