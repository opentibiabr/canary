-- Reports monster loot to Gameplay Analytics once per corpse, reading the
-- corpse's final contents after data/scripts/eventcallbacks/monster/
-- ondroploot__base.lua has already generated them.
--
-- Loot is attributed only to the corpse owner (the player entitled to loot
-- it), never to every party member the way
-- postdroploot_analyzer.lua's kill tracker update is. See
-- data/scripts/lib/gameplay_analytics_loot.lua for why.
local AnalyticsLoot = dofile("data/scripts/lib/gameplay_analytics_loot.lua")
local AnalyticsPrices = dofile("data/scripts/lib/gameplay_analytics_prices.lua")

local callback = EventCallback("GameplayAnalyticsPostDropLoot")

function callback.monsterPostDropLoot(monster, corpse)
	AnalyticsLoot.recordCorpseLoot(GameplayAnalytics, AnalyticsPrices, Player(corpse:getCorpseOwner()), corpse:getItems(true))
end

callback:register()
