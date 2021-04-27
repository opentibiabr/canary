local secondSealFlame = MoveEvent()

function secondSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.SecondSeal) < 1 then
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.SecondSeal, 1)
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.SecondSealDoor, 1)
		player:teleportTo(Position(32272, 31849, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

secondSealFlame:uid(35014)
secondSealFlame:type("stepin")
secondSealFlame:register()
