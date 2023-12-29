local zone = Zone("farmine.draptor")
zone:addArea(Position(31909, 32554, 7), Position(31983, 32579, 7))

local raid = Raid("farmine.draptor", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 2,
	initialChance = 0.02,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.6,
	minGapBetween = "12h",
})

for i = 1, 3 do
	raid
		:addSpawnMonsters({
			{
				name = "Undead Cavebear",
				amount = 3,
			},
		})
		:autoAdvance("2m")
end

raid:register()
