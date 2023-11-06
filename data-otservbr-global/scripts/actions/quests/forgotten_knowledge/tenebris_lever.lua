local config = {
	boss = {
		name = "Lady Tenebris",
		position = Position(32912, 31599, 14),
	},
	playerPositions = {
		{ pos = Position(32902, 31623, 14), teleport = Position(32911, 31603, 14) },
		{ pos = Position(32902, 31624, 14), teleport = Position(32911, 31603, 14) },
		{ pos = Position(32902, 31625, 14), teleport = Position(32911, 31603, 14) },
		{ pos = Position(32902, 31626, 14), teleport = Position(32911, 31603, 14) },
		{ pos = Position(32902, 31627, 14), teleport = Position(32911, 31603, 14) },
	},
	onUseExtra = function(player)
		for d = 1, 6 do
			Game.createMonster("shadow tentacle", Position(math.random(32909, 32914), math.random(31596, 31601), 14), true, true)
		end
	end,
	specPos = {
		from = Position(32895, 31585, 14),
		to = Position(32830, 32855, 14),
	},
	exit = Position(32902, 31629, 14),
}

local lever = BossLever(config)
lever:position(Position(32902, 31622, 14))
lever:register()
