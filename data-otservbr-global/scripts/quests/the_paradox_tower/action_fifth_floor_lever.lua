local positions = {
	{ x = 32478, y = 31903, z = 3 },
	{ x = 32479, y = 31903, z = 3 },
}

local fifthFloorLever = Action()

function fifthFloorLever.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local stairPosition = { x = 32479, y = 31904, z = 3 }
	local stairId = 1948

	if item.itemid == 2772 then
		-- Check if have all items
		if Position(positions[1]):hasItem(3537) and Position(positions[2]):hasItem(3543) then
			-- If have all items, then remove it
			Position(positions[1]):removeItem(3537)
			Position(positions[2]):removeItem(3543)
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

fifthFloorLever:uid(30028)
fifthFloorLever:register()
