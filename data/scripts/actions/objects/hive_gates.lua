local hiveGates = Action()

function hiveGates.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = player:getPosition()
	if item:getId() == 13278 or item:getId() == 13279 or item:getId() == 13280 or item:getId() == 13281 or item:getId() == 13282 or item:getId() == 13283 then
		if position.y == toPosition.y then
			return false
		end

		toPosition.y = position.y > toPosition.y and toPosition.y - 1 or toPosition.y + 1
	elseif item:getId() == 13290 or item:getId() == 13291 or item:getId() == 13292 or item:getId() == 13293 or item:getId() == 13294 then
		if position.x == toPosition.x then
			return false
		end

		toPosition.x = position.x > toPosition.x and toPosition.x - 1 or toPosition.x + 1
	end

	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

hiveGates:id(13278, 13279, 13280, 13281, 13282, 13283, 13290, 13291, 13292, 13293, 13294)
hiveGates:register()
