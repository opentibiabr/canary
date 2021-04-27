local doorShive2 = Action()

function doorShive2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = player:getPosition()
	if position.x == toPosition.x then
		return false
	end

	toPosition.x = position.x > toPosition.x and toPosition.x - 1 or toPosition.x + 1
	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

doorShive2:id(14767, 14768, 14769, 14770, 14771)
doorShive2:register()
