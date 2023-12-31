local zone = Zone("folda.yeti")
zone:addArea(Position(31991, 31580, 7), Position(32044, 31616, 7))

local raid = Raid("folda.yeti", {
	zone = zone,
	allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
	minActivePlayers = 2,
	initialChance = 0.02,
	targetChancePerDay = 0.02,
	maxChancePerCheck = 0.6,
	minGapBetween = "48h",
})

raid:addBroadcast("Something is moving to the icy grounds of Folda."):autoAdvance("30s")
raid:addBroadcast("Many Yetis are emerging from the icy mountains of Folda."):autoAdvance("30s")
raid:addBroadcast("Numerous Yetis are dominating Folda, beware!"):autoAdvance("60s")

for i = 1, 20 do
	raid
		:addSpawnMonsters({
			{
				name = "Yeti",
				amount = 3,
			},
		})
		:autoAdvance("3m")
end

raid:register()
