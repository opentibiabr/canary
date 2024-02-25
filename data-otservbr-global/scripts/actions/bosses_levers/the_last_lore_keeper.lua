local config = {
	boss = {
		name = "The Last Lore Keeper",
		position = Position(31987, 32839, 14),
	},
	timeToFightAgain = ParseDuration("14d") / 1000,
	timeToDefeat = ParseDuration("17m") / 1000,
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32018, 32844, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32019, 32844, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32020, 32844, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32018, 32845, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32019, 32845, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32020, 32845, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32018, 32846, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32019, 32846, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32020, 32846, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32018, 32847, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32019, 32847, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32020, 32847, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32018, 32848, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32019, 32848, 14), teleport = Position(31984, 32851, 14) },
		{ pos = Position(32020, 32848, 14), teleport = Position(31984, 32851, 14) },
	},
	monsters = {
		{ name = "bound astral power", pos = Position(31973, 32840, 15) },
		{ name = "bound astral power", pos = Position(31973, 32856, 15) },
		{ name = "bound astral power", pos = Position(31989, 32856, 15) },
		{ name = "bound astral power", pos = Position(31989, 32840, 15) },
		{ name = "a shielded astral glyph", pos = Position(31986, 32840, 14) },
		{ name = "the distorted astral source", pos = Position(31986, 32823, 15) },
		{ name = "an astral glyph", pos = Position(31989, 32823, 15) },
	},
	specPos = {
		from = Position(31968, 32821, 14),
		to = Position(32004, 32865, 15),
	},
	exit = Position(32035, 32859, 14),
}

local lever = BossLever(config)
lever:position(Position(32019, 32843, 14))
lever:register()
