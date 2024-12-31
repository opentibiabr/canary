local lowerRoshamuul20122 = MoveEvent()

function lowerRoshamuul20122.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if item:getId() == 20122 then
		player:teleportTo(Position(33554, 32546, 7))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	return false
end

lowerRoshamuul20122:type("stepin")
lowerRoshamuul20122:id(20122)
lowerRoshamuul20122:register()

local roshamuulCaves = {
	Position(33560, 32523, 8),
	Position(33554, 32543, 8),
	Position(33573, 32545, 8),
	Position(33543, 32560, 8),
	Position(33579, 32565, 8),
	Position(33527, 32597, 8),
}

local lowerRoshamuul1500 = MoveEvent()

function lowerRoshamuul1500.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if item:getActionId() == 55000 then
		player:teleportTo(roshamuulCaves[math.random(#roshamuulCaves)])
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	return false
end

lowerRoshamuul1500:type("stepin")
lowerRoshamuul1500:aid(55000)
lowerRoshamuul1500:register()
