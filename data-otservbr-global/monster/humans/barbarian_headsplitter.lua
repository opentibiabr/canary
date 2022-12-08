local mType = Game.createMonsterType("Barbarian Headsplitter")
local monster = {}

monster.description = "a barbarian headsplitter"
monster.experience = 85
monster.outfit = {
	lookType = 253,
	lookHead = 115,
	lookBody = 86,
	lookLegs = 119,
	lookFeet = 113,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 333
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Krimhorn, Bittermor, Ragnir, and Fenrock."
	}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 18062
monster.speed = 84
monster.manaCost = 450

monster.changeTarget = {
	interval = 60000,
	chance = 0
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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I will regain my honor with your blood!", yell = false},
	{text = "Surrender is not option!", yell = false},
	{text = "Its you or me!", yell = false},
	{text = "Die! Die! Die!", yell = false}
}

monster.loot = {
	{id = 2920, chance = 60300}, -- torch
	{name = "gold coin", chance = 75600, maxCount = 30},
	{id = 3052, chance = 230}, -- life ring
	{name = "knife", chance = 14890},
	{name = "brass helmet", chance = 20140},
	{name = "viking helmet", chance = 5020},
	{id = 3114, chance = 8000, maxCount = 2}, -- skull
	{name = "scale armor", chance = 4060},
	{name = "brown piece of cloth", chance = 980},
	{name = "fur boots", chance = 90},
	{name = "krimhorn helmet", chance = 110},
	{name = "health potion", chance = 560}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -60, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true}
}

monster.defenses = {
	defense = 0,
	armor = 7
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
