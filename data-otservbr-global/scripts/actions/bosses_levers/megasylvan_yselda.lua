local config = {
	boss = {
		name = "Megasylvan Yselda",
		position = Position(32619, 32493, 12),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32578, 32500, 12), teleport = Position(32619, 32498, 12) },
		{ pos = Position(32578, 32501, 12), teleport = Position(32619, 32498, 12) },
		{ pos = Position(32578, 32502, 12), teleport = Position(32619, 32498, 12) },
		{ pos = Position(32578, 32503, 12), teleport = Position(32619, 32498, 12) },
		{ pos = Position(32578, 32504, 12), teleport = Position(32619, 32498, 12) },
	},
	specPos = {
		from = Position(32601, 32486, 12),
		to = Position(32633, 32509, 12),
	},
	exit = Position(32580, 32480, 12),
}

local lever = BossLever(config)
lever:position({ x = 32578, y = 32499, z = 12 })
lever:register()
