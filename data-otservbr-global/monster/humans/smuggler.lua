local mType = Game.createMonsterType("Smuggler")
local monster = {}

monster.description = "a smuggler"
monster.experience = 48
monster.outfit = {
	lookType = 134,
	lookHead = 95,
	lookBody = 0,
	lookLegs = 113,
	lookFeet = 115,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 222
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Around Dark Cathedral, Tiquanda Bandit Caves, the Outlaw Camp, Tyrsung, Yalahar and Nargor.",
}

monster.health = 130
monster.maxHealth = 130
monster.race = "blood"
monster.corpse = 18226
monster.speed = 88
monster.manaCost = 390

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{ text = "You saw something you shouldn't!", yell = false },
	{ text = "I will silence you forever!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 79830, maxCount = 10 }, -- Gold Coin
	{ id = 2920, chance = 42621, maxCount = 2 }, -- Torch
	{ id = 3291, chance = 9491 }, -- Knife
	{ id = 3294, chance = 9673 }, -- Short Sword
	{ id = 3355, chance = 9498 }, -- Leather Helmet
	{ id = 3559, chance = 15313 }, -- Leather Legs
	{ id = 3582, chance = 9802 }, -- Ham
	{ id = 3264, chance = 5234 }, -- Sword
	{ id = 3292, chance = 4488 }, -- Combat Knife
	{ id = 8012, chance = 12394, maxCount = 5 }, -- Raspberry
	{ id = 7397, chance = 200 }, -- Deer Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
}

monster.defenses = {
	defense = 15,
	armor = 8,
	mitigation = 0.33,
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
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
