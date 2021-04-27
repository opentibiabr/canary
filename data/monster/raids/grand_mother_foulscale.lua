local mType = Game.createMonsterType("Grand Mother Foulscale")
local monster = {}

monster.description = "Grand Mother Foulscale"
monster.experience = 1400
monster.outfit = {
	lookType = 34,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1850
monster.maxHealth = 1850
monster.race = "blood"
monster.corpse = 5973
monster.speed = 180
monster.manaCost = 0
monster.maxSummons = 4

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
	runHealth = 400,
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
	{name = "dragon hatchlings", chance = 40, interval = 4000, max = 4}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "GROOAAARRR!", yell = true}
}

monster.loot = {
	{id = 2148, chance = 37500, maxCount = 70},
	{id = 2148, chance = 37500, maxCount = 50},
	{id = 2546, chance = 4000, maxCount = 12},
	{id = 2672, chance = 15500, maxCount = 3},
	{id = 2406, chance = 25000},
	{id = 2398, chance = 21500},
	{id = 2509, chance = 14000},
	{id = 2455, chance = 10000},
	{id = 2397, chance = 5000},
	{id = 2457, chance = 3000},
	{id = 2647, chance = 2000},
	{id = 2413, chance = 2000},
	{id = 2387, chance = 1333},
	{id = 2187, chance = 1800},
	{id = 5920, chance = 100000},
	{id = 2434, chance = 600},
	{id = 5877, chance = 100000},
	{id = 2516, chance = 500},
	{id = 7430, chance = 650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -20, maxDamage = -170},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -45, maxDamage = -85, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_FIREDAMAGE, minDamage = -90, maxDamage = -150, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 27,
	{name ="combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 34, maxDamage = 66, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
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
