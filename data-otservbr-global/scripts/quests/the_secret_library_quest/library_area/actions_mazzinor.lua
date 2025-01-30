local config = {
	boss = {
		name = "Mazzinor",
		position = Position(32725, 32719, 10),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32721, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32722, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32723, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32724, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32725, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "wild knowledge", pos = Position(32719, 32718, 10) },
		{ name = "wild knowledge", pos = Position(32723, 32719, 10) },
		{ name = "wild knowledge", pos = Position(32728, 32718, 10) },
		{ name = "wild knowledge", pos = Position(32724, 32724, 10) },
	},
	specPos = {
		from = Position(32716, 32713, 10),
		to = Position(32732, 32728, 10),
	},
	exit = Position(32616, 32531, 13),
}

local lever = BossLever(config)
lever:position(Position(32720, 32773, 10))
lever:register()
