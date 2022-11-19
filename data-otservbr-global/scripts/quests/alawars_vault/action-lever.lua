local wallsPositions = {
	{x = 32186, y = 31626, z = 8},
	{x = 32187, y = 31626, z = 8},
	{x = 32188, y = 31626, z = 8},
	{x = 32189, y = 31626, z = 8}
}

local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #wallsPositions do
		if item.itemid == 2772 then
			Tile(wallsPositions[i]):getItemById(2129):remove()
			item:remove()
		end
	end
	return true
end

lever:uid(30008)
lever:register()
