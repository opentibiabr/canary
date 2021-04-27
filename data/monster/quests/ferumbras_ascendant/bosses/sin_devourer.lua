local mType = Game.createMonsterType("Sin Devourer")
local monster = {}

monster.description = "a sin devourer"
monster.experience = 500
monster.outfit = {
	lookType = 320,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "undead"
monster.corpse = 0
monster.speed = 360
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 10,
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
	targetDistance = 4,
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
	{id = 2804, chance = 4830},
	{id = 2200, chance = 850},
	{id = 2171, chance = 120},
	{id = 2195, chance = 120},
	{id = 7589, chance = 1600},
	{id = 2148, chance = 89840, maxCount = 110},
	{id = 7407, chance = 320},
	{id = 7427, chance = 120},
	{id = 9942, chance = 130},
	{id = 2124, chance = 1030},
	{id = 8870, chance = 520}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 30, condition = {type = CONDITION_POISON, totalDamage = 80, interval = 4000}},
	{name ="nightstalker paralyze", interval = 2000, chance = 19, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -360, maxDamage = -470, range = 1, effect = CONST_ME_HOLYAREA, target = true},
	{name ="speed", interval = 2000, chance = 40, speedChange = -600, range = 6, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEAREA, target = true, duration = 20000},
	{name ="silencer skill reducer", interval = 2000, chance = 30, range = 4, effect = CONST_ME_POFF, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 30,
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_HEALING, minDamage = 60, maxDamage = 130, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_YELLOW_RINGS}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = 40},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 40},
	{type = COMBAT_HOLYDAMAGE , percent = 40},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
