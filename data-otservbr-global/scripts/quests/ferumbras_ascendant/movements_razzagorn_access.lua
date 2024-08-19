local razzagornAccess = MoveEvent()

function razzagornAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.FerumbrasAscension.TheShatterer) >= 1 then
		player:teleportTo(Position(33437, 32443, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		local pos = player:getPosition()
		pos.x = pos.x + 2
		player:teleportTo(pos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You don't have access to this teleport yet.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

razzagornAccess:type("stepin")
razzagornAccess:aid(53801)
razzagornAccess:register()
