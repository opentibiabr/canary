local mType = Game.createMonsterType("Bloated Man-Maggot")
local monster = {}

monster.description = "Bloated Man-Maggot"
monster.experience = 24740
monster.outfit = {
	lookType = 1654,
}

monster.health = 31700
monster.maxHealth = 31700
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
	{ name = "Crystal Coin", chance = 25000, maxCount = 10 },
	{ name = "Organic Acid", chance = 25000 },
	{ name = "Life Ring", chance = 25000 },
	{ name = "Terra Rod", chance = 25000 },
	{ name = "Small Topaz", chance = 5000, maxCount = 1 },
	{ name = "Rotten Roots", chance = 5000 },
	{ name = "Bloated Maggot", chance = 25000 },
	{ name = "Devil Helmet", chance = 5000 },
	{ name = "Butcher's Axe", chance = 5000 },
	{ name = "Violet Gem", chance = 3000 },
	{ name = "Blue Gem", chance = 3000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1250 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -1000, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, target = true },
	{ name = "combat", interval = 1500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -1150, length = 4, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -750, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -950, radius = 4, effect = CONST_ME_FIREAREA, target = false },
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
