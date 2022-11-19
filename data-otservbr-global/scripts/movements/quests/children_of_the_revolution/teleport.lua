local positions = {
	{x = 33356, y = 31124, z = 7},
	{x = 33261, y = 31076, z = 8}
}

local teleport = MoveEvent()

function teleport.onStepIn(player, item, position, fromPosition)
	if not player then
		return true
	end
	if player:getStorageValue(Storage.ChildrenoftheRevolution.teleportAccess) == 1 then
		if player:getPosition() == Position(positions[1]) then
			player:teleportTo(Position(33261, 31077, 8))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(Position(33356, 31126, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	else
		player:teleportTo(position)
		position:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

for index, value in pairs(positions) do
	teleport:position(value)
end
teleport:register()
