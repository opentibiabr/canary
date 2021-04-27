local lastSealFlame = MoveEvent()

function lastSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FirstSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.SecondSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.ThirdSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FourthSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.SixthSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.LastSealDoor, -1)
	player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FinalBattle, 1)
	player:teleportTo({x = 32269, y = 31853, z = 15})
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

lastSealFlame:uid(35019)
lastSealFlame:type("stepin")
lastSealFlame:register()
