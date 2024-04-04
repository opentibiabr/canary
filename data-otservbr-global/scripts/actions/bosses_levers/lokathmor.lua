local config = {
	boss = {
		name = "Lokathmor",
		position = Position(32751, 32689, 10),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32721, 32749, 10), teleport = Position(32751, 32685, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32722, 32749, 10), teleport = Position(32751, 32685, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32723, 32749, 10), teleport = Position(32751, 32685, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32724, 32749, 10), teleport = Position(32751, 32685, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32725, 32749, 10), teleport = Position(32751, 32685, 10), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32742, 32681, 10),
		to = Position(32758, 32696, 10),
	},
	exit = Position(32466, 32654, 12),
}

local lever = BossLever(config)
lever:position({ x = 32720, y = 32749, z = 10 })
lever:register()
