local mType = Game.createMonsterType("Latrivan")
local monster = {}

monster.description = "Latrivan"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 120,
	lookBody = 128,
	lookLegs = 121,
	lookFeet = 111,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "fire"
monster.corpse = 8721
monster.speed = 390
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
	{text = "I might reward you for killing my brother ~ with a swift death!", yell = true},
	{text = "Colateral damage is so fun!", yell = false},
	{text = "Golgordan you fool!", yell = false},
	{text = "We are the brothers of fear!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 273},
	{id = 7591, chance = 55000},
	{id = 2387, chance = 30000},
	{id = 6300, chance = 25000},
	{id = 2214, chance = 25000},
	{id = 2144, chance = 20000, maxCount = 13},
	{id = 2149, chance = 20000, maxCount = 10},
	{id = 2396, chance = 15000},
	{id = 2162, chance = 15000},
	{id = 2170, chance = 15000},
	{id = 2146, chance = 15000, maxCount = 10},
	{id = 2143, chance = 15000, maxCount = 13},
	{id = 2520, chance = 10000},
	{id = 6500, chance = 10000},
	{id = 2167, chance = 10000},
	{id = 2393, chance = 10000},
	{id = 9971, chance = 10000},
	{id = 2179, chance = 10000},
	{id = 2470, chance = 10000},
	{id = 2158, chance = 5000},
	{id = 2462, chance = 5000},
	{id = 2432, chance = 5000},
	{id = 2155, chance = 5000},
	{id = 2164, chance = 5000},
	{id = 2402, chance = 5000},
	{id = 2150, chance = 15000, maxCount = 12},
	{id = 2182, chance = 5000},
	{id = 2165, chance = 5000},
	{id = 2197, chance = 5000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -850, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -250, length = 7, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, range = 4, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 1},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -1},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
