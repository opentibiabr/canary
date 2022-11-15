local flowerPositions = {
	[1] = {itemid = 3676, position = Position(33455, 32707, 14)},
	[2] = {itemid = 3676, position = Position(33460, 32707, 14)},
	[3] = {itemid = 3678, position = Position(33455, 32708, 14)},
	[4] = {itemid = 3677, position = Position(33457, 32707, 14)},
	[5] = {itemid = 3678, position = Position(33457, 32708, 14)},
	[6] = {itemid = 3677, position = Position(33456, 32708, 14)},
	[7] = {itemid = 3676, position = Position(33458, 32709, 14)},
	[8] = {itemid = 3677, position = Position(33459, 32708, 14)},
	[9] = {itemid = 3678, position = Position(33460, 32709, 14)}
}

local gates = {
	{position = Position(33476, 32698, 14), itemid = 7144, transform = 1635},
	{position = Position(33478, 32698, 14), itemid = 7144, transform = 1634},
	{position = Position(33475, 32698, 14), itemid = 1635, transform = 7144},
	{position = Position(33479, 32698, 14), itemid = 1634, transform = 7144}
}

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local ferumbrasAscendantFlowerPuzzle = Action()
function ferumbrasAscendantFlowerPuzzle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9110 then
		for a = 1, #flowerPositions do
			local flower = flowerPositions[a]
			if not Tile(flower.position):getItemById(flower.itemid) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The order of the flowers in the garden are wrong.')
				return true
			end
		end
		if Game.getStorageValue(Storage.FerumbrasAscension.FlowerPuzzleTimer) >= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The portal still activated.')
		else
			Game.setStorageValue(Storage.FerumbrasAscension.FlowerPuzzleTimer, 1)
			addEvent(Game.setStorageValue, 30 * 1000, Storage.FerumbrasAscension.FlowerPuzzleTimer, 0)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'A portal forms as two beams of a strange construction dividing this room move towards each other.')
			for x = 33475, 33479 do
				local pos = Position(x, 32698, 14)
				pos:sendMagicEffect(CONST_ME_POFF)
			end
			for k = 1, #gates do
				local gate = gates[k]
				local gatee = Tile(gate.position):getItemById(gate.itemid)
				if gatee then
					gatee:transform(gate.transform)
				end
				addEvent(revertItem, 30 * 1000, gate.position, gate.itemid, gate.transform)
			end
			local wall = Tile(Position(33477, 32698, 14)):getItemById(5068)
			if not wall then
				Game.createItem(5068, 1, Position(33477, 32698, 14))
			end
		end
		item:transform(9111)
	elseif item.itemid == 9111 then
		item:transform(9110)
	end
	return true
end

ferumbrasAscendantFlowerPuzzle:aid(34300)
ferumbrasAscendantFlowerPuzzle:register()