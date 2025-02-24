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
	monsters = {
		{ name = "knowledge raider", pos = Position(32747, 32684, 10) },
		{ name = "knowledge raider", pos = Position(32755, 32684, 10) },
		{ name = "knowledge raider", pos = Position(32755, 32694, 10) },
		{ name = "knowledge raider", pos = Position(32747, 32694, 10) },
	},
	specPos = {
		from = Position(32742, 32681, 10),
		to = Position(32758, 32696, 10),
	},
	exit = Position(32466, 32654, 12),
}

local lever = BossLever(config)
lever:position(Position(32720, 32749, 10))
lever:register()
