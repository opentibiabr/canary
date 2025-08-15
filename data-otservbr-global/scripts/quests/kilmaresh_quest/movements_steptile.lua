local config = {
	[57535] = { tileId = 416, positionTo = { x = 33829, y = 31635, z = 9 } },
	[57536] = { tileId = 417, positionTo = { x = 33831, y = 31635, z = 9 } },
	[57537] = { tileId = 418, positionTo = { x = 33833, y = 31635, z = 9 } },
	[57538] = { tileId = 423, positionTo = { x = 33835, y = 31635, z = 9 } },
}

local destination = { x = 33826, y = 31611, z = 9 }

local tileOne = { x = 33829, y = 31616, z = 9 }

local stepTile = MoveEvent()

function stepTile.onStepIn(player, item, frompos, item2, topos)
	local tiles = config[item.actionid]
	if not tiles then
		return true
	end

	local tile = Tile(tileOne):getItemById(416)
	if tiles.tileId == tile then
		player:teleportTo(tile.positionTo)
	else
		player:teleportTo(destination)
	end
	return false
end

stepTile:aid(57535, 57536, 57537, 57538)
stepTile:register()
