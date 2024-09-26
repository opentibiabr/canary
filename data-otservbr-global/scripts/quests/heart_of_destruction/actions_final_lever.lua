local config = {
	boss = {
		name = "World Devourer",
		position = Position(32271, 31348, 14),
	},
	timeAfterKill = 120,
	requiredLevel = 250,
	timeToFightAgain = 172800,
	playerPositions = {
		{ pos = Position(32272, 31374, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32272, 31375, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32272, 31376, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32272, 31377, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32272, 31378, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32271, 31374, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32271, 31375, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32271, 31376, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32271, 31377, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32271, 31378, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32273, 31374, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32273, 31375, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32273, 31376, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32273, 31377, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },
		{ pos = Position(32273, 31378, 14), teleport = Position(32271, 31355, 14) ,effect = CONST_ME_TELEPORT },






	},
	
		
	specPos = {
		from = Position(32261, 31337, 14),
		to = Position(32282, 31359, 12),
	},
	exit = Position(32281, 31348, 14),
	exitTeleporter = Position(32113, 31373, 14),
}

local lever = BossLever(config)
lever:aid(54301)
lever:register()
