--outlaw camp quest (bright sword quest)
local config = {
	{ position = { x = 32619, y = 32248, z = 6 }, destination = { x = 32619, y = 32249, z = 8 } },
}

local brightSword = MoveEvent()
function brightSword.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			return true
		end
	end
end

brightSword:type("stepin")
for value in pairs(config) do
	brightSword:position(config[value].position)
end

brightSword:register()
