local mType = Game.createMonsterType("Minotaur Occultist")
local monster = {}

monster.description = "a minotaur occultist"
monster.experience = 100
monster.outfit = {
	lookType = 23,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 125
monster.maxHealth = 125
monster.race = "blood"
monster.corpse = 5981
monster.speed = 85
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
	illusionable = true,
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
	{ id = 3031, chance = 80000, maxCount = 21 }, -- gold coin
	{ id = 15634, chance = 80000, maxCount = 4 }, -- carrot
	{ id = 3559, chance = 80000 }, -- leather legs
	{ id = 17824, chance = 80000 }, -- swampling club
	{ id = 268, chance = 5000 }, -- mana potion
	{ id = 11050, chance = 5000 }, -- torch
	{ id = 3355, chance = 5000 }, -- leather helmet
	{ id = 3047, chance = 1000 }, -- magic light wand
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -20, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -20, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "energyfield", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGYBALL, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 8,
	mitigation = 0.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
