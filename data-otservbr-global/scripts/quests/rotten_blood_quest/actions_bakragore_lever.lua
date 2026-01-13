local config = {
	boss = {
		name = "Bakragore",
		position = Position(33044, 32394, 15),
	},
	requiredLevel = 250,
	timeToFightAgain = ParseDuration("68h") / ParseDuration("1s"),
	playerPositions = {
		{ pos = Position(33078, 32398, 15), teleport = Position(33044, 32407, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33077, 32398, 15), teleport = Position(33044, 32407, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33076, 32398, 15), teleport = Position(33044, 32407, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33075, 32398, 15), teleport = Position(33044, 32407, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33074, 32398, 15), teleport = Position(33044, 32407, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33034, 32389, 15),
		to = Position(33053, 32410, 15),
	},
	exit = Position(33044, 32409, 15),
}

local lever = BossLever(config)
lever:position(Position(33079, 32398, 15))
lever:register()
