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
	local stairId = 1948

	if item.itemid == 2772 then
		-- Check if have all items
		if Position(positions[1]):hasItem(3593)
		and Position(positions[2]):hasItem(3587)
		and Position(positions[3]):hasItem(3590)
		and Position(positions[4]):hasItem(3585)
		and Position(positions[5]):hasItem(3592)
		and Position(positions[6]):hasItem(3589) then
			-- If have all items, then remove it
			Position(positions[1]):removeItem(3593)
			Position(positions[2]):removeItem(3587)
			Position(positions[3]):removeItem(3590)
			Position(positions[4]):removeItem(3585)
			Position(positions[5]):removeItem(3592)
			Position(positions[6]):removeItem(3589)
			-- Create ladder
			Position(stairPosition):createItem(stairId)
			item:transform(2773)
		-- If not have all items, then send poff effect
		else
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.itemid == 2773 then
		-- Remove ladder
		if Position(stairPosition):hasItem(stairId) then
			Position(stairPosition):removeItem(stairId)
		end
		item:transform(2772)
	end
	return true
end

fourFloorLever:uid(30027)
fourFloorLever:register()
