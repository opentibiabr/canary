local positions = {
	{x = 33356, y = 31124, z = 7},
	{x = 33261, y = 31076, z = 8}
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	if creature:getStorageValue(Storage.ChildrenoftheRevolution.teleportAccess) == 1 then
		if creature:getPosition() == Position(positions[1]) then
			creature:teleportTo(Position(33261, 31077, 8))
			creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		else
			creature:teleportTo(Position(33356, 31126, 7))
			creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
	creature:teleportTo(fromPosition)
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for index, value in pairs(positions) do
	teleport:position(value)
end
teleport:register()
