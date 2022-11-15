local enterThalasTeleport = MoveEvent()

function enterThalasTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorage.TheAncientTombs.ThalasSwitchesGlobalStorage) < 8 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33367, 32805, 14)
	player:teleportTo(Position(33367, 32805, 14))
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

enterThalasTeleport:type("stepin")
enterThalasTeleport:uid(50135)
enterThalasTeleport:register()
