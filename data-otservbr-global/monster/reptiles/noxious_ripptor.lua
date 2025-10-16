local mType = Game.createMonsterType("Noxious Ripptor")
local monster = {}

monster.description = "a noxious ripptor"
monster.experience = 13190
monster.outfit = {
	lookType = 1558,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2276
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 1,
	Locations = "Crystal Enigma",
}

monster.health = 22700
monster.maxHealth = 22700
monster.race = "blood"
monster.corpse = 39323
monster.speed = 180
monster.manaCost = 0
monster.maxSummons = 0

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
	runHealth = 0,
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
	{ text = "Krccchht!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 39391, chance = 23000 }, -- ripptor scales
	{ id = 39389, chance = 23000, maxCount = 2 }, -- ripptor claw
	{ id = 7643, chance = 23000, maxCount = 2 }, -- ultimate health potion
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 16117, chance = 5000 }, -- muck rod
	{ id = 812, chance = 1000 }, -- terra legs
	{ id = 25699, chance = 1000 }, -- wooden spellbook
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1350 },
	{ name = "combat", interval = 2500, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -1100, maxDamage = -1700, range = 1, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "noxious ripptor wave", interval = 4500, chance = 30, minDamage = -450, maxDamage = -750 },
}

monster.defenses = {
	defense = 110,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
