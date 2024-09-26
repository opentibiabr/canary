local config = {
	boss = {
		name = "Vemiath",
		position = Position(33042, 32335, 15),
	},
	timeAfterKill = 60,
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(33078, 32333, 15), teleport = Position(33037, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33077, 32333, 15), teleport = Position(33037, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33076, 32333, 15), teleport = Position(33037, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33075, 32333, 15), teleport = Position(33037, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33074, 32333, 15), teleport = Position(33037, 32335, 15) ,effect = CONST_ME_TELEPORT },



	},
	specPos = {
		from = Position(33034, 32327, 15),
		to = Position(33053, 32345, 15),
	},
	exit = Position(34116, 31882, 14),
	exitTeleporter = Position(33043, 32344, 15),
}

local lever = BossLever(config)
lever:aid(54296)
lever:register()
