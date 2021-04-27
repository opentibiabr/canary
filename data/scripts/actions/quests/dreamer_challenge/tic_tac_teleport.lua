local config = {
	{position = Position(32845, 32264, 14), itemId = 2639},
	{position = Position(32843, 32266, 14), itemId = 2639},
	{position = Position(32843, 32268, 14), itemId = 2639},
	{position = Position(32845, 32268, 14), itemId = 2639},
	{position = Position(32844, 32267, 14), itemId = 2639},
	{position = Position(32840, 32269, 14), itemId = 2639},
	{position = Position(32841, 32269, 14), itemId = 2638},
	{position = Position(32840, 32268, 14), itemId = 2638},
	{position = Position(32842, 32267, 14), itemId = 2638}
}

local dreamerTicTacTeleport = Action()
function dreamerTicTacTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 1945 and 1946 or 1945)

	iterateArea(
		function(position)
			local pillar = Tile(position):getItemById(1515)
			if pillar then
				pillar:remove()
			else
				Game.createItem(1515, 1, position)
			end
		end,
		Position(32835, 32285, 14),
		Position(32838, 32285, 14)
	)

	local tokens, ticTacToeItem = true
	for i = 1, #config do
		ticTacToeItem = Tile(config[i].position):getItemById(config[i].itemId)
		if not ticTacToeItem then
			tokens = false
			break
		end
	end

	if not tokens then
		return true
	end

	local position = Position(32836, 32288, 14)
	if item.itemid == 1945 then
		local crack = Tile(position):getItemById(6299)
		if crack then
			crack:remove()

			local teleport = Game.createItem(1387, 1, position)
			if teleport then
				teleport:setActionId(9032)
			end
		end

	else

		local teleport = Tile(position):getItemById(1387)
		if teleport then
			teleport:remove()
			Game.createItem(6299, 1, position)
		end
	end

	return true
end

dreamerTicTacTeleport:aid(8033)
dreamerTicTacTeleport:register()