local config = {
	boss = {
		name = "Mazoran",
		position = Position(33584, 32689, 14),
	},

	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(33593, 32644, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32645, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32646, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32647, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32648, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33570, 32677, 14),
		to = Position(33597, 32700, 14),
	},
	exit = Position(33319, 32318, 13),
}

local lever = BossLever(config)
lever:position(Position(33593, 32643, 14))
lever:register()
