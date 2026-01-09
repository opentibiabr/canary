local mType = Game.createMonsterType("Dark Monk")
local monster = {}

monster.description = "a dark monk"
monster.experience = 145
monster.outfit = {
	lookType = 225,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 225
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Dark Cathedral, Vandura (Cult Cave), Foreigner Quarter.",
}

monster.health = 190
monster.maxHealth = 190
monster.race = "blood"
monster.corpse = 18281
monster.speed = 115
monster.manaCost = 480

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
	damage = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
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
	{ text = "You are no match to us!", yell = false },
	{ text = "Your end has come!", yell = false },
	{ text = "This is where your path will end!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 14470, maxCount = 18 }, -- Gold Coin
	{ id = 3600, chance = 19338 }, -- Bread
	{ id = 10303, chance = 10365 }, -- Dark Rosary
	{ id = 11492, chance = 6030 }, -- Rope Belt
	{ id = 2815, chance = 19074 }, -- Scroll
	{ id = 9646, chance = 2133 }, -- Book of Prayers
	{ id = 268, chance = 792 }, -- Mana Potion
	{ id = 2914, chance = 1014 }, -- Lamp
	{ id = 3061, chance = 1073 }, -- Life Crystal
	{ id = 3077, chance = 1085 }, -- Ankh
	{ id = 3551, chance = 7744 }, -- Sandals
	{ id = 11493, chance = 940 }, -- Safety Pin
	{ id = 2885, chance = 4098 }, -- Brown Flask
	{ id = 3050, chance = 44 }, -- Power Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -20, maxDamage = -50, range = 1, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 22,
	mitigation = 1.13,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 25, maxDamage = 49, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
