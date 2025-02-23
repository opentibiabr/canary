local config = {
	boss = {
		name = "Tarbaz",
		position = Position(33459, 32844, 11),
	},

	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(33418, 32849, 11), teleport = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32850, 11), teleport = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32851, 11), teleport = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32852, 11), teleport = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32853, 11), teleport = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33447, 32832, 11),
		to = Position(33473, 32856, 11),
	},
	exit = Position(33319, 32318, 13),
}

local lever = BossLever(config)
lever:position(Position(33418, 32848, 11))
lever:register()
