local zone = Zone("farmine.draptor")
zone:addArea(Position(33195, 31160, 7), Position(33286, 31247, 7))

local raid = Raid("farmine.draptor", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 2,
	initialChance = 0.02,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.6,
	minGapBetween = "12h",
})

raid:addBroadcast("The dragons of the Dragonblaze Mountains have  descended to Zao to protect the lizardkin!"):autoAdvance("30s")

for i = 1, 3 do
	raid
		:addSpawnMonsters({
			{
				name = "Dragon",
				amount = 50,
			},
		})
		:autoAdvance("2m")
end

for i = 1, 8 do
	raid
		:addSpawnMonsters({
			{
				name = "Draptor",
				amount = 1,
			},
		})
		:autoAdvance("10s")
end

raid
	:addSpawnMonsters({
		{
			name = "Grand Mother Foulscale",
			amount = 1,
		},
	})
	:autoAdvance("10s")

raid:register()
