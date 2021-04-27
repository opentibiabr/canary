local mType = Game.createMonsterType("Man In The Cave")
local monster = {}

monster.description = "man in the cave"
monster.experience = 777
monster.outfit = {
	lookType = 128,
	lookHead = 77,
	lookBody = 59,
	lookLegs = 20,
	lookFeet = 116,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 485
monster.maxHealth = 485
monster.race = "blood"
monster.corpse = 20446
monster.speed = 210
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Monk", chance = 20, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "THE MONKS ARE MINE!", yell = true},
	{text = "I will rope you up! All of you!", yell = false},
	{text = "You have been roped up!", yell = false},
	{text = "A MIC to rule them all!", yell = false}
}

monster.loot = {
	{id = 2120, chance = 100000, maxCount = 3},
	{id = 7386, chance = 38000},
	{id = 5913, chance = 30000},
	{id = 2148, chance = 30000, maxCount = 39},
	{id = 7458, chance = 15000},
	{id = 7290, chance = 8000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -62},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -95, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="speed", interval = 2000, chance = 12, speedChange = 250, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 10, maxDamage = 50, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
