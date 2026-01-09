local mType = Game.createMonsterType("Adult Goanna")
local monster = {}

monster.description = "an adult goanna"
monster.experience = 6650
monster.outfit = {
	lookType = 1195,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1818
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

monster.health = 8300
monster.maxHealth = 8300
monster.race = "blood"
monster.corpse = 31405
monster.speed = 210
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
	{ id = 16143, chance = 57023, maxCount = 8 }, -- Envenomed Arrow
	{ id = 774, chance = 14179, maxCount = 29 }, -- Earth Arrow
	{ id = 31560, chance = 11105 }, -- Goanna Meat
	{ id = 3065, chance = 7616 }, -- Terra Rod
	{ id = 31558, chance = 8254 }, -- Red Goanna Scale
	{ id = 830, chance = 6308 }, -- Terra Hood
	{ id = 814, chance = 5674 }, -- Terra Amulet
	{ id = 3029, chance = 8800 }, -- Small Sapphire
	{ id = 16122, chance = 7260 }, -- Green Crystal Splinter
	{ id = 16119, chance = 7750 }, -- Blue Crystal Shard
	{ id = 3010, chance = 12099 }, -- Emerald Bangle
	{ id = 677, chance = 8980 }, -- Small Enchanted Emerald
	{ id = 3017, chance = 4360 }, -- Silver Brooch
	{ id = 3026, chance = 1050 }, -- White Pearl
	{ id = 3033, chance = 1660 }, -- Small Amethyst
	{ id = 3037, chance = 4310 }, -- Yellow Gem
	{ id = 3038, chance = 3369 }, -- Green Gem
	{ id = 3297, chance = 2537 }, -- Serpent Sword
	{ id = 3575, chance = 1559 }, -- Wood Cape
	{ id = 9302, chance = 2350 }, -- Sacred Tree Amulet
	{ id = 22085, chance = 1402 }, -- Fur Armor
	{ id = 22193, chance = 2410 }, -- Onyx Chip
	{ id = 22194, chance = 2190 }, -- Opal
	{ id = 24391, chance = 1100 }, -- Coral Brooch
	{ id = 24392, chance = 1190 }, -- Gemmed Figurine
	{ id = 31340, chance = 1310 }, -- Lizard Heart
	{ id = 31488, chance = 2900 }, -- Scared Frog
	{ id = 31561, chance = 5726 }, -- Goanna Claw
	{ id = 31445, chance = 990 }, -- Small Tortoise
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, condition = { type = CONDITION_POISON, totalDamage = 200, interval = 4000 } },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -600, range = 3, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -380, radius = 2, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 3600, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -390, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 84,
	armor = 84,
	mitigation = 2.6,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
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
