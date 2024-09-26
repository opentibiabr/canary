local config = {
	boss = {
		name = "Chagorz",
		position = Position(33043, 32366, 15),
	},
	timeAfterKill = 60,
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(33078, 32367, 15), teleport = Position(33037, 32365, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33077, 32367, 15), teleport = Position(33037, 32365, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33076, 32367, 15), teleport = Position(33037, 32365, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33075, 32367, 15), teleport = Position(33037, 32365, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33074, 32367, 15), teleport = Position(33037, 32365, 15) ,effect = CONST_ME_TELEPORT },


	},
	specPos = {
		from = Position(33033, 32358, 15),
		to = Position(33054, 32376, 15),
	},
	exit = Position(33814, 31821, 13),
	exitTeleporter = Position(33044, 32375, 15),
}

local lever = BossLever(config)
lever:aid(54295)
lever:register()
