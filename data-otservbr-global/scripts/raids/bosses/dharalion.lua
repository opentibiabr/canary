local zone = Zone("venore.dharalion")
zone:addArea(Position(33033, 32174, 9), Position(33045, 32181, 9))

local raid = Raid("venore.dharalion", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 1,
	initialChance = 0.03,
	targetChancePerDay = 0.05,
	maxChancePerCheck = 0.9,
})

raid
	:addSpawnMonsters({
		{
			name = "Dharalion",
			amount = 1,
			position = Position(33038, 32176, 9),
		},
	})
	:autoAdvance("24h")

raid:register()
