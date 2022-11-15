local setting = {
	[16772] = Position(32754, 32365, 15),
	[16773] = Position(32725, 32381, 15),
	[16774] = Position(32827, 32241, 12),
	[50082] = Position(32745, 32394, 14),
	[50083] = Position(32745, 32394, 14)
}

local bazirTile = MoveEvent()

function bazirTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPosition = setting[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	return true
end

bazirTile:type("stepin")

for index, value in pairs(setting) do
	bazirTile:aid(index)
end

bazirTile:register()
