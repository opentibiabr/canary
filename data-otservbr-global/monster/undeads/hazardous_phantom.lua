local mType = Game.createMonsterType("Hazardous Phantom")
local monster = {}

monster.description = "a hazardous phantom"
monster.experience = 66000
monster.outfit = {
	lookType = 1298,
	lookHead = 114,
	lookBody = 80,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 70000
monster.maxHealth = 70000
monster.race = "undead"
monster.corpse = 34125
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
}

monster.loot = {
	{ name = "crystal coin", chance = 97640, maxCount = 4 },
	{ name = "ultimate health potion", chance = 77950, maxCount = 5 },
	{ name = "gold ingot", chance = 23620 },
	{ name = "hailstorm rod", chance = 10240 },
	{ name = "green gem", chance = 7090 },
	{ name = "violet gem", chance = 5510 },
	{ name = "gemmed figurine", chance = 4720 },
	{ name = "hazardous robe", chance = 4720 },
	{ name = "hazardous heart", chance = 3940 },
	{ name = "blue gem", chance = 3150 },
	{ name = "northwind rod", chance = 2360 },
	{ name = "glacier robe", chance = 2360 },
	{ id = 282, chance = 1570 }, -- giant shimmering pearl
	{ name = "wand of everblazing", chance = 790 },
	{ id = 23542, chance = 790 }, -- collar of blue plasma
	{ id = 34109, chance = 20 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1050, maxDamage = -1400, range = 7, radius = 3, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -900, maxDamage = -1250, length = 6, spread = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -1050, maxDamage = -1100, radius = 3, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -1050, maxDamage = -1300, range = 7, radius = 4, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "ice chain", interval = 2000, chance = 15, minDamage = -1300, maxDamage = -1500, range = 7 },
	{ name = "soulwars fear", interval = 2000, chance = 2, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 4.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
