local lairEntrance = Action()

function lairEntrance.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FirstDragon.AccessCave) <= 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not worthy to enter in The First Dragon's Lair yet.")
		return true
	end

	if item:getPosition() == Position(33047, 32712, 3) then
		player:teleportTo({x = 31994, y = 32391, z = 9})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	elseif item:getPosition() == Position(31994, 32390, 9) then
		player:teleportTo({x = 33047, y = 32713, z = 3})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	return false
end

lairEntrance:id(27828)
lairEntrance:register()
