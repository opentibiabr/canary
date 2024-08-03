local zone = Zone("edron.white-pale")
zone:addArea(Position(33263, 31874, 11), Position(33265, 31876, 11))

local raid = Raid("edron.white-pale", {
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
			name = "White Pale",
			amount = 1,
			position = Position(33264, 31875, 11),
		},
	})
	:autoAdvance("24h")

raid:register()
