local mType = Game.createMonsterType("Dawnfly")
local monster = {}

monster.description = "a dawnfly"
monster.experience = 35
monster.outfit = {
	lookType = 528,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 90
monster.maxHealth = 90
monster.race = "venom"
monster.corpse = 23825
monster.speed = 200
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
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
	{id = 23839, chance = 21360, maxCount = 16},
	{id = 2485, chance = 4140},
	{id = 19738, chance = 11940},
	{id = 19743, chance = 10130},
	{id = 2148, chance = 100000, maxCount = 12},
	{id = 7618, chance = 3630},
	{id = 7620, chance = 3800},
	{id = 2545, chance = 14500, maxCount = 8}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 16, condition = {type = CONDITION_POISON, totalDamage = 8, interval = 4000}},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -4, maxDamage = -8, range = 7, shootEffect = CONST_ANI_POISONARROW, target = false}
}

monster.defenses = {
	defense = 2,
	armor = 1,
	{name ="speed", interval = 2000, chance = 11, speedChange = 238, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
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
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
