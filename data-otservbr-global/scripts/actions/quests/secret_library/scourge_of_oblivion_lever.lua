local config = {
	boss = {
		name = "The Scourge of Oblivion",
		position = Position(32726, 32727, 11),
	},
	requiredLevel = 250,

	playerPositions = {
		{ pos = Position(32676, 32743, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32744, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32745, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32741, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32742, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32678, 32741, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32678, 32742, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32678, 32743, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32678, 32744, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32678, 32745, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32712, 32723, 11),
		to = Position(32738, 32748, 11),
	},
	exit = Position(32480, 32599, 15),
	storage = Storage.Quest.U11_80.TheSecretLibrary.ScourgeOfOblivionTimer,
}

local lever = BossLever(config)
lever:position({ x = 32675, y = 32743, z = 11 })
lever:register()
