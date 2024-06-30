local enterAshmunrahTeleport = MoveEvent()

function enterAshmunrahTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.AshmunrahSwitchesGlobalStorage) < 5 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33198, 32885, 11)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

enterAshmunrahTeleport:type("stepin")
enterAshmunrahTeleport:uid(50138)
enterAshmunrahTeleport:register()
