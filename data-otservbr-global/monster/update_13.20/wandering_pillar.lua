local mType = Game.createMonsterType("Wandering Pillar")
local monster = {}

monster.description = "Wandering Pillar"
monster.experience = 24300
monster.outfit = {
	lookType = 1657,
}

monster.health = 37000
monster.maxHealth = 37000
monster.race = "blood"
monster.corpse = 26133
monster.speed = 585
monster.manaCost = 0
monster.maxSummons = 8

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

monster.summon = {
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "crystal coin", chance = 12284, maxCount = 1 },
	{ name = "darklight obsidian axe", chance = 11325, maxCount = 1 },
	{ name = "basalt crumb", chance = 10903, maxCount = 1 },
	{ name = "sulphurous stone", chance = 6944, maxCount = 1 },
	{ name = "magma boots", chance = 10262, maxCount = 1 },
	{ name = "coal", chance = 14093, maxCount = 4 },
	{ name = "dark helmet", chance = 12961, maxCount = 1 },
	{ name = "magma coat", chance = 14890, maxCount = 1 },
	{ name = "onyx chip", chance = 7210, maxCount = 2 },
	{ name = "darklight core (object)", chance = 12637, maxCount = 1 },
	{ name = "fire sword", chance = 8572, maxCount = 1 },
	{ name = "magma clump", chance = 11579, maxCount = 1 },
	{ id = 3039, chance = 11620, maxCount = 1 }, -- red gem
	{ name = "green gem", chance = 6308, maxCount = 1 },
	{ name = "basalt core", chance = 6038, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -1300 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -1000, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, target = true },
	{ name = "combat", interval = 1500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -950, length = 4, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -950, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -950, radius = 4, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 10 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
