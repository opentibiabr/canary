local zone = Zone("fury-gates.furiosa")
zone:addArea(Position(33257, 32659, 14), Position(33342, 31867, 15))

local raid = Raid("fury-gates.furiosa", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 3,
	initialChance = 0.01,
	targetChancePerDay = 0.01,
	maxChancePerCheck = 0.6,
})

raid
	:addSpawnMonsters({
		{
			name = "Demon",
			amount = 80,
		},
	})
	:autoAdvance("1m")

raid
	:addSpawnMonsters({
		{
			name = "Furyosa",
			amount = 1,
			position = Position(33281, 31804, 15),
		},
	})
	:autoAdvance("24h")

raid:register()
