local mType = Game.createMonsterType("Enraged Soul")
local monster = {}

monster.description = "an enraged soul"
monster.experience = 120
monster.outfit = {
	lookType = 568,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 150
monster.maxHealth = 150
monster.race = "undead"
monster.corpse = 19051
monster.speed = 80
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
}

monster.loot = {
	{ id = 3282, chance = 10610 }, -- morning star
	{ id = 3292, chance = 7020 }, -- combat knife
	{ id = 3740, chance = 14400 }, -- shadow herb
	{ id = 3565, chance = 8810 }, -- cape
	{ id = 2828, chance = 1310 }, -- book
	{ id = 5909, chance = 1940 }, -- white piece of cloth
	{ id = 9690, chance = 1870 }, -- ghostly tissue
	{ id = 3432, chance = 860 }, -- ancient shield
	{ id = 3049, chance = 180 }, -- stealth ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 30, attack = 40 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -25, maxDamage = -45, range = 1, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 10,
	mitigation = 0.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
