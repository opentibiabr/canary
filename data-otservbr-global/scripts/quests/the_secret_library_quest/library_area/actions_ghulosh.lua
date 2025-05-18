local config = {
	boss = {
		name = "Ghulosh",
		position = Position(32756, 32720, 10),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32747, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32748, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32749, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32750, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32751, 32773, 10), teleport = Position(32757, 32727, 10), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "the book of death", pos = Position(32756, 32718, 10) },
	},
	specPos = {
		from = Position(32748, 32713, 10),
		to = Position(32763, 32729, 10),
	},
	exit = Position(32660, 32713, 13),
}

local lever = BossLever(config)
lever:position(Position(32746, 32773, 10))
lever:register()
