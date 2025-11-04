local mType = Game.createMonsterType("Thornback Tortoise")
local monster = {}

monster.description = "a thornback tortoise"
monster.experience = 150
monster.outfit = {
	lookType = 198,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 259
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Laguna Islands, Meriana Gargoyle Cave and one on Nargor.",
}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 6073
monster.speed = 75
monster.manaCost = 490

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
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
}

monster.loot = {
	{ id = 3031, chance = 84082, maxCount = 48 }, -- Gold Coin
	{ id = 9643, chance = 6041 }, -- Thorn
	{ id = 3578, chance = 9497, maxCount = 2 }, -- Fish
	{ id = 266, chance = 812 }, -- Health Potion
	{ id = 3026, chance = 1350 }, -- White Pearl
	{ id = 3723, chance = 1287 }, -- White Mushroom
	{ id = 5899, chance = 1040 }, -- Turtle Shell
	{ id = 5678, chance = 1931, maxCount = 3 }, -- Tortoise Egg
	{ id = 3027, chance = 600 }, -- Black Pearl
	{ id = 3725, chance = 622 }, -- Brown Mushroom
	{ id = 3279, chance = 308 }, -- War Hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110, condition = { type = CONDITION_POISON, totalDamage = 40, interval = 4000 } },
}

monster.defenses = {
	defense = 40,
	armor = 24,
	mitigation = 0.70,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
