local positions = {
	{x = 32476, y = 31900, z = 4},
	{x = 32477, y = 31900, z = 4},
	{x = 32478, y = 31900, z = 4},
	{x = 32479, y = 31900, z = 4},
	{x = 32480, y = 31900, z = 4},
	{x = 32481, y = 31900, z = 4}
}

local fourFloorLever = Action()

function fourFloorLever.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local stairPosition = {x = 32476, y = 31904, z = 4}
	local stairId = 1386

	if item.itemid == 1945 then
		-- Check if have all items
		if Position(positions[1]):hasItem(2682)
		and Position(positions[2]):hasItem(2676)
		and Position(positions[3]):hasItem(2679)
		and Position(positions[4]):hasItem(2674)
		and Position(positions[5]):hasItem(2681)
		and Position(positions[6]):hasItem(2678) then
			-- If have all items, then remove it
			Position(positions[1]):removeItem(2682)
			Position(positions[2]):removeItem(2676)
			Position(positions[3]):removeItem(2679)
			Position(positions[4]):removeItem(2674)
			Position(positions[5]):removeItem(2681)
			Position(positions[6]):removeItem(2678)
			-- Create ladder
			Position(stairPosition):createItem(stairId)
			item:transform(1946)
		-- If not have all items, then send poff effect
		else
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.itemid == 1946 then
		-- Remove ladder
		if Position(stairPosition):hasItem(stairId) then
			Position(stairPosition):removeItem(stairId)
		end
		item:transform(1945)
	end
	return true
end

fourFloorLever:uid(30027)
fourFloorLever:register()
