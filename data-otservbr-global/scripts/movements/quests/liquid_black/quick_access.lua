local enterPosition = {x = 33446, y = 31288, z = 14}

local quickAccess = MoveEvent()

function quickAccess.onStepIn(creature, item, toPosition, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.LiquidBlackQuest.Visitor) >= 5 then
		player:teleportTo(enterPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

quickAccess:aid(57747)
quickAccess:register()
