local config = {
	boss = {
		name = "Jaul",
		position = Position(33534, 31266, 11)
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(33563, 31230, 11), teleport = Position(33548, 31275, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33563, 31231, 11), teleport = Position(33548, 31275, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33563, 31232, 11), teleport = Position(33548, 31275, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33563, 31233, 11), teleport = Position(33548, 31275, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33563, 31234, 11), teleport = Position(33548, 31275, 11), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33538, 31261, 11),
		to = Position(33547, 31278, 11)
	},
	exit = Position(33560, 31234, 11),
	storage = Storage.Quest.U12_30.FeasterOfSouls.JaulTimer
}

local lever = BossLever(config)
lever:position({x = 33563, y = 31229, z = 11})
lever:register()
