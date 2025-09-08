local config = {
	boss = {
		name = "Arbaziloth",
		createFunction = function()
			Game.createMonster("Arbaziloth", Position(34036, 32330, 14), true, true)
			return true
		end,
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	playerPositions = {
		{ pos = Position(34058, 32396, 14), teleport = Position(34032, 32331, 14) },
		{ pos = Position(34058, 32397, 14), teleport = Position(34032, 32331, 14) },
		{ pos = Position(34058, 32398, 14), teleport = Position(34032, 32331, 14) },
		{ pos = Position(34058, 32399, 14), teleport = Position(34032, 32331, 14) },
		{ pos = Position(34058, 32400, 14), teleport = Position(34032, 32331, 14) },
	},
	specPos = {
		from = Position(34019, 32320, 14),
		to = Position(34044, 32341, 14),
	},
	exit = Position(33877, 32399, 10),
}

local lever = BossLever(config)
lever:position(Position(34058, 32395, 14))
lever:register()
