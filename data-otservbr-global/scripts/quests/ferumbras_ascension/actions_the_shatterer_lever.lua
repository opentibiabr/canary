local config = {
	boss = {
		name = "The Shatterer",
		position = Position(33406, 32418, 14),
	},
	timeToFightAgain = 2 * 24 * 60 * 60,
	playerPositions = {
		{ pos = Position(33403, 32465, 13), teleport = Position(33398, 32414, 14) },
		{ pos = Position(33404, 32465, 13), teleport = Position(33398, 32414, 14) },
		{ pos = Position(33405, 32465, 13), teleport = Position(33398, 32414, 14) },
		{ pos = Position(33406, 32465, 13), teleport = Position(33398, 32414, 14) },
		{ pos = Position(33407, 32465, 13), teleport = Position(33398, 32414, 14) },
	},
	specPos = {
		from = Position(33377, 32390, 14),
		to = Position(33446, 32447, 14),
	},
	exit = Position(33319, 32318, 13),
}

local leverShatterer = BossLever(config)
leverShatterer:position(Position(33402, 32465, 13))
leverShatterer:register()
