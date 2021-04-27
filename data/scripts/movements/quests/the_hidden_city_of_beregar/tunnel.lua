local tunnel = MoveEvent()

function tunnel.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32616, 31514, 9))
	player:say("Use the ore wagon to pass this spot.", TALKTYPE_MONSTER_SAY)
	return true
end

tunnel:type("stepin")
tunnel:aid(50116)
tunnel:register()
