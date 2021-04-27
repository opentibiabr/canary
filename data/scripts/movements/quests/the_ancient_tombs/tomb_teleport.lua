local config = {
	-- from Morguthis Boss
	[3950]  = {
		removeId = 2350,
		destination = Position(33182, 32714, 14),
		exitDestination = Position(33231, 32705, 8)
	},
	-- from Thalas Boss
	[3951]  = {
		removeId = 2351,
		destination = Position(33174, 32934, 15),
		exitDestination = Position(33282, 32744, 8)
	},
	-- from Mahrdis Boss
	[3952]  = {
		removeId = 2353,
		destination = Position(33126, 32591, 15),
		exitDestination = Position(33250, 32832, 8)
	},
	-- from Omruc Boss
	[3953]  = {
		removeId = 2352,
		destination = Position(33145, 32665, 15),
		exitDestination = Position(33025, 32868, 8)
	},
	-- from Rahemos Boss
	[3954]  = {
		removeId = 2348,
		destination = Position(33041, 32774, 14),
		exitDestination = Position(33133, 32642, 8)
	},
	-- from  Dipthrah Boss
	[3955]  = {
		removeId = 2354,
		destination = Position(33349, 32827, 14),
		exitDestination = Position(33131, 32566, 8)
	},
	-- from Vashresamun Boss
	[3956]  = {
		removeId = 2349,
		destination = Position(33186, 33012, 14),
		exitDestination = Position(33206, 32592, 8)
	}
}

local tombTeleport = MoveEvent()

function tombTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = config[item.uid]
	if not teleport then
		return true
	end

	if not player:removeItem(teleport.removeId, 1) then
		player:teleportTo(teleport.exitDestination)
		teleport.exitDestination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:teleportTo(teleport.destination)
	teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tombTeleport:type("stepin")

for index, value in pairs(config) do
	tombTeleport:uid(index)
end

tombTeleport:aid(12108)
tombTeleport:register()
