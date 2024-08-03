local zone = Zone("svargrond.hirintror")
zone:addArea(Position(32100, 31166, 9), Position(32102, 31168, 9))

local raid = Raid("svargrond.hirintror", {
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
			name = "Hirintror",
			amount = 1,
			position = Position(32101, 31167, 9),
		},
	})
	:autoAdvance("24h")

raid:register()
