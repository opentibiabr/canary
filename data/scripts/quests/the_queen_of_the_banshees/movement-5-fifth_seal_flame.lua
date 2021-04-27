local fifthSealFlame = MoveEvent()

function fifthSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSeal) ~= 1
					and player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSealTile) == 9 then
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSealTile, 1)
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSeal, 1)
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSealDoor, 1)
		player:teleportTo({x = 32268, y = 31856, z = 15})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo({x = 32185, y = 31939, z = 14})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

fifthSealFlame:uid(35017)
fifthSealFlame:register()
