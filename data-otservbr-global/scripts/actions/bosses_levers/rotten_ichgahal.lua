local config = {
	boss = {
		name = "Ichgahal",
		position = Position(33008, 32333, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32978, 32333, 15), teleport = Position(33004, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32977, 32333, 15), teleport = Position(33004, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32976, 32333, 15), teleport = Position(33004, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32975, 32333, 15), teleport = Position(33004, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32974, 32333, 15), teleport = Position(33004, 32341, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32998, 32326, 15),
		to = Position(33018, 32343, 15),
	},
	exit = Position(33004, 32343, 15),
}

local lever = BossLever(config)
lever:position(Position(32979, 32333, 15))
lever:register()
