local mathCount = 0

local positions = {}

local function createVortex()
	local storedPositions = {
		{x = 32264, y = 31253, z = 14},
		{x = 32269, y = 31258, z = 14},
		{x = 32275, y = 31255, z = 14},
		{x = 32280, y = 31253, z = 14},
		{x = 32271, y = 31248, z = 14},
		{x = 32264, y = 31245, z = 14},
		{x = 32270, y = 31240, z = 14},
		{x = 32269, y = 31253, z = 14},
		{x = 32275, y = 31245, z = 14},
		{x = 32276, y = 31250, z = 14},
		{x = 32266, y = 31249, z = 14},
	}

	if mathCount == 0 then
		positions = storedPositions
	end

	local r1 = math.random(#positions)

	local tile = Tile(positions[r1])

	if tile then
		local ground = tile:getGround()
		if ground then
			ground:transform(25550)
		    addEvent(function()
			ground:transform(25705)
			end, 10*1000) -- 10*1000 = 10 SECONDS
			mathCount = mathCount + 1
			table.remove(positions, r1)
		end
	end

	if mathCount == 11 then
		mathCount = 0
	end
end

function onCastSpell(creature, var)
	createVortex()
end
