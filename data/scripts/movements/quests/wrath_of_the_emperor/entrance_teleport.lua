local entranceTeleport = MoveEvent()

function entranceTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.WrathoftheEmperor.Questline) < 30 then
		local destinationz = Position(33138, 31249, 6)
		player:teleportTo(destinationz)
		return true
	end

	if player:getStorageValue(Storage.WrathoftheEmperor.BossStatus) < 5 then
		player:teleportTo(Position(33138, 31249, 6))
		return true
	end

	if player:getStorageValue(Storage.WrathoftheEmperor.Questline) > 31 then
		local firstDestination = Position(33360, 31397, 9)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(firstDestination)
		firstDestination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local secondDestination = Position(33359, 31397, 9)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(secondDestination)
	secondDestination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

entranceTeleport:type("stepin")
entranceTeleport:uid(1109)
entranceTeleport:register()
