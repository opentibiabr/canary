local zone = Zone("muggy_plains.battlemaster_zunzu")
zone:addArea(Position(33223, 31232, 7), Position(33277, 31257, 7))

local raid = Raid("muggy_plains.battlemaster_zunzu", {
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
			name = "Battlemaster Zunzu",
			amount = 1,
		},
	})
	:autoAdvance("24h")

raid:register()
