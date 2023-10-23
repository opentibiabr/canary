local config = {
	boss = {
		name = "Goshnar's Cruelty",
		position = Position(33856, 31866, 7),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(33854, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(33855, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(33856, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(33857, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(33858, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33847, 31858, 7),
		to = Position(33864, 31874, 7),
	},
	exit = Position(33621, 31427, 10),
}

local lever = BossLever(config)
lever:position({ x = 33853, y = 31854, z = 6 })
lever:register()
