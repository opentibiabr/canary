local config = {
	[57535] = {active = 57535, tileId = 413, positionto = {x = 33829, y = 31635, z = 9}},
	[57536] = {active = 57536, tileId = 414, positionto = {x = 33831, y = 31635, z = 9}},
	[57537] = {active = 57537, tileId = 415, positionto = {x = 33833, y = 31635, z = 9}},
	[57538] = {active = 57538, tileId = 420, positionto = {x = 33835, y = 31635, z = 9}}
}

local errotp = {x = 33826, y = 31611, z = 9}

local pegapisoum = {x = 33829, y = 31616, z = 9}


local pisatile = MoveEvent()

function pisatile.onStepIn(player, item, frompos, item2, topos)
	
	local tilescon = config[item.actionid]
	if not tilescon then
		return true
	end
	
	
	local idpegapisoum = Tile(pegapisoum):getItemById(413) -- verifica primeiro piso
	

	

	if tilescon.tileId == idpegapisoum then
		
	else
		player:teleportTo(errotp)
	end
	




	
	
	return true
end

pisatile:aid(57535, 57536, 57537, 57538)
pisatile:register()