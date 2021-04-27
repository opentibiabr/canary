local config = {
	[1945] = {
		sacrifices = {
			{position = Position(32878, 32270, 14), itemId = 2016},
			{position = Position(32881, 32267, 14), itemId = 2168},
			{position = Position(32881, 32273, 14), itemId = 6300},
			{position = Position(32884, 32270, 14), itemId = 1500} -- or itemID = 1487 for PVP servers
		},
		wells = {
			{position = Position(32874, 32263, 14), wellId = 3729, transformId = 3733},
			{position = Position(32875, 32263, 14), wellId = 3730, transformId = 3734},
			{position = Position(32874, 32264, 14), wellId = 3731, transformId = 3735},
			{position = Position(32875, 32264, 14), wellId = 3732, transformId = 3736}
		}
	},
	[1946] = {
		wells = {
			{position = Position(32874, 32263, 14), wellId = 3733, transformId = 3729},
			{position = Position(32875, 32263, 14), wellId = 3734, transformId = 3730},
			{position = Position(32874, 32264, 14), wellId = 3735, transformId = 3731},
			{position = Position(32875, 32264, 14), wellId = 3736, transformId = 3732}
		}
	}
}

local dreamerStone = Action()
function dreamerStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lever = config[item.itemid]
	if not lever then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	local wellItem
	for i = 1, #lever.wells do
		wellItem = Tile(lever.wells[i].position):getItemById(lever.wells[i].wellId)
		if wellItem then
			wellItem:transform(lever.wells[i].transformId)
		end
	end

	if lever.sacrifices then
		local sacrificeItems, sacrificeItem = true
		for i = 1, #lever.sacrifices do
			sacrificeItem = Tile(lever.sacrifices[i].position):getItemById(lever.sacrifices[i].itemId)
			if not sacrificeItem then
				sacrificeItems = false
				break
			elseif sacrificeItem then
				sacrificeItem:remove()
			end
		end

		if not sacrificeItems then
			return true
		end

		local stonePosition = Position(32881, 32270, 14)
		local stoneItem = Tile(stonePosition):getItemById(1355)
		if stoneItem then
			stoneItem:remove()
		end

		local teleportExists = Tile(stonePosition):getItemById(1387)
		if not teleportExists then
			local newItem = Game.createItem(1387, 1, stonePosition)
			if newItem then
				newItem:setActionId(9031)
			end
		end
	end
	return true
end

dreamerStone:uid(2004)
dreamerStone:register()