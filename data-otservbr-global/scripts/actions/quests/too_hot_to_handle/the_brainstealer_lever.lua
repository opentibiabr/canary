local config = {
	boss = {
		name = "The Brainstealer",
		position = Position(32499, 31124, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32530, 31122, 15), teleport = Position(32495, 31129, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32531, 31122, 15), teleport = Position(32495, 31129, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32532, 31122, 15), teleport = Position(32495, 31129, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32533, 31122, 15), teleport = Position(32495, 31129, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32534, 31122, 15), teleport = Position(32495, 31129, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32490, 31117, 15),
		to = Position(32506, 31132, 15),
	},
	exit = Position(32536, 31122, 15),
}

local lever = BossLever(config)
lever:position({ x = 32529, y = 31122, z = 15 })
lever:register()
