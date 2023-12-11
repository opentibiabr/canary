local config = {
	{ position = { x = 34015, y = 31892, z = 8 }, destination = { x = 32728, y = 32880, z = 7 } },
	{ position = { x = 34041, y = 31726, z = 10 }, destination = { x = 32728, y = 32880, z = 7 } },
}

local exit = MoveEvent()
function exit.onStepIn(creature, item, position, fromPosition)
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

exit:type("stepin")
for value in pairs(config) do
	exit:position(config[value].position)
end
exit:register()
