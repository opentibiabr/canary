local firstSealFlame = MoveEvent()

function firstSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FirstSeal) < 1 then
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FirstSeal, 1)
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.FirstSealDoor, 1)
		player:teleportTo({x = 32266, y = 31849, z = 15})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		Game.createMonster('ghost', Position(32276, 31902, 13), false, true)
		Game.createMonster('ghost', Position(32274, 31902, 13), false, true)
		Game.createMonster('demon skeleton', Position(32276, 31904, 13), false, true)
	else
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

firstSealFlame:uid(35013)
firstSealFlame:register()
