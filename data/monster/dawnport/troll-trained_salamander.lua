local mType = Game.createMonsterType("Troll-Trained Salamander")
local monster = {}

monster.description = "a troll-trained salamander"
monster.experience = 23
monster.outfit = {
	lookType = 529,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 70
monster.maxHealth = 70
monster.race = "blood"
monster.corpse = 19707
monster.speed = 112
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	{id = 2386, chance = 5080},
	{id = 2449, chance = 4630},
	{id = 23839, chance = 17650, maxCount = 5},
	{id = 2148, chance = 100000, maxCount = 11},
	{id = 2458, chance = 6300},
	{id = 7618, chance = 1520},
	{id = 19737, chance = 34410, maxCount = 5},
	{id = 2666, chance = 9940},
	{id = 2545, chance = 2970, maxCount = 2},
	{id = 2406, chance = 4470},
	{id = 2554, chance = 5080},
	{id = 2482, chance = 4070}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 11, condition = {type = CONDITION_POISON, totalDamage = 5, interval = 4000}},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -4, maxDamage = -6, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_HITBYPOISON, target = true}
}

monster.defenses = {
	defense = 0,
	armor = 0
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
