local ramp = MoveEvent()

function ramp.onStepIn(creature, item, pos, fromPosition)
	local player = Player(creature:getId())
	if not creature:isPlayer() then
		return true
	end

	local position = Position(33614, 32759, 8)
	player:teleportTo(position, true)

	return true
end

ramp:type("stepin")
ramp:position(Position(33613, 32759, 9))
ramp:register()
