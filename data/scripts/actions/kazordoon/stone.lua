local config = {
	{position = Position(32604, 31904, 3), itemId = 1300},
	{position = Position(32605, 31904, 3), itemId = 1301},
	{position = Position(32604, 31905, 3), itemId = 1302},
	{position = Position(32605, 31905, 3), itemId = 1303}
}

local stone = Action()

function stone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local stoneItem
		for i = 1, #config do
			stoneItem = Tile(config[i].position):getItemById(config[i].itemId)
			if stoneItem then
				stoneItem:remove()
			end
		end
	else
		for i = 1, #config do
			Game.createItem(config[i].itemId, 1, config[i].position)
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

stone:aid(50237)
stone:register()
