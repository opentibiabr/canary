local config = {
	boss = {
		name = "Razzagorn",
		position = Position(33422, 32467, 14),
	},

	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(33386, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33387, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33388, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33389, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33390, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33407, 32453, 14),
		to = Position(33439, 32481, 14),
	},
	exit = Position(33319, 32318, 13),
}

local lever = BossLever(config)
lever:position(Position(33385, 32455, 14))
lever:register()
