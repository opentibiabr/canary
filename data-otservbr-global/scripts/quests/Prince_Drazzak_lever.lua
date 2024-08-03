local config = {
	boss = {
		name = "The Percht Queen",
		position = Position(33758, 31061, 9),
	},
	requiredLevel = 150,
	playerPositions = {
		{ pos = Position(33790, 31098, 9), teleport = Position(33758, 31073, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(33790, 31099, 9), teleport = Position(33758, 31073, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(33790, 31100, 9), teleport = Position(33758, 31073, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(33790, 31101, 9), teleport = Position(33758, 31073, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(33790, 31102, 9), teleport = Position(33758, 31073, 9), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33756, 31049, 9),
		to = Position(33757, 31077, 9),
	},
	exit = Position(33790, 31104, 9),
}

local lever = BossLever(config)
lever:position(Position(33790, 31097, 9))
lever:register()
