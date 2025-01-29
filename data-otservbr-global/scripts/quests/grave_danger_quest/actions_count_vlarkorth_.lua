local config = {
	boss = {
		name = "Count Vlarkorth",
		position = Position(33456, 31434, 13),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33455, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33456, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33457, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33458, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33459, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33448, 31428, 13),
		to = Position(33464, 31446, 13),
	},
	exit = Position(33195, 31690, 8),
}

local lever = BossLever(config)
lever:position(Position(33454, 31413, 13))
lever:register()
