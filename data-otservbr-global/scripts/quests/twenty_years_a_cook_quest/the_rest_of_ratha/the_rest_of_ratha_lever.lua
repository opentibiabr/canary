local config = {
	boss = {
		name = "The Rest Of Ratha",
		position = Position(33382, 31440, 15),
	},
	timeToDefeat = TwentyYearsACookQuest.TheRestOfRatha.TimeToDefeat,
	requiredLevel = 1,
	playerPositions = {
		{ pos = Position(32585, 31939, 5), teleport = Position(33382, 31440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32586, 31939, 5), teleport = Position(33382, 31440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32587, 31939, 5), teleport = Position(33382, 31440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32588, 31939, 5), teleport = Position(33382, 31440, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32584, 31939, 5), teleport = Position(33382, 31440, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33382, 31440, 15),
		to = Position(33382, 31440, 15),
	},
	monsters = {
		{ name = "Spirit Container", pos = Position(33382, 31440, 15) },
		{ name = "Ghost Duster", pos = Position(33382, 31440, 15) },
	},
	exit = Position(33382, 31440, 15),
}

local lever = BossLever(config)
lever:uid(TwentyYearsACookQuest.TheRestOfRatha.LeverUID)
lever:register()
