local zone = Zone("darashia.tyrn")
zone:addArea(Position(33055, 32392, 14), Position(33057, 32394, 14))

local raid = Raid("darashia.tyrn", {
	zone = zone,
	allowedDays = { "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 2,
	initialChance = 0.04,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.4,
})

raid
	:addSpawnMonsters({
		{
			name = "Tyrn",
			amount = 1,
		},
	})
	:autoAdvance("24h")

raid:register()
