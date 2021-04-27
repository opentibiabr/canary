local targetDestination = {
	Position(32659, 31853, 13),
	Position(32646, 31903, 3)
}

local whatFoolishWatch = Action()
function whatFoolishWatch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.WhatAFoolish.Questline) ~= 11 then
		return false
	end

	local playerPos = player:getPosition()
	if not isInArray(targetDestination, playerPos) then
		return false
	end

	local destination = playerPos == targetDestination[2] and targetDestination[1] or targetDestination[2]
	if destination.z == 6 then
		item:remove()
	end

	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	player:say('You are travelling in time', TALKTYPE_MONSTER_SAY)
	return true
end

whatFoolishWatch:id(8187)
whatFoolishWatch:register()