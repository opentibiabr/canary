local setting = {
	[32672] = {
		pos = Position(32672, 32736, 11),
		effectTeleport = CONST_ME_TELEPORT,
		newPosition = Position(32480, 32597, 15),
	},
	[32480] = {
		pos = Position(32480, 32601, 15),
		effectTeleport = CONST_ME_TELEPORT,
		newPosition = Position(32674, 32738, 11),
	},
}
local library = MoveEvent()
function library.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for _, teleport in pairs(setting) do
		if teleport.pos == position then
			player:teleportTo(teleport.newPosition)
			fromPosition:sendMagicEffect(teleport.effectTeleport)
			teleport.newPosition:sendMagicEffect(teleport.effectTeleport)
			break
		end
	end
	return true
end

library:type("stepin")

for _, value in pairs(setting) do
	library:position(value.pos)
end

library:register()
