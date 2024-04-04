local itemTierClassifications = {
	-- Upgrade classification 1
	[1] = {
		-- Update tier 0
		[1] = {
			regular = 25000,
			core = 1,
		},
		[2] = {
			regular = 50000,
			core = 1,
		},
		[3] = {
			regular = 100000,
			core = 1,
		},
	},
	-- Upgrade classification 2
	[2] = {
		-- Update tier 0
		[1] = {
			regular = 50000,
			core = 1,
		},
		-- Update tier 1
		[2] = {
			regular = 100000,
			core = 1,
		},
		[3] = {
			regular = 200000,
			core = 2,
		},
		[4] = {
			regular = 400000,
			core = 2,
		},
	},
	-- Upgrade classification 3
	[3] = {
		[1] = {
			regular = 200000,
			core = 1,
		},
		[2] = {
			regular = 400000,
			core = 2,
		},
		[3] = {
			regular = 800000,
			core = 3,
		},
		[4] = {
			regular = 1600000,
			core = 4,
		},
		[5] = {
			regular = 3200000,
			core = 5,
		},
	},
	-- Upgrade classification 4
	[4] = {
		[1] = {
			regular = 1500000,
			core = 1,
			convergence = { fusion = { price = 6000000 }, transfer = { price = 12000000 } },
		},
		[2] = {
			regular = 3000000,
			core = 2,
			convergence = { fusion = { price = 12000000 }, transfer = { price = 24000000 } },
		},
		[3] = {
			regular = 6000000,
			core = 5,
			convergence = { fusion = { price = 24000000 }, transfer = { price = 48000000 } },
		},
		[4] = {
			regular = 15000000,
			core = 10,
			convergence = { fusion = { price = 48000000 }, transfer = { price = 100000000 } },
		},
		[5] = {
			regular = 30000000,
			core = 15,
			convergence = { fusion = { price = 100000000 }, transfer = { price = 200000000 } },
		},
		[6] = {
			regular = 80000000,
			core = 25,
			convergence = { fusion = { price = 200000000 }, transfer = { price = 400000000 } },
		},
		[7] = {
			regular = 200000000,
			core = 35,
			convergence = { fusion = { price = 400000000 }, transfer = { price = 800000000 } },
		},
		[8] = {
			regular = 400000000,
			core = 50,
			convergence = { fusion = { price = 800000000 }, transfer = { price = 1600000000 } },
		},
		[9] = {
			regular = 800000000,
			core = 60,
			convergence = { fusion = { price = 1600000000 }, transfer = { price = 3200000000 } },
		},
		[10] = {
			regular = 1600000000,
			core = 85,
			convergence = { fusion = { price = 3200000000 }, transfer = { price = 6400000000 } },
		},
	},
}

-- Item tier with gold price for uprading it
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
