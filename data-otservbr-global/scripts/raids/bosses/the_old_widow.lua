local zone = Zone("venore.the-old-widow")
zone:addArea(Position(32292, 32292, 12), Position(32796, 32306, 12))

local raid = Raid("venore.the-old-widow", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 3,
	initialChance = 0.02,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.8,
})

raid:addBroadcast("The mating season of the giant spiders is at hand. Leave the plains of havoc as fast as you can."):autoAdvance("30s")

raid:addBroadcast("Giant spiders have gathered on the plains of havoc for their mating season. Beware!"):autoAdvance("3m")

for _ = 1, 4 do
	raid
		:addSpawnMonsters({
			{
				name = "Giant Spider",
				amount = 8,
			},
		})
		:autoAdvance("10s")
end

raid
	:addSpawnMonsters({
		{
			name = "The Old Widow",
			amount = 1,
			position = Position(32776, 32296, 7),
		},
	})
	:autoAdvance("24h")

raid:register()
