local mType = Game.createMonsterType("Meandering Mushroom")
local monster = {}

monster.description = "Meandering Mushroom"
monster.experience = 24800
monster.outfit = {
	lookType = 1621,
}

monster.health = 29100
monster.maxHealth = 29100
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
	{ name = "crystal coin", chance = 11395, maxCount = 1 },
	{ name = "lichen gobbler", chance = 11807, maxCount = 1 },
	{ name = "white mushroom", chance = 9346, maxCount = 3 },
	{ name = "rotten root", chance = 11075, maxCount = 1 },
	{ name = "wand of decay", chance = 14572, maxCount = 1 },
	{ id = 3039, chance = 10134, maxCount = 1 }, -- red gem
	{ name = "worm sponge", chance = 11107, maxCount = 1 },
	{ name = "dark mushroom", chance = 13623, maxCount = 3 },
	{ name = "yellow gem", chance = 5026, maxCount = 1 },
	{ name = "brown mushroom", chance = 5263, maxCount = 3 },
	{ name = "terra amulet", chance = 10337, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -1300 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -0, maxDamage = -1100, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, target = true },
	{ name = "combat", interval = 1500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -0, maxDamage = -750, length = 4, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -0, maxDamage = -950, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -0, maxDamage = -750, radius = 4, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 42,
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
