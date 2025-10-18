local mType = Game.createMonsterType("Monk")
local monster = {}

monster.description = "a monk"
monster.experience = 200
monster.outfit = {
	lookType = 57,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 57
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Edron Hero Cave, Triangle Tower near Thais, Maze of Lost Souls, Deeper Dark Cathedral, \z
		Isle of the Kings, Trade Quarter.",
}

monster.health = 240
monster.maxHealth = 240
monster.race = "blood"
monster.corpse = 18090
monster.speed = 120
monster.manaCost = 600

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
	damage = 10,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = false,
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
	{ text = "Repent Heretic!", yell = false },
	{ text = "A prayer to the almighty one!", yell = false },
	{ text = "I will punish the sinners!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 14179, maxCount = 18 }, -- Gold Coin
	{ id = 3600, chance = 19880 }, -- Bread
	{ id = 9646, chance = 5700 }, -- Book of Prayers
	{ id = 3077, chance = 2490 }, -- Ankh
	{ id = 11492, chance = 2190 }, -- Rope Belt
	{ id = 2815, chance = 1900 }, -- Scroll
	{ id = 2885, chance = 1320 }, -- Brown Flask
	{ id = 2914, chance = 730 }, -- Lamp
	{ id = 3061, chance = 1320 }, -- Life Crystal
	{ id = 11493, chance = 879 }, -- Safety Pin
	{ id = 3551, chance = 1170 }, -- Sandals
	{ id = 3289, chance = 439 }, -- Staff
	{ id = 3050, chance = 1000 }, -- Power Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
}

monster.defenses = {
	defense = 30,
	armor = 25,
	mitigation = 1.37,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 30, maxDamage = 50, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
