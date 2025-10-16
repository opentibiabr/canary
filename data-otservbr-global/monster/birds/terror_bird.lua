local mType = Game.createMonsterType("Terror Bird")
local monster = {}

monster.description = "a terror bird"
monster.experience = 150
monster.outfit = {
	lookType = 218,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 218
monster.Bestiary = {
	class = "Bird",
	race = BESTY_RACE_BIRD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Around Port Hope, Arena and Zoo Quarter in Yalahar, few on Zao steppes.",
}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 6057
monster.speed = 106
monster.manaCost = 490

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	{ text = "Carrah! Carrah!", yell = false },
	{ text = "Gruuuh Gruuuh.", yell = false },
	{ text = "CRAAAHHH!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 30 }, -- gold coin
	{ id = 3577, chance = 80000, maxCount = 3 }, -- meat
	{ id = 10273, chance = 80000 }, -- terrorbird beak
	{ id = 3492, chance = 80000 }, -- worm
	{ id = 11514, chance = 5000 }, -- colourful feather
	{ id = 266, chance = 1000 }, -- health potion
	{ id = 647, chance = 260 }, -- seeds
	{ id = 3406, chance = 260 }, -- feather headdress
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90 },
}

monster.defenses = {
	defense = 13,
	armor = 13,
	mitigation = 0.54,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
