local mType = Game.createMonsterType("Young Goanna")
local monster = {}

monster.description = "a young goanna"
monster.experience = 6100
monster.outfit = {
	lookType = 1196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1817
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt.",
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "blood"
monster.corpse = 31409
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 16143, chance = 68221, maxCount = 35 }, -- Envenomed Arrow
	{ id = 3065, chance = 8598 }, -- Terra Rod
	{ id = 31560, chance = 9443 }, -- Goanna Meat
	{ id = 3066, chance = 9377 }, -- Snakebite Rod
	{ id = 31559, chance = 7969 }, -- Blue Goanna Scale
	{ id = 16119, chance = 10040 }, -- Blue Crystal Shard
	{ id = 677, chance = 4460 }, -- Small Enchanted Emerald
	{ id = 814, chance = 1020 }, -- Terra Amulet
	{ id = 3036, chance = 3020 }, -- Violet Gem
	{ id = 3037, chance = 3370 }, -- Yellow Gem
	{ id = 3041, chance = 1290 }, -- Blue Gem
	{ id = 31561, chance = 4703 }, -- Goanna Claw
	{ id = 3297, chance = 3370 }, -- Serpent Sword
	{ id = 25735, chance = 4395, maxCount = 3 }, -- Leaf Star
	{ id = 3054, chance = 1761 }, -- Silver Amulet
	{ id = 8084, chance = 2963 }, -- Springsprout Rod
	{ id = 31488, chance = 2522 }, -- Scared Frog
	{ id = 25737, chance = 3130, maxCount = 3 }, -- Rainbow Quartz
	{ id = 22193, chance = 3720 }, -- Onyx Chip
	{ id = 16121, chance = 3540 }, -- Green Crystal Shard
	{ id = 16124, chance = 1010 }, -- Blue Crystal Splinter
	{ id = 31340, chance = 1210 }, -- Lizard Heart
	{ id = 9302, chance = 750 }, -- Sacred Tree Amulet
	{ id = 31445, chance = 1310 }, -- Small Tortoise
	{ id = 830, chance = 450 }, -- Terra Hood
	{ id = 22085, chance = 240 }, -- Fur Armor
	{ id = 25699, chance = 494 }, -- Wooden Spellbook
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, condition = { type = CONDITION_POISON, totalDamage = 200, interval = 4000 } },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -490, range = 3, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -500, radius = 1, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -490, lenght = 8, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
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
