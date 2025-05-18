local config = {
	boss = {
		name = "Earl Osam",
		position = Position(33488, 31441, 13),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33516, 31444, 13), teleport = Position(33488, 31430, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33517, 31444, 13), teleport = Position(33488, 31430, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33518, 31444, 13), teleport = Position(33488, 31430, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33519, 31444, 13), teleport = Position(33488, 31430, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33520, 31444, 13), teleport = Position(33488, 31430, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33479, 31429, 13),
		to = Position(33497, 31446, 13),
	},
	exit = Position(33261, 31986, 8),
}

local lever = BossLever(config)
lever:position(Position(33515, 31444, 13))
lever:register()
