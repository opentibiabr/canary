local config = {
	boss = {
		name = "The Primal Menace",
		position = Position(33558, 32759, 15),
	},
	requiredLevel = 500,
	playerPositions = {
		{ pos = Position(33548, 32752, 14), teleport = Position(33565, 32758, 15) },
		{ pos = Position(33549, 32752, 14), teleport = Position(33565, 32758, 15) },
		{ pos = Position(33550, 32752, 14), teleport = Position(33565, 32758, 15) },
		{ pos = Position(33551, 32752, 14), teleport = Position(33565, 32758, 15) },
		{ pos = Position(33552, 32752, 14), teleport = Position(33565, 32758, 15) },
	},
	specPos = {
		from = Position(33547, 32749, 15),
		to = Position(33570, 32769, 15),
	},
	disableCooldown = true,
	exit = Position(33520, 32871, 15),
}

lever = BossLever(config)
lever:position(Position(33547, 32752, 14))
lever:register()
