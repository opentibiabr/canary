--
-- Items with upgade classification 1
local ItemClass = Game.createItemClassification(1)
local classification = {}

classification.Upgrades = {
	{
		TierId = 0,
		Price = 25000
	}
}

ItemClass:register(classification)

--
-- Items with upgade classification 2
ItemClass = Game.createItemClassification(2)
classification = {}

classification.Upgrades = {
	{
		TierId = 0,
		Price = 750000
	},
	{
		TierId = 1,
		Price = 5000000
	}
}

ItemClass:register(classification)

--
-- Items with upgade classification 3
ItemClass = Game.createItemClassification(3)
classification = {}

classification.Upgrades = {
	{
		TierId = 0,
		Price = 4000000
	},
	{
		TierId = 1,
		Price = 10000000
	},
	{
		TierId = 2,
		Price = 20000000
	}
	
}

ItemClass:register(classification)

--
-- Items with upgade classification 4
ItemClass = Game.createItemClassification(4)
classification = {}

classification.Upgrades = {
	{
		TierId = 0,
		Price = 8000000
	},
	{
		TierId = 1,
		Price = 20000000
	},
	{
		TierId = 2,
		Price = 40000000
	},
	{
		TierId = 3,
		Price = 65000000
	},
	{
		TierId = 4,
		Price = 100000000
	},
	{
		TierId = 5,
		Price = 250000000
	},
	{
		TierId = 6,
		Price = 750000000
	},
	{
		TierId = 7,
		Price = 2500000000
	},
	{
		TierId = 8,
		Price = 8000000000
	},
	{
		TierId = 9,
		Price = 15000000000
	}
	
}

ItemClass:register(classification)