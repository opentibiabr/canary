local mType = Game.createMonsterType("Deathbine")
local monster = {}

monster.description = "Deathbine"
monster.experience = 340
monster.outfit = {
	lookType = 120,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 525
monster.maxHealth = 525
monster.race = "venom"
monster.corpse = 6047
monster.speed = 240
monster.manaCost = 0
monster.maxSummons = 0

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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 11217, chance = 100000},
	{id = 2152, chance = 100000, maxCount = 5},
	{id = 2804, chance = 100000},
	{id = 2149, chance = 100000, maxCount = 4},
	{id = 2792, chance = 50000},
	{id = 7732, chance = 50000},
	{id = 7887, chance = 50000},
	{id = 7886, chance = 50000},
	{id = 8912, chance = 50000},
	{id = 5015, chance = 5555},
	{id = 13307, chance = 2854}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 30, attack = 100, condition = {type = CONDITION_POISON, totalDamage = 5, interval = 4000}},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -90, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="speed", interval = 1000, chance = 34, speedChange = -850, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false, duration = 30000},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -130, radius = 3, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 10,
	armor = 26
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 35},
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
