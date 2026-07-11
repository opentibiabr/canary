-- Verified NPC prices used by Gameplay Analytics supply and loot reporting.
--
-- Every entry is copied directly from an existing NPC shop script; nothing
-- here is estimated or invented. See
-- docs/systems/gameplay-analytics-supply-loot.md for the full value-source
-- precedence this table implements. An item missing from this table (or
-- missing the "buy" or "sell" side specifically) reports 0 for that value,
-- never a guessed number.
--
-- buy: price a player pays an NPC for one unit (recordSupply's unitValue).
-- sell: price an NPC pays a player for one unit (recordLoot's npcValue).
local prices = {
	-- Potions (data-otservbr-global/npc/chuckles.lua). NPCs in this shop do
	-- not buy full potions back, so these have no verified "sell" side.
	[236] = { buy = 115 }, -- strong health potion
	[237] = { buy = 108 }, -- strong mana potion
	[238] = { buy = 158 }, -- great mana potion
	[239] = { buy = 225 }, -- great health potion
	[266] = { buy = 50 }, -- health potion
	[268] = { buy = 56 }, -- mana potion
	[7642] = { buy = 254 }, -- great spirit potion
	[7643] = { buy = 379 }, -- ultimate health potion
	[23373] = { buy = 488 }, -- ultimate mana potion
	[23374] = { buy = 488 }, -- ultimate spirit potion
	[23375] = { buy = 650 }, -- supreme health potion

	-- Runes (data-otservbr-global/npc/alexander.lua, npc/asima.lua). NPCs do
	-- not buy runes back, so these have no verified "sell" side either.
	[3189] = { buy = 30 }, -- fireball rune
	[3152] = { buy = 95 }, -- intense healing rune

	-- Common monster loot (data-otservbr-global/npc/azil.lua, npc/tom.lua).
	[3361] = { buy = 35, sell = 12 }, -- leather armor
	[5897] = { sell = 7 }, -- wolf paw
}

local GameplayAnalyticsPrices = {}

function GameplayAnalyticsPrices.buyPrice(itemId)
	local entry = prices[itemId]
	return (entry and entry.buy) or 0
end

function GameplayAnalyticsPrices.sellPrice(itemId)
	local entry = prices[itemId]
	return (entry and entry.sell) or 0
end

return GameplayAnalyticsPrices
