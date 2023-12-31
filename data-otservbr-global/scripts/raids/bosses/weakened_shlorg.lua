local zone = Zone("edron.weakened-shlorg")
zone:addArea(Position(33163, 31715, 9), Position(33165, 31717, 9))

local raid = Raid("edron.weakened-shlorg", {
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
			name = "Weakened Shlorg",
			amount = 1,
			position = Position(33164, 31716, 9),
		},
	})
	:autoAdvance("24h")

raid:register()
