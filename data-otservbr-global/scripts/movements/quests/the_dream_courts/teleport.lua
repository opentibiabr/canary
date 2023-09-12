local teleports = {
	{
		access = Storage.Quest.U12_00.TheDreamCourts.BuriedCathedralAccess,
		from = { x = 32720, y = 32270, z = 8 }, -- Haunted house cellar
		to = { x = 33618, y = 32545, z = 13 }, -- Buried Cathedral
	},
	{
		access = Storage.Quest.U12_00.TheDreamCourts.BuriedCathedralAccess,
		from = { x = 33618, y = 32546, z = 13 }, -- Buried Cathedral
		to = { x = 32720, y = 32269, z = 8 }, -- Haunted house cellar
	},
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local teleportTo = fromPosition
	for index, teleportItem in pairs(teleports) do
		if creature:getStorageValue(teleportItem.access) == 1 then
			if creature:getPosition() == Position(teleportItem.from) then
				teleportTo = teleportItem.to
				break
			end
		end
	end

	creature:teleportTo(teleportTo)
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for index, teleportItem in pairs(teleports) do
	teleport:position(teleportItem.from)
end
teleport:register()
