local zone = Zone("roshamuul.mawhawk")
zone:addArea(Position(33702, 32460, 7), Position(33704, 32462, 7))

local raid = Raid("roshamuul.mawhawk", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 2,
	initialChance = 0.04,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.4,
})

raid
	:addSpawnMonsters({
		{
			name = "Mawhawk",
			amount = 1,
		},
	})
	:autoAdvance("24h")

raid:register()
