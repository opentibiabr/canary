local config = {
	boss = {
		name = "Gorzindel",
		position = Position(32687, 32715, 10),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(32747, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32748, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32749, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32750, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32751, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32680, 32711, 10),
		to = Position(32695, 32726, 10),
	},
	exit = Position(32660, 32734, 12),
	storage = Storage.Quest.U11_80.TheSecretLibrary.GorzindelTimer,
}

local lever = BossLever(config)
lever:position({ x = 32746, y = 32749, z = 10 })
lever:register()
