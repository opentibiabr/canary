local mType = Game.createMonsterType("Orclops Ravager")
local monster = {}

monster.description = "an orclops ravager"
monster.experience = 1100
monster.outfit = {
	lookType = 935,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1320
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Desecrated Glade."
	}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 27742
monster.speed = 260
monster.manaCost = 290
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "It's clobberin time!", yell = false},
	{text = "Crushing! Smashing! Ripping! Yeah!!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 50320, maxCount = 120},
	{id = 2152, chance = 50320},
	{id = 7588, chance = 50320},
	{id = 2194, chance = 50320},
	{id = 2428, chance = 20000},
	{id = 2788, chance = 50320, maxCount = 3},
	{id = 26479, chance = 6000},
	{id = 27048, chance = 4900},
	{id = 27049, chance = 1800},
	{id = 27050, chance = 12750},
	{id = 2144, chance = 2510, maxCount = 2},
	{id = 2147, chance = 1940, maxCount = 2},
	{id = 7452, chance = 1000},
	{id = 8843, chance = 8870},
	{id = 9970, chance = 9700},
	{id = 18417, chance = 15290, maxCount = 3},
	{id = 20108, chance = 910},
	{id = 3953, chance = 910},
	{id = 7439, chance = 910},
	{id = 7419, chance = 300}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -180, maxDamage = -220, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true}
}

monster.defenses = {
	defense = 25,
	armor = 35,
	{name ="speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_HEALING, minDamage = 80, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
