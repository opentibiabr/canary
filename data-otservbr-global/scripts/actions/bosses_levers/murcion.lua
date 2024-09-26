local config = {
	boss = {
		name = "Murcion",
		position = Position(33010, 32366, 15),
	},
	timeAfterKill = 60,
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(32978, 32365, 15), teleport = Position(33002, 32367, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32977, 32365, 15), teleport = Position(33002, 32367, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32976, 32365, 15), teleport = Position(33002, 32367, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32975, 32365, 15), teleport = Position(33002, 32367, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32974, 32365, 15), teleport = Position(33002, 32367, 15) ,effect = CONST_ME_TELEPORT },

	},
	specPos = {
		from = Position(32999, 32359, 15),
		to = Position(33019, 32376, 15),
	},
	exit = Position(33848, 31657, 13),
	exitTeleporter = Position(33009, 32374, 15),
}

local lever = BossLever(config)
lever:aid(54294)
lever:register()
