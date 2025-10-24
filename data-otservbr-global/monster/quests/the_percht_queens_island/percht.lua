local mType = Game.createMonsterType("Percht")
local monster = {}

monster.description = "a percht"
monster.experience = 600
monster.outfit = {
	lookType = 1161,
	lookHead = 95,
	lookBody = 42,
	lookLegs = 21,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1740
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Percht Island",
}

monster.health = 620
monster.maxHealth = 620
monster.race = "blood"
monster.corpse = 30296
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Krikik krikik!", yell = false },
	{ text = "Shzzzp shzzzp shzzp!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 60 }, -- Gold Coin
	{ id = 30208, chance = 11860 }, -- Fireworks Capsule
	{ id = 30186, chance = 9420 }, -- Percht Horns
	{ id = 30271, chance = 5840 }, -- Grainy Fireworks Powder
	{ id = 30187, chance = 4050 }, -- Versicolour Fireworks Powder
	{ id = 30185, chance = 4960 }, -- Broken Bell
	{ id = 30325, chance = 3100 }, -- Dark Bell
	{ id = 30191, chance = 3130 }, -- Blue Fireworks Powder
	{ id = 30190, chance = 2940 }, -- Green Fireworks Powder
	{ id = 30268, chance = 1970 }, -- Orange Fireworks Powder
	{ id = 30189, chance = 1790 }, -- Yellow Fireworks Powder
	{ id = 30269, chance = 2000 }, -- Purple Fireworks Powder
	{ id = 30270, chance = 2050 }, -- Turquoise Fireworks Powder
	{ id = 30188, chance = 1940 }, -- Red Fireworks Powder
	{ id = 827, chance = 1200 }, -- Magma Monocle
	{ id = 817, chance = 1480 }, -- Magma Amulet
	{ id = 826, chance = 1250 }, -- Magma Coat
	{ id = 821, chance = 600 }, -- Magma Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 70, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -125, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ICEDAMAGE, minDamage = -90, maxDamage = -250, length = 3, spread = 0, effect = CONST_ME_GIANTICE, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, radius = 3, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, length = 3, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 0.83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
