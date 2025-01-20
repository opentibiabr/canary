local config = {
	boss = {
		name = "Count Vlarkorth",
		position = Position(33456, 31437, 13),
	},
	timeAfterKill = 30 * 60,
	playerPositions = {
		{ pos = Position(33455, 31413, 13), teleport = Position(33457, 31442, 13) },
		{ pos = Position(33456, 31413, 13), teleport = Position(33457, 31442, 13) },
		{ pos = Position(33457, 31413, 13), teleport = Position(33457, 31442, 13) },
		{ pos = Position(33458, 31413, 13), teleport = Position(33457, 31442, 13) },
		{ pos = Position(33459, 31413, 13), teleport = Position(33457, 31442, 13) },
	},
	specPos = {
		from = Position(33451, 31432, 13),
		to = Position(33461, 31442, 13),
	},
	exit = Position(33195, 31696, 8),
	exitTeleporter = Position(33456, 31446, 13),
}

local lever = BossLever(config)
lever:aid(14557)
lever:register()
