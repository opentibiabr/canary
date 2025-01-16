local mType = Game.createMonsterType("Revoada Minion Mage")
local monster = {}

monster.name = "Sanguinary Minion"
monster.description = "a revoada sanguinary minion"
monster.experience = 1000
monster.outfit = {
	lookType = 1712,
}

monster.health = 92000
monster.maxHealth = 92000
monster.race = "blood"
monster.corpse = 4240
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 50,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 3,
	runHealth = 500,
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
	{ text = "I will help you my boss.", yell = false },
	{ text = "Wait for me, for this century battle!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ICEDAMAGE, minDamage = -400, maxDamage = -1200, effect = CONST_ME_ICEATTACK },
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -500, maxDamage = -1400, radius = 8, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 5000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -400, maxDamage = -1200, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1400, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "strength", interval = 3000, chance = 30, radius = 10, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{ name = "combat", interval = 2000, chance = 70, type = COMBAT_HEALING, minDamage = 3000, maxDamage = 8000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 1000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 20 },
	{ type = COMBAT_MANADRAIN, percent = 20 },
	{ type = COMBAT_DROWNDAMAGE, percent = -10 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
