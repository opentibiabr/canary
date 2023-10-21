local config = {
	boss = {
		name = "Ghulosh",
		position = Position(32756, 32720, 10),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(32747, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32748, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32749, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32750, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32751, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32748, 32713, 10),
		to = Position(32763, 32729, 10),
	},
	exit = Position(32660, 32713, 13),
	storage = Storage.Quest.U11_80.TheSecretLibrary.GhuloshTimer,
}

local lever = BossLever(config)
lever:position({ x = 32746, y = 32773, z = 10 })
lever:register()
