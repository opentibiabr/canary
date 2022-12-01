local tpPos = {
	{x = 33004, y = 31540, z = 0},
	{x = 33005, y = 31540, z = 0}
}

local destination = Position(33197, 31347, 6)
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local teleport = MoveEvent()


function teleport.onStepIn(player, item, position, fromPosition)
	if not player then
		return true
	end
	if player:getStorageValue(TheNewFrontier.SnakeHeadTeleport) == 1 then
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

for a = 1, #tpPos do
	teleport:position(tpPos[a])
end
teleport:register()
