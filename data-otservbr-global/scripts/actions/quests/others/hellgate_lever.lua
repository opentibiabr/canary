local config = {
	bridgePositions = {
		Position(32627, 31699, 10),
		Position(32628, 31699, 10),
		Position(32629, 31699, 10)
	},
	removeCreaturePosition = Position(32630, 31699, 10),
	bridgeID = 5770,
	waterID = 622
}

local othersHellGate = Action()
function othersHellGate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile, thing, creature
	for i = 1, #config.bridgePositions do
		tile = Tile(config.bridgePositions[i])
		if tile then
			thing, creature = tile:getItemById(item.itemid == 2772 and config.waterID or config.bridgeID), tile:getTopCreature()
			if thing then
				thing:transform(item.itemid == 2772 and config.bridgeID or config.waterID)
			end

			if creature then
				creature:teleportTo(config.removeCreaturePosition)
			end
		end
	end

	item:transform(item.itemid == 2772 and 2773 or 2772)
	return true
end

othersHellGate:aid(50027)
othersHellGate:register()