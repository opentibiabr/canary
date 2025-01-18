local config = {
	boss = {
		name = "Lord Azaram",
		position = Position(33424, 31472, 13),
	},
	timeAfterKill = 30 * 60,
	playerPositions = {
		{ pos = Position(33422, 31493, 13), teleport = Position(33424, 31478, 13) },
		{ pos = Position(33423, 31493, 13), teleport = Position(33424, 31478, 13) },
		{ pos = Position(33424, 31493, 13), teleport = Position(33424, 31478, 13) },
		{ pos = Position(33425, 31493, 13), teleport = Position(33424, 31478, 13) },
		{ pos = Position(33426, 31493, 13), teleport = Position(33424, 31478, 13) },
	},
	specPos = {
		from = Position(33414, 31463, 13),
		to = Position(33433, 31481, 13),
	},
	monsters = {
		{ name = "Condensed Sin", pos = Position(33426, 31471, 13) },
		{ name = "Condensed Sin", pos = Position(33422, 31471, 13) },
	},
	exit = Position(32190, 31819, 8),
	exitTeleporter = Position(32192, 31819, 8),
}

local lever = BossLever(config)
lever:aid(14561)
lever:register()
