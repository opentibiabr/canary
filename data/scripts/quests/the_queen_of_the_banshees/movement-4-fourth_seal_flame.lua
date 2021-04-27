local fourthSealFlame = MoveEvent()

function fourthSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FourthSeal) >= 1 then
		player:teleportTo(fromPosition, true)
		return true
	end

	local bloodPos = {x = 32243, y = 31892, z = 14}
	local tile = Tile(bloodPos)
	if tile then
		local bloodItem = tile:getItemById(2016, 2)
		if not bloodItem then
			player:teleportTo(fromPosition, true)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
		bloodItem:remove()
	end

	Position(bloodPos):sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FourthSeal, 1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FourthSealDoor, 1)
	player:teleportTo({x = 32261, y = 31849, z = 15})
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

fourthSealFlame:type("stepin")
fourthSealFlame:uid(35016)
fourthSealFlame:register()
