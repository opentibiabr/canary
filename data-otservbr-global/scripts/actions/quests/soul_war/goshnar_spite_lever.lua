local config = {
	boss = {
		name = "Goshnar's Spite",
		position = Position(33743, 31632, 14),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(33774, 31634, 14), teleport = Position(33742, 31639, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33775, 31634, 14), teleport = Position(33742, 31639, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33776, 31634, 14), teleport = Position(33742, 31639, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33777, 31634, 14), teleport = Position(33742, 31639, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33778, 31634, 14), teleport = Position(33742, 31639, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33734, 31624, 14),
		to = Position(33751, 31640, 14),
	},
	exit = Position(33621, 31427, 10),
}

local lever = BossLever(config)
lever:position({ x = 33773, y = 31634, z = 14 })
lever:register()
