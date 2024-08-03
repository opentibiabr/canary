local zone = Zone("tiquanda.midnight-panther")
zone:addArea(Position(32847, 32697, 7), Position(32871, 32738, 7))

local raid = Raid("tiquanda.midnight-panther", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 3,
	initialChance = 0.03,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.9,
})

local possiblePositions = {
	Position(32847, 32697, 7),
	Position(32871, 32717, 7),
	Position(32856, 32738, 7),
}

raid
	:addSpawnMonsters({
		{
			name = "Midnight Panther",
			amount = 1,
			position = possiblePositions[math.random(1, #possiblePositions)],
		},
	})
	:autoAdvance("24h")

raid:register()
