local positions = {
	{x = 32497, y = 31889, z = 7},
	{x = 32497, y = 31890, z = 7},
	{x = 32498, y = 31890, z = 7},
	{x = 32499, y = 31890, z = 7},
	{x = 32502, y = 31890, z = 7},
	{x = 32494, y = 31888, z = 7}
}

local poison = MoveEvent()

function poison.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local removeHealth = Tile({x = 32497, y = 31889, z = 7}):getFieldItem()
	if not removeHealth then
		player:addHealth(-200, COMBAT_POISONDAMAGE)
		for i = 1, #positions do
			local tile = Tile(positions[i]):getFieldItem()
			if not tile then
				Game.createItem(1490, 1, Position(positions[i]))
			end
		end
	end
	return true
end

poison:uid(25011)
poison:register()
