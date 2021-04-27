local mType = Game.createMonsterType("The Plasmother")
local monster = {}

monster.description = "The Plasmother"
monster.experience = 12000
monster.outfit = {
	lookType = 238,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 6532
monster.speed = 310
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 5500,
	chance = 10
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
	runHealth = 250,
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
	{name = "Defiler", chance = 20, interval = 4000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Blubb", yell = false},
	{text = "Blubb Blubb", yell = false},
	{text = "Blubberdiblubb", yell = false}
}

monster.loot = {
	{id = 2148, chance = 20000, maxCount = 177},
	{id = 2152, chance = 25000, maxCount = 13},
	{id = 6500, chance = 45000},
	{id = 2144, chance = 5000, maxCount = 3},
	{id = 2146, chance = 5000, maxCount = 3},
	{id = 5944, chance = 35000},
	{id = 6535, chance = 100000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 30, attack = 50},
	{name ="speed", interval = 1000, chance = 8, speedChange = -800, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 10000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -350, radius = 4, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 3000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -530, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 1000, chance = 75, type = COMBAT_HEALING, minDamage = 505, maxDamage = 605, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 100},
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
