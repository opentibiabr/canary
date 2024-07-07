local positions = {
	{ x = 32563, y = 31957, z = 1 },
	{ x = 32565, y = 31957, z = 1 },
	{ x = 32567, y = 31957, z = 1 },
	{ x = 32569, y = 31957, z = 1 },
}

local sacrificeSkulls = MoveEvent()

function sacrificeSkulls.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for i = 1, #positions do
		local tile = Tile(positions[i])
		if not tile or not tile:getItemById(3114) then
			return true
		end
	end

	if player:getStorageValue(FirstParadoxAcess) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "One of the toxic salt seas in Krailos carries fresh and clean water again. The ogres' water supply is ensured for now")
		player:setStorageValue(FirstParadoxAcess, 1)
	end

	for i = 1, #positions do
		local skull = Tile(positions[i]):getItemById(3114)
		if skull then
			Game.createItem(105, 1, positions[i])
			skull:remove(1)
		end
	end

	player:teleportTo({ x = 32479, y = 31923, z = 7 })
	return true
end

sacrificeSkulls:uid(25012)
sacrificeSkulls:register()
