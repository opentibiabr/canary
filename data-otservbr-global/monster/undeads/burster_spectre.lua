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
	{ id = 3035, chance = 75000, maxCount = 7 }, -- Platinum Coin
	{ id = 7642, chance = 23000, maxCount = 3 }, -- Great Spirit Potion
	{ id = 3084, chance = 7600 }, -- Protection Amulet
	{ id = 3061, chance = 7400 }, -- Life Crystal
	{ id = 8094, chance = 3500 }, -- Wand of Voodoo
	{ id = 3073, chance = 3000 }, -- Wand of Cosmic Energy
	{ id = 30203, chance = 2100 }, -- Blue Ectoplasm
	{ id = 815, chance = 2000 }, -- Glacier Amulet
	{ id = 3085, chance = 2000 }, -- Dragon Necklace
	{ id = 3055, chance = 1700 }, -- Platinum Amulet
	{ id = 3060, chance = 1300 }, -- Orb
	{ id = 3067, chance = 890 }, -- Hailstorm Rod
	{ id = 30180, chance = 720 }, -- Hexagonal Ruby
	{ id = 16118, chance = 640 }, -- Glacial Rod
	{ id = 3082, chance = 470 }, -- Elven Amulet
	{ id = 3083, chance = 460 }, -- Garlic Necklace
	{ id = 9304, chance = 320 }, -- Shockwave Amulet
	{ id = 3081, chance = 240 }, -- Stone Skin Amulet
	{ id = 3062, chance = 160 }, -- Mind Stone
	{ id = 3058, chance = 160 }, -- Strange Symbol
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
