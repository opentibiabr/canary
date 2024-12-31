local config = {
	boss = {
		name = "The Lord of the Lice",
		position = Position(33220, 31460, 12),
	},
	timeToFightAgain = 2 * 24 * 60 * 60,
	playerPositions = {
		{ pos = Position(33201, 31475, 11), teleport = Position(33215, 31470, 12) },
		{ pos = Position(33197, 31475, 11), teleport = Position(33215, 31470, 12) },
		{ pos = Position(33198, 31475, 11), teleport = Position(33215, 31470, 12) },
		{ pos = Position(33199, 31475, 11), teleport = Position(33215, 31470, 12) },
		{ pos = Position(33200, 31475, 11), teleport = Position(33215, 31470, 12) },
	},
	specPos = {
		from = Position(33187, 31429, 12),
		to = Position(33242, 31487, 12),
	},
	exit = Position(33319, 32318, 13),
}

local leverLordOfTheLice = BossLever(config)
leverLordOfTheLice:position(Position(33202, 31475, 11))
leverLordOfTheLice:register()
