local Teleport = MoveEvent()

function Teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	player:teleportTo(Position(33492, 31546, 13))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

Teleport:position({x = 32174, y = 31916, z = 8})
Teleport:register()
