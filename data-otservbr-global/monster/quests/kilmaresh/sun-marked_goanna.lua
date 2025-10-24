local mType = Game.createMonsterType("Sun-Marked Goanna")
local monster = {}

monster.description = "a sun-marked goanna"
monster.experience = 7600
monster.outfit = {
	lookType = 1195,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 7800
monster.maxHealth = 7800
monster.race = "blood"
monster.corpse = 31405
monster.speed = 95
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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
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
}

monster.loot = {
	{ id = 31428, chance = 100000 }, -- Goanna Hide with Sun Symbol
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 16143, chance = 64288 }, -- Envenomed Arrow
	{ id = 31488, chance = 50000 }, -- Scared Frog
	{ id = 3299, chance = 50000 }, -- Poison Dagger
	{ id = 774, chance = 25000 }, -- Earth Arrow
	{ id = 3065, chance = 8330 }, -- Terra Rod
	{ id = 830, chance = 8330 }, -- Terra Hood
	{ id = 31561, chance = 8330 }, -- Goanna Claw
	{ id = 814, chance = 8330 }, -- Terra Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350, condition = { type = CONDITION_POISON, totalDamage = 19, interval = 4000 } },
	{ name = "wave t", interval = 2000, chance = 10, minDamage = -250, maxDamage = -380, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -450, maxDamage = -550, range = 3, radius = 1, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -210, maxDamage = -300, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 84,
	armor = 84,
	mitigation = 2.60,
	{ name = "speed", interval = 2000, chance = 5, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 1 },
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
