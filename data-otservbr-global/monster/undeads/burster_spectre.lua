local mType = Game.createMonsterType("Burster Spectre")
local monster = {}

monster.description = "a burster spectre"
monster.experience = 6000
monster.outfit = {
	lookType = 1122,
	lookHead = 9,
	lookBody = 10,
	lookLegs = 86,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1726
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Tomb west of Darashia, Buried Cathedral.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 30163
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We came tooo thiiiiss wooorld to... get youuu!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 95548, maxCount = 7 }, -- Platinum Coin
	{ id = 7642, chance = 30498, maxCount = 3 }, -- Great Spirit Potion
	{ id = 3084, chance = 10664 }, -- Protection Amulet
	{ id = 3061, chance = 8985 }, -- Life Crystal
	{ id = 8094, chance = 4644 }, -- Wand of Voodoo
	{ id = 3073, chance = 3838 }, -- Wand of Cosmic Energy
	{ id = 3085, chance = 2441 }, -- Dragon Necklace
	{ id = 30203, chance = 1849 }, -- Blue Ectoplasm
	{ id = 815, chance = 2844 }, -- Glacier Amulet
	{ id = 3060, chance = 1542 }, -- Orb
	{ id = 3055, chance = 1718 }, -- Platinum Amulet
	{ id = 3067, chance = 1089 }, -- Hailstorm Rod
	{ id = 30180, chance = 1046 }, -- Hexagonal Ruby
	{ id = 16118, chance = 676 }, -- Glacial Rod
	{ id = 3062, chance = 296 }, -- Mind Stone
	{ id = 3082, chance = 373 }, -- Elven Amulet
	{ id = 3083, chance = 483 }, -- Garlic Necklace
	{ id = 9304, chance = 432 }, -- Shockwave Amulet
	{ id = 3058, chance = 224 }, -- Strange Symbol
	{ id = 3081, chance = 3243 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2700, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -400, radius = 1, range = 5, effect = CONST_ME_ICEAREA, target = true }, --ice box
	{ name = "combat", interval = 3500, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -400, radius = 5, range = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true }, --ava
	{ name = "combat", interval = 3900, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -400, range = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- icicle
	{ name = "combat", interval = 4400, chance = 27, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -450, length = 4, spread = 2, effect = CONST_ME_ICEATTACK, target = false }, -- wave
	{ name = "combat", interval = 5500, chance = 47, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -400, radius = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false }, -- life drain bomb
}

monster.defenses = {
	defense = 70,
	armor = 70,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 133 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
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
