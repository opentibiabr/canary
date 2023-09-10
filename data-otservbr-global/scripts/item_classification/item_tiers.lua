local itemTierClassifications = {
	-- Upgrade classification 1
	[1] = {
		-- Update tier 0
		[1] = { price = 25000, core = 1 },
	},
	-- Upgrade classification 2
	[2] = {
		-- Update tier 0
		[1] = { price = 750000, core = 1 },
		-- Update tier 1
		[2] = { price = 5000000, core = 1 },
	},
	-- Upgrade classification 3
	[3] = {
		[1] = { price = 4000000, core = 1 },
		[2] = { price = 10000000, core = 1 },
		[3] = { price = 20000000, core = 2 },
	},
	-- Upgrade classification 4
	[4] = {
		[1] = { price = 8000000, core = 1 },
		[2] = { price = 20000000, core = 1 },
		[3] = { price = 40000000, core = 2 },
		[4] = { price = 65000000, core = 5 },
		[5] = { price = 100000000, core = 10 },
		[6] = { price = 250000000, core = 15 },
		[7] = { price = 750000000, core = 25 },
		[8] = { price = 2500000000, core = 35 },
		[9] = { price = 8000000000, core = 50 },
		[10] = { price = 15000000000, core = 65 },
	},
}

-- Item tier with gold price for uprading it
for classificationId, classificationTable in ipairs(itemTierClassifications) do
	local itemClassification = Game.createItemClassification(classificationId)
	local classification = {}

	-- Registers table for register_item_tier.lua interface
	classification.Upgrades = {}
	for tierId, tierTable in ipairs(classificationTable) do
		if tierId and tierTable.price and tierTable.core ~= nil then
			table.insert(classification.Upgrades, { TierId = tierId - 1, Price = tierTable.price, Core = tierTable.core })
		end
	end
	-- Create item classification and register classification table
	itemClassification:register(classification)
end
