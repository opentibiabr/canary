local config = {
	boss = {
		name = "Sir Nictros",
		createFunction = function()
			return GraveDanger.start("Sir Nictros", Position(33427, 31428, 13))
		end,
	},
	timeToFightAgain = 20 * 60 * 60,
	cooldownBosses = { "Sir Nictros", "Sir Baeloc" },
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33424, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33425, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33426, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33427, 31413, 13), teleport = Position(33423, 31448, 13) },
		{ pos = Position(33428, 31413, 13), teleport = Position(33423, 31448, 13) },
	},
	specPos = {
		from = Position(33414, 31426, 13),
		to = Position(33433, 31449, 13),
	},
	onUseExtra = function(player)
		return GraveDanger.checkEntry("Sir Nictros", player)
	end,
	exit = Position(33290, 32474, 9),
}
local lever = BossLever(config)
lever:position(Position(33423, 31413, 13))
lever:register()
