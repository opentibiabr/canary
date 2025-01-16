function Player.inPrison(self)
	return self:getPosition():isInRange(Position(1546, 1020, 7), Position(1617, 1060, 4))
end

function createTpAndOrnaments(eventName, teleportId, position, destination)
	local item = Game.createItem(teleportId, 1, position)
	if item then
		if not item:isTeleport() then
			item:remove()
			return false
		end
		item:setDestination(destination)
	end
end

function removeTpAndOrnaments(eventName, position)
	local tile = Tile(position)
	if tile then
		local items = tile:getItems()
		if items then
			for i = 1, #items do
				items[i]:remove()
			end
		end
	end
end
