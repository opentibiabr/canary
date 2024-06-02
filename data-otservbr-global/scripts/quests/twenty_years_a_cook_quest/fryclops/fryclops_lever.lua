local config = {
	boss = {
		name = "Fryclops",
		position = Position(32353, 31604, 6),
	},
	timeToDefeat = TwentyYearsACookQuest.Fryclops.TimeToDefeat,
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32365, 31602, 7), teleport = Position(32362, 31602, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(32366, 31602, 7), teleport = Position(32362, 31602, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(32367, 31602, 7), teleport = Position(32362, 31602, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(32368, 31602, 7), teleport = Position(32362, 31602, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(32369, 31602, 7), teleport = Position(32362, 31602, 6), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32341, 31589, 6),
		to = Position(32368, 21611, 6),
	},
	monsters = {
		{ name = "Locked Door", pos = Position(32357, 31600, 6) },
	},
	exit = TwentyYearsACookQuest.Fryclops.Exit,
}

local lever = BossLever(config)
lever:uid(TwentyYearsACookQuest.Fryclops.LeverUID)
lever:register()
