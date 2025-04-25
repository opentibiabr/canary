local itemTierClassifications = {
	-- Upgrade classification 1
	[1] = {
		-- Update tier 0
		[1] = {
			regular = 25000,
			core = 1,
		},
	},
	-- Upgrade classification 2
	[2] = {
		-- Update tier 0
		[1] = {
			regular = 750000,
			core = 1,
		},
		-- Update tier 1
		[2] = {
			regular = 5000000,
			core = 1,
		},
	},
	-- Upgrade classification 3
	[3] = {
		[1] = {
			regular = 4000000,
			core = 1,
		},
		[2] = {
			regular = 10000000,
			core = 2,
		},
		[3] = {
			regular = 20000000,
			core = 3,
		},
	},
	-- Upgrade classification 4
	[4] = {
		[1] = {
			regular = 8000000,
			core = 1,
			convergence = { fusion = { price = 55000000 }, transfer = { price = 65000000 } },
		},
		[2] = {
			regular = 20000000,
			core = 2,
			convergence = { fusion = { price = 110000000 }, transfer = { price = 165000000 } },
		},
		[3] = {
			regular = 40000000,
			core = 5,
			convergence = { fusion = { price = 170000000 }, transfer = { price = 375000000 } },
		},
		[4] = {
			regular = 65000000,
			core = 10,
			convergence = { fusion = { price = 300000000 }, transfer = { price = 800000000 } },
		},
		[5] = {
			regular = 100000000,
			core = 15,
			convergence = { fusion = { price = 875000000 }, transfer = { price = 2000000000 } },
		},
		[6] = {
			regular = 250000000,
			core = 25,
			convergence = { fusion = { price = 2350000000 }, transfer = { price = 5250000000 } },
		},
		[7] = {
			regular = 750000000,
			core = 35,
			convergence = { fusion = { price = 6950000000 }, transfer = { price = 14500000000 } },
		},
		[8] = {
			regular = 2500000000,
			core = 50,
			convergence = { fusion = { price = 21250000000 }, transfer = { price = 42500000000 } },
		},
		[9] = {
			regular = 8000000000,
			core = 60,
			convergence = { fusion = { price = 50000000000 }, transfer = { price = 100000000000 } },
		},
		[10] = {
			regular = 15000000000,
			core = 85,
			convergence = { fusion = { price = 125000000000 }, transfer = { price = 300000000000 } },
		},
	},
}

-- Item tier with gold price for upgrading it
for classificationId, classificationTable in ipairs(itemTierClassifications) do
	local itemClassification = Game.createItemClassification(classificationId)
	local classification = {}

	-- Registers table for register_item_tier.lua interface
	classification.Upgrades = {}
	for tierId, tierTable in ipairs(classificationTable) do
		table.insert(classification.Upgrades, {
			TierId = tierId,
			Core = tierTable.core,
			RegularPrice = tierTable.regular,
			ConvergenceFustionPrice = tierTable.convergence and tierTable.convergence.fusion.price or 0,
			ConvergenceTransferPrice = tierTable.convergence and tierTable.convergence.transfer.price or 0,
		})
	end
	-- Create item classification and register classification table
	itemClassification:register(classification)
end
