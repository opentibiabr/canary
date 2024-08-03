local plagirathAccess = MoveEvent()

function plagirathAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.FerumbrasAscension.TheLordOfTheLiceAccess) < 1 then
		local pos = player:getPosition()
		pos.x = pos.x - 2
		player:teleportTo(pos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You don't have access to this teleport yet.", TALKTYPE_MONSTER_SAY)
		return true
	end
	player:teleportTo(Position(33238, 31477, 13))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

plagirathAccess:type("stepin")
plagirathAccess:aid(53800)
plagirathAccess:register()
