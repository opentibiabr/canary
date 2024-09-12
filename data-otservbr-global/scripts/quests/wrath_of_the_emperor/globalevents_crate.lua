local trapDoors = {
	{ Position(33385, 31139, 8) },
	{ Position(33385, 31134, 8) },
	{ Position(33385, 31126, 8) },
	{ Position(33385, 31119, 8) },
	{ Position(33385, 31118, 8) },
	{ Position(33380, 31093, 8) },
	{ Position(33380, 31085, 8) },
}

local itemIds = { 11257, 11258 }

local toggleTrapDoors = GlobalEvent("toggleTrapDoors")

function toggleTrapDoors.onThink(interval)
	for _, position in ipairs(trapDoors) do
		local tile = Tile(position[1])
		if tile then
			local currentItem = nil
			for _, item in ipairs(tile:getItems()) do
				if item:getId() == 11257 or item:getId() == 11258 then
					currentItem = item
					break
				end
			end

			local newItemId = 11257
			if currentItem then
				newItemId = (currentItem:getId() == 11257) and 11258 or 11257
				currentItem:transform(newItemId)
			else
				Game.createItem(newItemId, 1, position[1])
			end
		end
	end
	return true
end

toggleTrapDoors:interval(10000) -- 10 seconds
toggleTrapDoors:register()
