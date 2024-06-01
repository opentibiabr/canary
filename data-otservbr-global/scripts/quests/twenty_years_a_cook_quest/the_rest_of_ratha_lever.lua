local config = {
	boss = {
		name = "The Rest of Ratha",
		position = Position(33309, 31391, 15),
	},
	timeToDefeat = 10 * 60, -- 10 minutes
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32585, 31939, 5), teleport = Position(33319, 31406, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32586, 31939, 5), teleport = Position(33319, 31406, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32587, 31939, 5), teleport = Position(33319, 31406, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32588, 31939, 5), teleport = Position(33319, 31406, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32584, 31939, 5), teleport = Position(33319, 31406, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33303, 31388, 15),
		to = Position(33327, 31408, 15),
	},
	monsters = {
		{ name = "Spirit Container", pos = Position(33325, 31407, 15) },
		{ name = "Ghost Duster", pos = Position(33323, 31407, 15) },
	},
	exit = Position(32586, 31937, 5),
}

local lever = BossLever(config)
lever:uid(62133)
lever:register()
