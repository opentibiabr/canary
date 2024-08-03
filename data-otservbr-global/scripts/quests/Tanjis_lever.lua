local config = {
	boss = {
		name = "Tanjis",
		position = Position(33639, 31241, 11)
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(33668, 31265, 11), teleport = Position(33649, 31250, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33668, 31266, 11), teleport = Position(33649, 31250, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33668, 31267, 11), teleport = Position(33649, 31250, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33668, 31268, 11), teleport = Position(33649, 31250, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33668, 31269, 11), teleport = Position(33649, 31250, 11), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33638, 31232, 11),
		to = Position(33647, 31255, 11)
	},
	exit = Position(33665, 31270, 11),
	storage = Storage.Quest.U12_30.FeasterOfSouls.TanjisTimer
}

local lever = BossLever(config)
lever:position({x = 33668, y = 31264, z = 11})
lever:register()
