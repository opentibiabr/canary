local zone = Zone("candia.sugarmommy")
zone:addArea(Position(33450, 32131, 9), Position(33460, 32140, 9))

local raid = Raid("candia.sugarmommy", {
	zone = zone,
	allowedDays = { "Friday", "Saturday", "Sunday" },
	minActivePlayers = 1,
	initialChance = 0.10,
	targetChancePerDay = 0.05,
	maxChancePerCheck = 1.0,
})

raid
	:addSpawnMonsters({
		{
			name = "Sugar Mommy",
			amount = 1,
		},
	})
	:autoAdvance("24h")

raid:register()
