local mType = Game.createMonsterType("Quara Pincher")
local monster = {}

monster.description = "a quara pincher"
monster.experience = 1500
monster.outfit = {
	lookType = 77,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 245
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Calassa, Frozen Trench, Yalahar (Sunken Quarter).",
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 6063
monster.speed = 198
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Clank! Clank!", yell = false },
	{ text = "Clap!", yell = false },
	{ text = "Crrrk! Crrrk!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 150 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 3269, chance = 23000 }, -- halberd
	{ id = 11490, chance = 23000 }, -- quara pincers
	{ id = 3030, chance = 23000, maxCount = 2 }, -- small ruby
	{ id = 3581, chance = 5000, maxCount = 5 }, -- shrimp
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 3369, chance = 5000 }, -- warrior helmet
	{ id = 3381, chance = 260 }, -- crown armor
	{ id = 824, chance = 260 }, -- glacier robe
	{ id = 12318, chance = 260 }, -- giant shrimp
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -342, effect = CONST_ME_DRAWBLOOD },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, range = 1, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.defenses = {
	defense = 50,
	armor = 85,
	mitigation = 0.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
