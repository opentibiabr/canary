local config = {
	{position = Position(32836, 32288, 14), itemId = 1387, transformId = 6299},
	{position = Position(32836, 32278, 14), itemId = 1946, transformId = 1945},
	{position = Position(32834, 32285, 14), itemId = 1946, transformId = 1945}
}

local tokens = {
	{position = Position(32845, 32264, 14), itemId = 2639},
	{position = Position(32843, 32266, 14), itemId = 2639},
	{position = Position(32843, 32268, 14), itemId = 2639},
	{position = Position(32845, 32268, 14), itemId = 2639},
	{position = Position(32844, 32267, 14), itemId = 2639},
	{position = Position(32840, 32269, 14), itemId = 2639},
	{position = Position(32841, 32269, 14), itemId = 2638},
	{position = Position(32840, 32268, 14), itemId = 2638},
	{position = Position(32842, 32267, 14), itemId = 2638}
}

local ticTeleport = MoveEvent()

function ticTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local thing
	for i = 1, #config do
		thing = Tile(config[i].position):getItemById(config[i].itemId)
		if thing then
			thing:transform(config[i].transformId)
		end
	end

	local token
	for i = 1, #tokens do
		token = Tile(tokens[i].position):getItemById(tokens[i].itemId)
		if token then
			token:remove()
		end
	end

	player:teleportTo(Position(32874, 32275, 14))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

ticTeleport:type("stepin")
ticTeleport:aid(9032)
ticTeleport:register()
