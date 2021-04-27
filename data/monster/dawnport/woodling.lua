local mType = Game.createMonsterType("Woodling")
local monster = {}

monster.description = "a woodling"
monster.experience = 40
monster.outfit = {
	lookType = 535,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 80
monster.maxHealth = 80
monster.race = "blood"
monster.corpse = 23817
monster.speed = 130
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
	{id = 23839, chance = 9450, maxCount = 10},
	{id = 2148, chance = 100000, maxCount = 12},
	{id = 20103, chance = 14500},
	{id = 2120, chance = 5700},
	{id = 2484, chance = 4950},
	{id = 2526, chance = 2670},
	{id = 20102, chance = 20250},
	{id = 2787, chance = 18200, maxCount = 4}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 14},
	{name ="woodling paralyze", interval = 2000, chance = 10, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -4, maxDamage = -9, range = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_INSECTS, target = false}
}

monster.defenses = {
	defense = 2,
	armor = 1
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
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
