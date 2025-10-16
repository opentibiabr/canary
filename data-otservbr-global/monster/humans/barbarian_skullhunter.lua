local mType = Game.createMonsterType("Barbarian Skullhunter")
local monster = {}

monster.description = "a barbarian skullhunter"
monster.experience = 85
monster.outfit = {
	lookType = 254,
	lookHead = 0,
	lookBody = 77,
	lookLegs = 96,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 322
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ragnir, Krimhorn, Bittermor, and Fenrock.",
}

monster.health = 135
monster.maxHealth = 135
monster.race = "blood"
monster.corpse = 18066
monster.speed = 84
monster.manaCost = 450

monster.changeTarget = {
	interval = 60000,
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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 70,
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
	{ text = "You will become my trophy.", yell = false },
	{ text = "Fight harder, coward.", yell = false },
	{ text = "Show that you are a worthy opponent.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 30 }, -- gold coin
	{ id = 11050, chance = 80000 }, -- torch
	{ id = 3291, chance = 23000 }, -- knife
	{ id = 3354, chance = 23000 }, -- brass helmet
	{ id = 3367, chance = 23000 }, -- viking helmet
	{ id = 3377, chance = 5000 }, -- scale armor
	{ id = 266, chance = 1000 }, -- health potion
	{ id = 5913, chance = 1000 }, -- brown piece of cloth
	{ id = 3052, chance = 260 }, -- life ring
	{ id = 7449, chance = 260 }, -- crystal sword
	{ id = 7457, chance = 260 }, -- fur boots
	{ id = 7462, chance = 260 }, -- ragnir helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
}

monster.defenses = {
	defense = 0,
	armor = 8,
	mitigation = 0.33,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
