local magicDoor = Action()

function magicDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerPos, destination = player:getPosition()
	if item.itemid == 17318 then
		player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.MagicDoor, 1)
		destination = Position(32292, 32293, 7)
	else
		if player:getStorageValue(Storage.Quest.U9_80.AdventurersGuild.MagicDoor) == 1 then
			player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.MagicDoor, -1)
			destination = Position(32199, 32309, 7)
		elseif playerPos.x == 32293 then
			destination = Position(32297, 32293, 7)
		else
			destination = Position(32292, 32293, 7)
		end
	end
	player:teleportTo(destination)
	playerPos:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

magicDoor:id(17318, 17319)
magicDoor:register()
