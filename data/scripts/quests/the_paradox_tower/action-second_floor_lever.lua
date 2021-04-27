local positions = {
	{x = 32476, y = 31900, z = 6},
	{x = 32477, y = 31900, z = 6},
	{x = 32478, y = 31900, z = 6},
	{x = 32479, y = 31900, z = 6},
	{x = 32480, y = 31900, z = 6},
	{x = 32481, y = 31900, z = 6}
}

local secondFloorLever = Action()

function secondFloorLever.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local stairPosition = {x = 32476, y = 31904, z = 6}
	local stairId = 1386

	-- Create stair
	-- The stair is only created if all the jungles of the "position" variable (line 1) are growing again
	if item.itemid == 1945 then
		-- Checks if all levers glass are in the correct positions
		if Position(positions[1]):hasItem(1946)
		and Position(positions[2]):hasItem(1946)
		and Position(positions[3]):hasItem(1945)
		and Position(positions[4]):hasItem(1945)
		and Position(positions[5]):hasItem(1946)
		and Position(positions[6]):hasItem(1945) then
			-- If all the jungles are growing again, then he turns the stone on the stairs
			Position(stairPosition):createItem(stairId)
			item:transform(1946)
		else
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.itemid == 1946 then
		if Position(stairPosition):hasItem(stairId) then
			Position(stairPosition):removeItem(stairId)
		end
		item:transform(1945)
	end
	return true
end

secondFloorLever:uid(25016)
secondFloorLever:register()
