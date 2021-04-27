local config = {
	bridgePositions = {
		{position = Position(33119, 32794, 14), groundId = 598},
		{position = Position(33119, 32795, 14), groundId = 598},
		{position = Position(33120, 32794, 14), groundId = 598},
		{position = Position(33120, 32795, 14), groundId = 598},
		{position = Position(33121, 32794, 14), groundId = 598},
		{position = Position(33121, 32795, 14), groundId = 598}

	},
	leverPositions = {
	Position(33115, 32797, 14),
		Position(33118, 32790, 14),
		Position(33122, 32790, 14)
	},
	relocatePosition = Position(33120, 2791, 14),
	relocateMonsterPosition = Position(33120, 32799, 14),
	bridgeId = 5770
}

local theAncientLever = Action()
function theAncientLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local leverLeft, lever = item.itemid == 1945
	for i = 1, #config.leverPositions do
		lever = Tile(config.leverPositions[i]):getItemById(leverLeft and 1945 or 1946)
		if lever then
			lever:transform(leverLeft and 1946 or 1945)
		end
	end

	local tile, tmpItem, bridge
	if leverLeft then
		for i = 1, #config.bridgePositions do
			bridge = config.bridgePositions[i]
			tile = Tile(bridge.position)

			tmpItem = tile:getGround()
			if tmpItem then
				tmpItem:transform(config.bridgeId)
			end

			if bridge.itemId then
				tmpItem = tile:getItemById(bridge.itemId)
				if tmpItem then
					tmpItem:remove()
				end
			end
		end
	else
		for i = 1, #config.bridgePositions do
			bridge = config.bridgePositions[i]
			tile = Tile(bridge.position)

			tile:relocateTo(config.relocatePosition, true, config.relocateMonsterPosition)
			tile:getGround():transform(bridge.groundId)
			Game.createItem(bridge.itemId, 1, bridge.position)
		end

	end
	return true
end

theAncientLever:aid(12120)
theAncientLever:register()