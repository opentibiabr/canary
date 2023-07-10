local config = {
	[9238] = Position(33456, 31346, 8),
	[9239] = Position(33199, 31978, 8)
}

local grayBeachVortex = MoveEvent()

function grayBeachVortex.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPosition = config[item.uid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dive into the vortex to swim below the rocks to the other side of the cave.")
	return true
end

grayBeachVortex:type("stepin")

for index, value in pairs(config) do
	grayBeachVortex:uid(index)
end

grayBeachVortex:register()
