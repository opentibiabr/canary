local config = {
	boss = {
		name = "Bakragore",
		position = Position(33046, 32398, 15),
	},
	timeAfterKill = 60,
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(33014, 32392, 15), teleport = Position(33036, 32398, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33013, 32392, 15), teleport = Position(33036, 32398, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33012, 32392, 15), teleport = Position(33036, 32398, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33011, 32392, 15), teleport = Position(33036, 32398, 15) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33010, 32392, 15), teleport = Position(33036, 32398, 15) ,effect = CONST_ME_TELEPORT },





	},
	specPos = {
		from = Position(33032, 32389, 15),
		to = Position(33053, 32409, 15),
	},
	exit = Position(34107, 32050, 13),
	exitTeleporter = Position(33044, 32409, 15),
}

local lever = BossLever(config)
lever:aid(54298)
lever:register()
