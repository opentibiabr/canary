local config = {
	boss = {
		name = "Ichgahal",
		position = Position(33008, 32332, 15),
	},
	timeAfterKill = 60,
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(32978, 32333, 15), teleport = Position(33003, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32977, 32333, 15), teleport = Position(33003, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32976, 32333, 15), teleport = Position(33003, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32975, 32333, 15), teleport = Position(33003, 32335, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32974, 32333, 15), teleport = Position(33003, 32335, 15) ,effect = CONST_ME_TELEPORT },




	},
	specPos = {
		from = Position(32998, 32326, 15),
		to = Position(33017, 32343, 15),
	},
	exit = Position(34099, 31681, 13),
	exitTeleporter = Position(33004, 32343, 15),
}

local lever = BossLever(config)
lever:aid(54297)
lever:register()
