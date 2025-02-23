local config = {
	boss = {
		name = "Mitmah Vanguard",
		position = Position(34067, 31409, 11),
	},
	timeAfterKill = 60,
	playerPositions = {
		{ pos = Position(34048, 31431, 11), teleport = Position(34067, 31415, 11) },
		{ pos = Position(34049, 31431, 11), teleport = Position(34067, 31415, 11) },
		{ pos = Position(34050, 31431, 11), teleport = Position(34067, 31415, 11) },
		{ pos = Position(34051, 31431, 11), teleport = Position(34067, 31415, 11) },
		{ pos = Position(34052, 31431, 11), teleport = Position(34067, 31415, 11) },
	},
	specPos = {
		from = Position(34054, 31400, 11),
		to = Position(34081, 31419, 11),
	},
	exit = Position(34060, 31432, 11),
}

local lever = BossLever(config)
lever:position(Position(34047, 31431, 11))
lever:register()
