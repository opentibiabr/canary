local destination = {
	[64017] = Position(32881, 32474, 9), --Entrance
	[64018] = Position(32870, 32510, 7) --Exit
}

local portHopeDeathling = MoveEvent()

function portHopeDeathling.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = destination[item.actionid]
	if teleport then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		teleport:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

portHopeDeathling:type("stepin")

for index, value in pairs(destination) do
	portHopeDeathling:aid(index)
end

portHopeDeathling:register()
