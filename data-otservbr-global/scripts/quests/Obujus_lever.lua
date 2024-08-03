local config = {
	boss = {
		name = "Obujos",
		position = Position(33421, 31264, 11)
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(33454, 31301, 11), teleport = Position(33430, 31274, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33454, 31302, 11), teleport = Position(33430, 31274, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33454, 31303, 11), teleport = Position(33430, 31274, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33454, 31304, 11), teleport = Position(33430, 31274, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33454, 31305, 11), teleport = Position(33430, 31274, 11), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33423, 31254, 11),
		to = Position(33431, 31274, 11)
	},
	exit = Position(33451, 31306, 11),
	storage = Storage.Quest.U12_30.FeasterOfSouls.ObujusTimer
}

local lever = BossLever(config)
lever:position({x = 33454, y = 31300, z = 11})
lever:register()
