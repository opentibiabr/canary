local config = {
	boss = {
		name = "Duke Krule",
		position = Position(33456, 31473, 13),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33455, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33456, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33457, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33458, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33459, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33447, 31464, 13),
		to = Position(33464, 31481, 13),
	},
	exit = Position(32347, 32167, 12),
}

local lever = BossLever(config)
lever:position(Position(33454, 31493, 13))
lever:register()
