local config = {
	boss = {
		name = "King Zelos",
		position = Position(33443, 31545, 13),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33485, 31546, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31547, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31548, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31545, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31544, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31546, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31547, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31548, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31545, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31544, 13), teleport = Position(33443, 31554, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33433, 31535, 13),
		to = Position(33453, 31555, 13),
	},
	exit = Position(32172, 31918, 8),
}

local lever = BossLever(config)
lever:position(Position(33484, 31546, 13))
lever:register()
