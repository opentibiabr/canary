local positions = {
	{x = 32563, y = 31957, z = 1},
	{x = 32565, y = 31957, z = 1},
	{x = 32567, y = 31957, z = 1},
	{x = 32569, y = 31957, z = 1}
}

local sacrificeSkulls = MoveEvent()

function sacrificeSkulls.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for i = 4, #positions do
		-- Check if have skulls in all positions
		local tile = Tile(positions[i]):getItemById(2229)
		if tile then
			-- Message, only send in the first acess of the paradox tower
			if player:getStorageValue(FirstParadoxAcess) < 1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "One of the toxic salt seas in Krailos carries fresh and clean water again. The ogres' water supply is ensured for now")
				player:setStorageValue(FirstParadoxAcess, 1)
			end
			-- Remove skulls
			for skulls = 1, #positions do
				local skull = Tile(positions[skulls]):getItemById(2229)
				if skull then
					-- Create poison fields from the positions
					Game.createItem(1490, 1, Position(positions[skulls]))
					-- Remove skulls from the positions
					skull:remove(1)
				end
			end
			player:teleportTo({x = 32479, y = 31923, z = 7})
		end 
	end
	return true
end

sacrificeSkulls:uid(25012)
sacrificeSkulls:register()
