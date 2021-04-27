local mType = Game.createMonsterType("Hellgorak")
local monster = {}

monster.description = "Hellgorak"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 19,
	lookBody = 96,
	lookLegs = 21,
	lookFeet = 81,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 25850
monster.maxHealth = 25850
monster.race = "blood"
monster.corpse = 6068
monster.speed = 330
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
	staticAttackChance = 85,
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
	{text = "I'll sacrifice yours souls to seven!", yell = false},
	{text = "I'm bad news for you mortals!", yell = false},
	{text = "No man can defeat me!", yell = false},
	{text = "Your puny skills are no match for me.", yell = false},
	{text = "I smell your fear.", yell = false},
	{text = "Delicious!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 200},
	{id = 9813, chance = 49920},
	{id = 8473, chance = 41750, maxCount = 2},
	{id = 8901, chance = 31010},
	{id = 9810, chance = 30560},
	{id = 3962, chance = 29950},
	{id = 2152, chance = 21790, maxCount = 30},
	{id = 8472, chance = 21180},
	{id = 7591, chance = 20570},
	{id = 2487, chance = 19670},
	{id = 7590, chance = 16190},
	{id = 2144, chance = 14070, maxCount = 25},
	{id = 2143, chance = 13920, maxCount = 25},
	{id = 7456, chance = 12860},
	{id = 2145, chance = 12860, maxCount = 25},
	{id = 2147, chance = 13010, maxCount = 5},
	{id = 2125, chance = 12710},
	{id = 2150, chance = 12410, maxCount = 25},
	{id = 2133, chance = 11800},
	{id = 2146, chance = 11650, maxCount = 25},
	{id = 7894, chance = 11350},
	{id = 9970, chance = 11200, maxCount = 25},
	{id = 2149, chance = 10740, maxCount = 25},
	{id = 2645, chance = 10740},
	{id = 8871, chance = 10590},
	{id = 2488, chance = 10140},
	{id = 8870, chance = 10140},
	{id = 2130, chance = 9680},
	{id = 2477, chance = 9530},
	{id = 5954, chance = 9230, maxCount = 2},
	{id = 8902, chance = 8770},
	{id = 8903, chance = 8620},
	{id = 2656, chance = 8170},
	{id = 2466, chance = 2870},
	{id = 7412, chance = 2720},
	{id = 7388, chance = 1970},
	{id = 8904, chance = 1360},
	{id = 7453, chance = 610},
	{id = 8926, chance = 450},
	{id = 2470, chance = 450},
	{id = 8879, chance = 450},
	{id = 8918, chance = 300},
	{id = 2136, chance = 150},
	{id = 2415, chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -910},
	{name ="combat", interval = 1000, chance = 11, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -819, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_MANADRAIN, minDamage = -90, maxDamage = -500, radius = 5, effect = CONST_ME_STUN, target = false},
	{name ="combat", interval = 1000, chance = 11, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -520, radius = 5, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -150, radius = 7, effect = CONST_ME_POFF, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 70,
	{name ="combat", interval = 1000, chance = 11, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 98},
	{type = COMBAT_ENERGYDAMAGE, percent = 98},
	{type = COMBAT_EARTHDAMAGE, percent = 98},
	{type = COMBAT_FIREDAMAGE, percent = 98},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = -305},
	{type = COMBAT_ICEDAMAGE, percent = 98},
	{type = COMBAT_HOLYDAMAGE , percent = 95},
	{type = COMBAT_DEATHDAMAGE , percent = 98}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
