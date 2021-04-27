local flameSixthSeal = MoveEvent()

function flameSixthSeal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.SixthSeal) >= 1 then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	for i = 1, #sixthSealTable.positions do
		local tile = Tile(sixthSealTable.positions[i].position)
		if tile then
			local campfireItem = tile:getItemById(sixthSealTable.positions[i].campfireId)
			if not campfireItem then
				player:teleportTo(fromPosition)
				fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
		end
	end

	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.SixthSeal, 1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.SixthSealDoor, 1)
	player:teleportTo({x = 32261, y = 31856, z = 15})
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

flameSixthSeal:uid(35018)
flameSixthSeal:register()
