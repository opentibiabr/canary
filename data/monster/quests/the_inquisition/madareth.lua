local mType = Game.createMonsterType("Madareth")
local monster = {}

monster.description = "Madareth"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 77,
	lookBody = 116,
	lookLegs = 82,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "fire"
monster.corpse = 8721
monster.speed = 165
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
	runHealth = 1200,
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
	{text = "I am going to play with yourself!", yell = true},
	{text = "Feel my wrath!", yell = false},
	{text = "No one matches my battle prowess!", yell = false},
	{text = "You will all die!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 150},
	{id = 9813, chance = 59000},
	{id = 9810, chance = 40000},
	{id = 7443, chance = 33000},
	{id = 7591, chance = 30000},
	{id = 8472, chance = 30000},
	{id = 7440, chance = 28000},
	{id = 7439, chance = 23000},
	{id = 7590, chance = 21000},
	{id = 6300, chance = 19000},
	{id = 2183, chance = 19000},
	{id = 2370, chance = 19000},
	{id = 2152, chance = 19000, maxCount = 26},
	{id = 2377, chance = 19000},
	{id = 7404, chance = 16000},
	{id = 2208, chance = 16000},
	{id = 8473, chance = 16000},
	{id = 8910, chance = 16000},
	{id = 2209, chance = 14000},
	{id = 6500, chance = 14000},
	{id = 7407, chance = 14000},
	{id = 2071, chance = 14000},
	{id = 7418, chance = 14000},
	{id = 8912, chance = 14000},
	{id = 3953, chance = 14000},
	{id = 2187, chance = 11000},
	{id = 8922, chance = 11000},
	{id = 7416, chance = 9500},
	{id = 7449, chance = 9500},
	{id = 2214, chance = 9500},
	{id = 5954, chance = 7000, maxCount = 2},
	{id = 2168, chance = 7000},
	{id = 7383, chance = 7000},
	{id = 2169, chance = 7000},
	{id = 8920, chance = 7000},
	{id = 2079, chance = 7000},
	{id = 2070, chance = 7000},
	{id = 3952, chance = 4700},
	{id = 2213, chance = 4700},
	{id = 2396, chance = 4700},
	{id = 7386, chance = 4700},
	{id = 2207, chance = 4700}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -180, maxDamage = -660, radius = 4, effect = CONST_ME_PURPLEENERGY, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -850, length = 5, spread = 2, effect = CONST_ME_BLACKSMOKE, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -200, radius = 4, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -250, radius = 5, effect = CONST_ME_MAGIC_RED, target = true}
}

monster.defenses = {
	defense = 46,
	armor = 48,
	{name ="combat", interval = 3000, chance = 14, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 99},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 95}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
