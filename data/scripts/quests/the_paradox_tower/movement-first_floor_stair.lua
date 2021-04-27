local positions = {
	{x = 32478, y = 31920, z = 7},
	{x = 32479, y = 31920, z = 7},
	{x = 32478, y = 31921, z = 7},
	{x = 32479, y = 31921, z = 7},
	{x = 32478, y = 31922, z = 7},
	{x = 32479, y = 31922, z = 7},
}

local firstFloorStair = MoveEvent()

function firstFloorStair.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local jungleGrassId = 2782
	local stairPosition = {x = 32478, y = 31902, z = 7}
	local stairId = 1385
	local stoneId = 1304

	-- Create stair
	-- The stair is only created if all the jungles of the "position" variable (line 1) are growing again
	if item.uid == 25013 then
		-- Checks if all jungle glass are in the positions
		if Position(positions[1]):hasItem(jungleGrassId)
		and Position(positions[2]):hasItem(jungleGrassId)
		and Position(positions[3]):hasItem(jungleGrassId)
		and Position(positions[4]):hasItem(jungleGrassId)
		and Position(positions[5]):hasItem(jungleGrassId)
		and Position(positions[6]):hasItem(jungleGrassId) then
			-- If all the jungles are growing again, then he turns the stone on the stairs
			Position(stairPosition):transformItem(stoneId, stairId, CONST_ME_POFF)
		end
	-- Remove stair if exit of the tower
	elseif table.contains({25014, 25015}, item.uid) then
		-- Checks whether the item in position is the stair
		if Position(stairPosition):hasItem(stairId) then
			Position(stairPosition):transformItem(stairId, stoneId, CONST_ME_POFF)
		end
	end
	return true
end

firstFloorStair:uid(25013, 25014, 25015)
firstFloorStair:register()
