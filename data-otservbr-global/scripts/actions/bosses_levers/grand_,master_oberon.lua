local config = {
	boss = {
		name = "Grand Master Oberon",
		position = Position(33364, 31317, 9),
	},
	playerPositions = {
		{ pos = Position(33362, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33363, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33364, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33365, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33366, 31344, 9), teleport = Position(33364, 31322, 9) },
	},
	specPos = {
		from = Position(33357, 31312, 9),
		to = Position(33371, 31324, 9),
	},
	exit = Position(33364, 31341, 9),
}

local lever = BossLever(config)
lever:aid(57605)
lever:register()
