-- Shared helper that reports a corpse's final loot to Gameplay Analytics.
-- See data/scripts/eventcallbacks/monster/postdroploot_gameplay_analytics.lua
-- for why this is only ever called once, for the corpse owner, and never for
-- every party member: a corpse holds one set of physical items, so crediting
-- it to more than one player would double-count the same loot.

local GameplayAnalyticsLoot = {}

-- analytics: the table returned by gameplay_analytics.lua, or nil.
-- prices: the table returned by gameplay_analytics_prices.lua.
-- player: the corpse owner, or nil.
-- items: the corpse's contents (Container:getItems(false)), or nil.
function GameplayAnalyticsLoot.recordCorpseLoot(analytics, prices, player, items)
	if not analytics or not player or not items then
		return
	end

	for _, item in ipairs(items) do
		local itemId = item:getId()
		-- Market value is always 0: this engine does not expose a
		-- Lua-accessible market price API, and prices are never guessed.
		analytics.recordLoot(player, itemId, item:getCount(), prices.sellPrice(itemId), 0)
	end
end

return GameplayAnalyticsLoot
