local UniqueTable = {
	-- Tazhadur exit
	[35005] = {
		backPos  = {x = 33234, y = 32278, z = 12}
	},
	-- Kalyassa exit
	[35006] = {
		backPos  = {x = 33162, y = 31320, z = 5}
	},
	-- Zorvorax exit
	[35007] = {
		backPos  = {x = 33002, y = 31595, z = 11}
	},
	-- Gelidrazah exit
	[35008] = {
		backPos  = {x = 32278, y = 31367, z = 4}
	}
}

local exitTeleport = MoveEvent()
function exitTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = UniqueTable[item.uid]
	if not setting then
		return true
	end
	player:teleportTo(setting.backPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for index, value in pairs(UniqueTable) do
	exitTeleport:uid(index)
end

exitTeleport:register()
