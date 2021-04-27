local mType = Game.createMonsterType("Quara Mantassin")
local monster = {}

monster.description = "a quara mantassin"
monster.experience = 400
monster.outfit = {
	lookType = 72,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 241
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Calassa, Frozen Trench, Yalahar (Sunken Quarter)."
	}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 6064
monster.speed = 590
monster.manaCost = 480
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 40,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
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
	{text = "Zuerk Pachak!", yell = false},
	{text = "Shrrrr", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 5000, maxCount = 100},
	{name = "gold coin", chance = 29000, maxCount = 29},
	{name = "mantassin tail", chance = 12600},
	{name = "shrimp", chance = 5170, maxCount = 5},
	{name = "halberd", chance = 4970},
	{name = "small sapphire", chance = 1130},
	{name = "cape", chance = 1090},
	{name = "stealth ring", chance = 1050},
	{name = "two handed sword", chance = 990},
	{name = "fish fin", chance = 610},
	{name = "strange helmet", chance = 100},
	{name = "blue robe", chance = 60}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -138, effect = CONST_ME_DRAWBLOOD}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE},
	{name ="speed", interval = 2000, chance = 15, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -25},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
