local config = {
	boss = {
		name = "Mazzinor",
		position = Position(32725, 32719, 10),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(32721, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32722, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32723, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32724, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32725, 32773, 10), teleport = Position(32726, 32726, 10), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32716, 32713, 10),
		to = Position(32732, 32728, 10),
	},
	exit = Position(32616, 32531, 13),
	storage = Storage.Quest.U11_80.TheSecretLibrary.MazzinorTimer,
}

local lever = BossLever(config)
lever:position({ x = 32720, y = 32773, z = 10 })
lever:register()
