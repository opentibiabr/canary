local config = {
	boss = {
		name = "Earl Osam",
		position = Position(33488, 31438, 13),
	},
	timeAfterKill = 30 * 60,
	playerPositions = {
		{ pos = Position(33516, 31444, 13), teleport = Position(33489, 31441, 13) },
		{ pos = Position(33517, 31444, 13), teleport = Position(33489, 31441, 13) },
		{ pos = Position(33518, 31444, 13), teleport = Position(33489, 31441, 13) },
		{ pos = Position(33519, 31444, 13), teleport = Position(33489, 31441, 13) },
		{ pos = Position(33520, 31444, 13), teleport = Position(33489, 31441, 13) },
	},
	specPos = {
		from = Position(33479, 31429, 13),
		to = Position(33497, 31447, 13),
	},
	exit = Position(33261, 31985, 8),
	exitTeleporter = Position(33263, 31985, 8),
}

local lever = BossLever(config)
lever:aid(14558)
lever:register()
