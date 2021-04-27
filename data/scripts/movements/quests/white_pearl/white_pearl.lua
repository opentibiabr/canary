local setting = {
	[5630] = {
		teleportPosition = Position(33145, 32863, 7),
		effect = CONST_ME_MAGIC_GREEN,
		potPosition = Position(33151, 32864, 7)
	},
	[5631] = {
		teleportPosition = Position(33147, 32864, 7),
		effect = CONST_ME_MAGIC_GREEN
	}
}

local whitePearl = MoveEvent()

function whitePearl.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[item.actionid]
	if not teleport then
		return true
	end

	if teleport.potPosition then
		local potItem = Tile(Position(33145, 32862, 7)):getItemById(2562)
		if potItem then
			player:teleportTo(teleport.potPosition)
			teleport.potPosition:sendMagicEffect(teleport.effect)
			return true
		end
	end

	player:teleportTo(teleport.teleportPosition)
	teleport.teleportPosition:sendMagicEffect(teleport.effect)
	return true
end

whitePearl:type("stepin")

for index, value in pairs(setting) do
	whitePearl:aid(index)
end

whitePearl:register()
