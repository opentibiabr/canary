local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local AnalyticsPrices = dofile("data/scripts/lib/gameplay_analytics_prices.lua")

-- Verified entries return the exact copied NPC price.
assertEqual(AnalyticsPrices.buyPrice(266), 50, "health potion buy price")
assertEqual(AnalyticsPrices.buyPrice(268), 56, "mana potion buy price")
assertEqual(AnalyticsPrices.buyPrice(3189), 30, "fireball rune buy price")
assertEqual(AnalyticsPrices.buyPrice(3152), 95, "intense healing rune buy price")
assertEqual(AnalyticsPrices.buyPrice(3361), 35, "leather armor buy price")
assertEqual(AnalyticsPrices.sellPrice(3361), 12, "leather armor sell price")
assertEqual(AnalyticsPrices.sellPrice(5897), 7, "wolf paw sell price")

-- An item with only one verified side reports 0, not a guess, for the other.
assertEqual(AnalyticsPrices.sellPrice(266), 0, "health potion has no verified sell price")
assertEqual(AnalyticsPrices.buyPrice(5897), 0, "wolf paw has no verified buy price")

-- An item with no table entry at all reports 0 for both sides.
assertEqual(AnalyticsPrices.buyPrice(99999), 0, "unmapped item buy price defaults to zero")
assertEqual(AnalyticsPrices.sellPrice(99999), 0, "unmapped item sell price defaults to zero")

print("gameplay analytics supply/loot price table test passed")
