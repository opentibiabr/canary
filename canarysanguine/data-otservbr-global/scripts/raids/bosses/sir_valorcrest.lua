local zone = Zone("edron.valorcrest")
zone:addArea(Position(33263, 31767, 10), Position(33265, 31769, 10))

local raid = Raid("edron.valorcrest", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 3,
	initialChance = 0.02,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.8,
})

raid
	:addSpawnMonsters({
		{
			name = "Sir Valorcrest",
			amount = 1,
			position = Position(33264, 31768, 10),
		},
	})
	:autoAdvance("24h")

raid:register()
