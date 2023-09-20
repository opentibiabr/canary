local config = {
	{ position = Position(32873, 32263, 14), itemId = 2773, transformId = 2772 },
	{ position = Position(32874, 32263, 14), itemId = 2098, transformId = 2094 },
	{ position = Position(32875, 32263, 14), itemId = 2099, transformId = 2095 },
	{ position = Position(32874, 32264, 14), itemId = 2100, transformId = 2096 },
	{ position = Position(32875, 32264, 14), itemId = 2101, transformId = 2097 },
}

local stoneTeleport = MoveEvent()

function stoneTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(Position(32920, 32296, 13))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	item:transform(1842)

	local thing
	for i = 1, #config do
		thing = Tile(config[i].position):getItemById(config[i].itemId)
		if thing then
			thing:transform(config[i].transformId)
		end
	end
	return true
end

stoneTeleport:type("stepin")
stoneTeleport:position(Position(32881, 32270, 14))
stoneTeleport:register()
