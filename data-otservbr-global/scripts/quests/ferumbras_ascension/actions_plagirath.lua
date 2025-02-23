local config = {
	boss = {
		name = "Plagirath",
		position = Position(33172, 31501, 13),
	},

	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(33229, 31500, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31501, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31502, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31503, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31504, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33159, 31488, 13),
		to = Position(33190, 31515, 13),
	},
	exit = Position(33319, 32318, 13),
}

local lever = BossLever(config)
lever:position(Position(33229, 31499, 13))
lever:register()
