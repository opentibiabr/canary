local mType = Game.createMonsterType("Schiach")
local monster = {}

monster.description = "a schiach"
monster.experience = 580
monster.outfit = {
	lookType = 1162,
	lookHead = 0,
	lookBody = 10,
	lookLegs = 38,
	lookFeet = 57,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1741
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

monster.health = 600
monster.maxHealth = 600
monster.race = "blood"
monster.corpse = 30298
monster.speed = 140
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
	canWalkOnFire = false,
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
	{ text = "Krik Krik!", yell = false },
	{ text = "Psh psh psh!!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 50 }, -- Gold Coin
	{ id = 30185, chance = 9900 }, -- Broken Bell
	{ id = 30208, chance = 13580 }, -- Fireworks Capsule
	{ id = 30271, chance = 8200 }, -- Grainy Fireworks Powder
	{ id = 823, chance = 1260 }, -- Glacier Kilt
	{ id = 25737, chance = 4210, maxCount = 2 }, -- Rainbow Quartz
	{ id = 30186, chance = 4960 }, -- Percht Horns
	{ id = 30187, chance = 4820 }, -- Versicolour Fireworks Powder
	{ id = 30188, chance = 2009 }, -- Red Fireworks Powder
	{ id = 30189, chance = 2420 }, -- Yellow Fireworks Powder
	{ id = 30190, chance = 2460 }, -- Green Fireworks Powder
	{ id = 30191, chance = 3550 }, -- Blue Fireworks Powder
	{ id = 30268, chance = 2290 }, -- Orange Fireworks Powder
	{ id = 30269, chance = 2460 }, -- Purple Fireworks Powder
	{ id = 30270, chance = 3470 }, -- Turquoise Fireworks Powder
	{ id = 30324, chance = 2720 }, -- Bright Bell
	{ id = 824, chance = 630 }, -- Glacier Robe
	{ id = 16118, chance = 520 }, -- Glacial Rod
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
	defense = 43,
	armor = 43,
	mitigation = 0.78,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
