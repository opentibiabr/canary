local mType = Game.createMonsterType("Damned Soul")
local monster = {}

monster.description = "a damned soul"
monster.experience = 300
monster.outfit = {
	lookType = 232,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 800
monster.maxHealth = 800
monster.race = "undead"
monster.corpse = 25354
monster.speed = 380
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4
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
	runHealth = 800,
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
	{text = "Forgive Meeeee!", yell = false},
	{text = "Mouuuurn meeee!", yell = false},
	{text = "Help meee!", yell = false}
}

monster.loot = {
	{id = 2260, chance = 34550, maxCount = 3},
	{id = 6500, chance = 6990},
	{id = 11233, chance = 33070},
	{id = 2148, chance = 99940, maxCount = 198},
	{id = 2152, chance = 99940, maxCount = 3},
	{id = 7590, chance = 14200, maxCount = 2},
	{id = 7591, chance = 8810, maxCount = 2},
	{id = 5944, chance = 15000},
	{id = 2144, chance = 11930, maxCount = 3},
	{id = 2143, chance = 10800, maxCount = 3},
	{id = 9809, chance = 6200},
	{id = 9810, chance = 3350},
	{id = 5806, chance = 4940},
	{id = 2133, chance = 1590},
	{id = 2197, chance = 2560},
	{id = 2156, chance = 2050},
	{id = 2528, chance = 740},
	{id = 5741, chance = 170},
	{id = 2436, chance = 850},
	{id = 7413, chance = 1020},
	{id = 7407, chance = 740},
	{id = 6300, chance = 2160},
	{id = 6526, chance = 1250}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 76, attack = 100},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -90, maxDamage = -240, length = 3, spread = 0, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="lost soul paralyze", interval = 2000, chance = 18, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 25
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
