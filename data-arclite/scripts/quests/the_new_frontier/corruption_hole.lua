local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local corruptionhole = MoveEvent()

function corruptionhole.onStepIn(player, item, position, fromPosition)
	if not player then
		return true
	end
	if player:getStorageValue(TheNewFrontier.CorruptionHole) < 1 then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

corruptionhole:position({x = 33345, y = 31116, z = 7})
corruptionhole:register()
