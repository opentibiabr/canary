local exit = MoveEvent()

function exit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	player:teleportTo(Position(33623, 31901, 6))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("Slurp!", TALKTYPE_MONSTER_SAY)
	return true
end

exit:type("stepin")
exit:aid(24872)
exit:register()
