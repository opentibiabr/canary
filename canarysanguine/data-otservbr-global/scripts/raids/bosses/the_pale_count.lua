local zone = Zone("drefia.the-pale-count")
zone:addArea(Position(32968, 32419, 15), Position(32970, 32421, 15))

local raid = Raid("drefia.the-pale-count", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 3,
	initialChance = 0.01,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.7,
})

raid
	:addSpawnMonsters({
		{
			name = "The Pale Count",
			amount = 1,
			position = Position(32969, 32420, 15),
		},
	})
	:autoAdvance("24h")

raid:register()
