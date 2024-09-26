local config = {
	boss = {
		name = "The Percht Queen",
		position = Position(33757, 31050, 9),
	},
	timeAfterKill = 60,
	playerPositions = {
		{ pos = Position(33790, 31098, 9), teleport = Position(33750, 31064, 9) },
		{ pos = Position(33790, 31099, 9), teleport = Position(33750, 31064, 9) },
		{ pos = Position(33790, 31100, 9), teleport = Position(33750, 31064, 9) },
		{ pos = Position(33790, 31101, 9), teleport = Position(33750, 31064, 9) },
		{ pos = Position(33790, 31102, 9), teleport = Position(33750, 31064, 9) },
	},
	specPos = {
		from = Position(33744, 31049, 9),
		to = Position(33771, 31073, 9),
	},
	exit = Position(33815, 31088, 9),
	exitTeleporter = Position(33746, 31062, 9),
}

local lever = BossLever(config)
lever:position(Position(33790, 31097, 9))
lever:register()
