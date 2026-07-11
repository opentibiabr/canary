local mType = Game.createMonsterType("Memory of a Shaper")
local monster = {}

monster.description = "a memory of a shaper"
monster.experience = 1750
monster.outfit = {
	lookType = 932,
	lookHead = 68,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3710
monster.maxHealth = 3710
monster.race = "blood"
monster.corpse = 25068
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
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
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 137 }, -- Gold Coin
	{ id = 3035, chance = 71000, maxCount = 2 }, -- Platinum Coin
	{ id = 24383, chance = 21000, maxCount = 2 }, -- Cave Turnip
	{ id = 3577, chance = 9500 }, -- Meat
	{ id = 3030, chance = 7900 }, -- Small Ruby
	{ id = 22193, chance = 4800 }, -- Onyx Chip
	{ id = 239, chance = 4800 }, -- Great Health Potion
	{ id = 3725, chance = 4800, maxCount = 3 }, -- Brown Mushroom
	{ id = 5021, chance = 3200, maxCount = 4 }, -- Orichalcum Pearl
	{ id = 14252, chance = 1600, maxCount = 4 }, -- Vortex Bolt
	{ id = 3055, chance = 1600 }, -- Platinum Amulet
	{ id = 3073, chance = 1600 }, -- Wand of Cosmic Energy
	{ id = 24392, chance = 1740 }, -- Gemmed Figurine
	{ id = 37468, chance = 1160 }, -- Special Fx Box
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -100, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -100, length = 5, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -100, radius = 7, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 9, speedChange = -440, effect = CONST_ME_GIANTICE, target = true, duration = 7000 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.30,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
