local config = {
	boss = {
		name = "Prince Drazzak",
		position = Position(33608, 32422, 12),
	},
	requiredLevel = 150,
	playerPositions = {
		{ pos = Position(33607, 32362, 11), teleport = Position(33601, 32428, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(33608, 32362, 11), teleport = Position(33601, 32428, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(33609, 32362, 11), teleport = Position(33601, 32428, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(33610, 32362, 11), teleport = Position(33601, 32428, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(33611, 32362, 11), teleport = Position(33601, 32428, 12), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33606, 32413, 12),
		to = Position(33607, 32430, 12),
	},
	exit = Position(33604, 32370, 11),
}

local lever = BossLever(config)
lever:position(Position(33606, 32362, 11))
lever:register()
