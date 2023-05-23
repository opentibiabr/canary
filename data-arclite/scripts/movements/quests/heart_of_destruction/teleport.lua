local setting = {
	[48060] = Position(32017, 31357, 11), -- from edron
	[48061] = Position(33183, 31643, 8), -- to edron
	[48062] = Position(32522, 32020, 8), -- to kazz
	[48063] = Position(32448, 32389, 10), -- from kazz
	[48064] = Position(33158, 32636, 8), -- to ankrah
	[48065] = Position(32130, 31359, 12), -- from ankrah
	[48066] = Position(32159, 31294, 7), -- to svargrond
	[48067] = Position(32113, 31386, 11), -- from svargrond
	[48068] = Position(33026, 31367, 8), -- to farmine
	[48069] = Position(32117, 31355, 13) -- from farmine
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPosition = setting[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleport:type("stepin")

for index, value in pairs(setting) do
	teleport:aid(index)
end

teleport:register()
