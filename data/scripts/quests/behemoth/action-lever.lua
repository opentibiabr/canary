local wallsPositions = {
	{x = 33295, y = 31677, z = 15},
	{x = 33296, y = 31677, z = 15},
	{x = 33297, y = 31677, z = 15},
	{x = 33298, y = 31677, z = 15},
	{x = 33299, y = 31677, z = 15}
}

local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1946 then
		return false
	end

	for i = 1, #wallsPositions do
		local walls = Tile(wallsPositions[i]):getItemById(1304)
		if walls then
			walls:remove()
		end
	end

	item:transform(1946)
	return true
end

lever:uid(30009)
lever:register()
