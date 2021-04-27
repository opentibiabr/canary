local mType = Game.createMonsterType("Zamulosh3")
local monster = {}

monster.name = "Zamulosh"
monster.description = "Zamulosh"
monster.experience = 55000
monster.outfit = {
	lookType = 862,
	lookHead = 16,
	lookBody = 12,
	lookLegs = 73,
	lookFeet = 55,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "undead"
monster.corpse = 25151
monster.speed = 320
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.events = {
	"ZamuloshClone"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I AM ZAMULOSH!", yell = false}
}

monster.loot = {
	{id = 25172, chance = 1000000},
	{id = 2148, chance = 98000, maxCount = 200},
	{id = 7632, chance = 14000, maxCount = 5},
	{id = 7633, chance = 14000, maxCount = 5},
	{id = 2146, chance = 12000, maxCount = 9},
	{id = 2143, chance = 12000, maxCount = 8},
	{id = 2150, chance = 10000, maxCount = 5},
	{id = 9970, chance = 10000, maxCount = 8},
	{id = 2152, chance = 8000, maxCount = 58},
	{id = 6500, chance = 11000},
	{id = 18416, chance = 10000, maxCount = 6},
	{id = 18417, chance = 10000, maxCount = 6},
	{id = 18418, chance = 10000, maxCount = 6},
	{id = 2156, chance = 1000},
	{id = 2154, chance = 1000},
	{id = 2155, chance = 1000},
	{id = 2158, chance = 1000},
	{id = 2169, chance = 6000},
	{id = 2214, chance = 6000},
	{id = 25523, chance = 770},
	{id = 8878, chance = 770},
	{id = 25382, chance = 670},
	{id = 25418, chance = 500, unique = true},
	{id = 25211, chance = 500, unique = true}
}

monster.attacks = {
	{name ="melee", interval = 3000, chance = 100, minDamage = -200, maxDamage = -300},
	{name ="speed", interval = 1000, chance = 10, speedChange = -700, radius = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 8000}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
