local teleports = {
	[2250] = {x = 32915, y = 32263, z = 14},
	[2251] = {x = 32946, y = 32270, z = 13},
	[2252] = {x = 32976, y = 32270, z = 14},
	[2253] = {x = 32933, y = 32282, z = 13},
	[2254] = {x = 32753, y = 32344, z = 14},
	[2255] = {x = 32753, y = 32344, z = 14}
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(Position(teleports[item.uid]))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleport:type("stepin")

for index, value in pairs(teleports) do
	teleport:uid(index)
end

teleport:register()
