local config = {
	boss = {
		name = "Ascending Ferumbras",
		position = Position(33392, 31473, 14),
	},
	timeAfterKill = 60,
	requiredLevel = 250,
	timeToFightAgain = 259200,
	playerPositions = {
		{ pos = Position(33270, 31477, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33270, 31478, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33270, 31479, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33270, 31480, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33270, 31481, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33269, 31477, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33269, 31478, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33269, 31479, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33269, 31480, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33269, 31481, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33271, 31477, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33271, 31478, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33271, 31479, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33271, 31480, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(33271, 31481, 14), teleport = Position(33392, 31478, 14) ,effect = CONST_ME_TELEPORT },





	},
	
		
	specPos = {
		from = Position(33379, 31460, 14),
		to = Position(33405, 31845, 14),
	},
	exit = Position(33277, 32392, 9),
	exitTeleporter = Position(33392, 31485, 14),
}

local lever = BossLever(config)
lever:aid(54300)
lever:register()
