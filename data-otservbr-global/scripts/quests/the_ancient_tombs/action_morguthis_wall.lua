local morguthisWall = Action()

function morguthisWall.onUse(player, item, fromPosition, target, toPosition)
	local wallPosition = Position(33211, 32698, 13)
	local wallId = 1306

	local tile = Tile(wallPosition)
	if not tile then
		return false
	end

	local wall = tile:getItemById(wallId)
	if wall then
		wall:remove()
	else
		local creatures = tile:getCreatures()
		if #creatures > 0 then
			for _, creature in ipairs(creatures) do
				local newPosition = Position(wallPosition.x, wallPosition.y + 1, wallPosition.z)
				creature:teleportTo(newPosition)
			end
		end

		local items = tile:getItems()
		if #items > 0 then
			for _, tileItem in ipairs(items) do
				local newPosition = Position(wallPosition.x, wallPosition.y + 1, wallPosition.z)
				tileItem:moveTo(newPosition)
			end
		end

		Game.createItem(wallId, 1, wallPosition)
	end

	return true
end

morguthisWall:position(Position(33212, 32693, 13))
morguthisWall:position(Position(33209, 32701, 13))
morguthisWall:register()
