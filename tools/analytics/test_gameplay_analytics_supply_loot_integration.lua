local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local AnalyticsLoot = dofile("data/scripts/lib/gameplay_analytics_loot.lua")

local function item(id, count)
	local value = { id = id, count = count }
	function value:getId()
		return self.id
	end
	function value:getCount()
		return self.count
	end
	return value
end

local prices = {
	sellPrice = function(itemId)
		if itemId == 3361 then
			return 12
		end
		return 0
	end,
}

-- 1. A nil analytics reference (data pack without the library, or a failed
--    pcall(dofile, ...)) must be a pure no-op: no error, no calls attempted.
do
	local calls = 0
	local analytics = {
		recordLoot = function()
			calls = calls + 1
		end,
	}
	AnalyticsLoot.recordCorpseLoot(nil, prices, { name = "Looter" }, { item(3361, 1) })
	assertEqual(calls, 0, "nil analytics records nothing")
end

-- 2. A nil player (no corpse owner) must also be a no-op.
do
	local calls = 0
	local analytics = {
		recordLoot = function()
			calls = calls + 1
		end,
	}
	AnalyticsLoot.recordCorpseLoot(analytics, prices, nil, { item(3361, 1) })
	assertEqual(calls, 0, "nil player records nothing")
end

-- 3. Every item in the corpse is reported exactly once, attributed to the
--    corpse owner, with the verified sell price and a zero market value.
do
	local recorded = {}
	local analytics = {
		recordLoot = function(player, itemId, amount, npcValue, marketValue)
			recorded[#recorded + 1] = { player = player, itemId = itemId, amount = amount, npcValue = npcValue, marketValue = marketValue }
		end,
	}
	local looter = { name = "Looter" }

	AnalyticsLoot.recordCorpseLoot(analytics, prices, looter, { item(3361, 2), item(9999, 5) })

	assertEqual(#recorded, 2, "every corpse item is reported")
	assertEqual(recorded[1].player, looter, "loot is attributed to the corpse owner")
	assertEqual(recorded[1].itemId, 3361, "first item id is reported")
	assertEqual(recorded[1].amount, 2, "first item amount is reported")
	assertEqual(recorded[1].npcValue, 12, "verified sell price is used")
	assertEqual(recorded[1].marketValue, 0, "market value is always zero")
	assertEqual(recorded[2].itemId, 9999, "second item id is reported")
	assertEqual(recorded[2].npcValue, 0, "unmapped item reports zero, never a guess")
end

print("gameplay analytics supply/loot integration test passed")
