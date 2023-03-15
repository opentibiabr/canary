local teleports = {
	{
		access = Storage.Quest.U12_00.TheDreamCourts.BuriedCathedralAccess,
		teleportA = { x = 32720, y = 32270, z = 8 },
		destinationA = { x = 32720, y = 32269, z = 8 },
		teleportB = { x = 33618, y = 32546, z = 13 },
		destinationB = { x = 33618, y = 32545, z = 13 }
	}
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	for index, teleport in pairs(teleports) do
		if creature:getStorageValue(teleport.access) == 1 then
			if creature:getPosition() == Position(teleport.teleportA) then
				creature:teleportTo(Position(teleport.destinationB))
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			elseif creature:getPosition() == Position(teleport.teleportB) then
				creature:teleportTo(Position(teleport.destinationA))
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
		end
	end

	creature:teleportTo(fromPosition)
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for index, value in pairs(teleports) do
	teleport:position(value.teleportA)
	teleport:position(value.teleportB)
end
teleport:register()
