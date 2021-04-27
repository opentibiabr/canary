local config = {
	{leverPosition = Position(32802, 31584, 1), leverId = 1945},
	{leverPosition = Position(32803, 31584, 1), leverId = 1946},
	{leverPosition = Position(32804, 31584, 1), leverId = 1945},
	{leverPosition = Position(32805, 31584, 1), leverId = 1946}
}

local exitTeleport = MoveEvent()

function exitTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local correct, leverItem = true
	for i = 1, #config do
		leverItem = Tile(config[i].leverPosition):getItemById(config[i].leverId)
		if not leverItem then
			correct = false
			break
		end
	end

	if not correct then
		player:teleportTo({x = 32803, y = 31587, z = 1})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:teleportTo({x = 32701, y = 31639, z = 6})
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

exitTeleport:uid(35011)
exitTeleport:register()
