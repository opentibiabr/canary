local config = {
	boss = {
		name = "soul of dragonking zyrtarch",
		position = Position(33359, 31182, 12),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33391, 31178, 10), teleport = Position(33359, 31186, 10) },
		{ pos = Position(33391, 31179, 10), teleport = Position(33359, 31186, 10) },
		{ pos = Position(33391, 31180, 10), teleport = Position(33359, 31186, 10) },
		{ pos = Position(33391, 31181, 10), teleport = Position(33359, 31186, 10) },
		{ pos = Position(33391, 31182, 10), teleport = Position(33359, 31186, 10) },
	},
	monsters = {
		{ name = "soulcatcher", pos = Position(33352, 31187, 10) },
		{ name = "soulcatcher", pos = Position(33363, 31187, 10) },
		{ name = "soulcatcher", pos = Position(33353, 31176, 10) },
		{ name = "soulcatcher", pos = Position(33363, 31176, 10) },
		{ name = "dragonking zyrtarch", pos = Position(33357, 31182, 10) },
	},
	specPos = {
		from = Position(33348, 31172, 10),
		to = Position(33368, 31190, 12),
	},
	exit = Position(33407, 31172, 10),
}

local lever = BossLever(config)
lever:position(Position(33391, 31177, 10))
lever:register()
