local pythiusTeleport = MoveEvent()

function pythiusTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.HiddenCityOfBeregar.PythiusTheRotten) < os.time() then
		position.y = position.y + 4
		player:teleportTo(position)
		player:say("OFFER ME SOMETHING IF YOU WANT TO PASS!",
			TALKTYPE_MONSTER_YELL, false, player, Position(32589, 31407, 15))
		position:sendMagicEffect(CONST_ME_FIREAREA)
		return true
	end

	local destination = Position(32601, 31397, 14)
	player:teleportTo(destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

pythiusTeleport:type("stepin")
pythiusTeleport:uid(50127)
pythiusTeleport:register()
