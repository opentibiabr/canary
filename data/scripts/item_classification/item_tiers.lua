ItemTierClassifications = {
	-- Upgrade classification 1
	[1] = {
		-- Update tier 0
		[0] = {Price = 25000}
	},
	-- Upgrade classification 2
	[2] = {
		-- Update tier 0
		[0] = {Price = 750000},
		-- Update tier 1
		[1] = {Price = 5000000}
	},
	-- Upgrade classification 3
	[3] = {
		[0] = {Price = 4000000},
		[1] = {Price = 10000000},
		[2] = {Price = 20000000}
	},
	-- Upgrade classification 4
	[4] = {
		[0] = {Price = 8000000},
		[1] = {Price = 20000000},
		[2] = {Price = 40000000},
		[3] = {Price = 65000000},
		[4] = {Price = 100000000},
		[5] = {Price = 250000000},
		[6] = {Price = 750000000},
		[7] = {Price = 2500000000},
		[8] = {Price = 8000000000},
		[9] = {Price = 15000000000}
	}
}

for classificationId, classificationTable in ipairs(ItemTierClassifications) do
	local itemClassification = Game.createItemClassification(classificationId)
	local classification = {}

	classification.Upgrades = {}
	for tierId, tierTable in ipairs(classificationTable) do
		if tierId then
			classification.Upgrades.TierId = tierId
		end
		if tierTable.Price then
			classification.Upgrades.Price = tierTable.Price
		end
	end
	-- Create item classification and register classification table
	itemClassification:register(classification)
end
