local config = {
	{ position = { x = 33560, y = 31395, z = 13 }, destination = { x = 33563, y = 31389, z = 13 } },
	{ position = { x = 33584, y = 31388, z = 13 }, destination = { x = 33584, y = 31390, z = 13 } },
}

local moveEvent = MoveEvent()
function moveEvent.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

moveEvent:type("stepin")
for value in pairs(config) do
	moveEvent:position(config[value].position)
end
moveEvent:register()
