local config = {
	boss = {
		name = "Urmahlullu the Immaculate",
		position = Position(33918, 31641, 8),
	},
	requiredLevel = 100,
	playerPositions = {
		{ pos = Position(33918, 31626, 8), teleport = Position(33918, 31657, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(33919, 31626, 8), teleport = Position(33918, 31657, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(33920, 31626, 8), teleport = Position(33918, 31657, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(33921, 31626, 8), teleport = Position(33918, 31657, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(33922, 31626, 8), teleport = Position(33918, 31657, 8), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33905, 31636, 8),
		to = Position(33932, 31667, 8),
	},
	exit = Position(33919, 31603, 8),
}

local lever = BossLever(config)
lever:uid(9545)
lever:register()
