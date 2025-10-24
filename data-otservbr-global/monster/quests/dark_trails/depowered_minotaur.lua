local mType = Game.createMonsterType("Depowered Minotaur")
local monster = {}

monster.description = "a depowered minotaur"
monster.experience = 1100
monster.outfit = {
	lookType = 25,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 5969
monster.speed = 106
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I want my power back!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 58169, maxCount = 5 }, -- Platinum Coin
	{ id = 3029, chance = 4968 }, -- Small Sapphire
	{ id = 237, chance = 9570, maxCount = 3 }, -- Strong Mana Potion
	{ id = 236, chance = 10324, maxCount = 3 }, -- Strong Health Potion
	{ id = 5878, chance = 9960 }, -- Minotaur Leather
	{ id = 3028, chance = 4720 }, -- Small Diamond
	{ id = 3577, chance = 6680 }, -- Meat
	{ id = 11472, chance = 14680 }, -- Minotaur Horn
	{ id = 3030, chance = 5640 }, -- Small Ruby
	{ id = 3029, chance = 4968 }, -- Small Sapphire
	{ id = 3032, chance = 4980 }, -- Small Emerald
	{ id = 21166, chance = 1310 }, -- Mooh'tah Plate
	{ id = 3093, chance = 789 }, -- Club Ring
	{ id = 5911, chance = 520 }, -- Red Piece of Cloth
	{ id = 7401, chance = 520 }, -- Minotaur Trophy
	{ id = 7452, chance = 390 }, -- Spiked Squelcher
	{ id = 21177, chance = 920 }, -- Cowtana
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 45 },
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -200 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 1.09,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
