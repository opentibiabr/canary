local mType = Game.createMonsterType("Eternal Guardian")
local monster = {}

monster.description = "an eternal guardian"
monster.experience = 1800
monster.outfit = {
	lookType = 345,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 615
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "North-east Muggy Plains, Deeper Banuta."
	}

monster.health = 2500
monster.maxHealth = 2500
monster.race = "undead"
monster.corpse = 11300
monster.speed = 204
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	runHealth = 0,
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
	{text = "Zzrrkrrch!", yell = false},
	{text = "<crackle>", yell = false}
}

monster.loot = {
	{name = "small stone", chance = 30230, maxCount = 10},
	{name = "gold coin", chance = 99930, maxCount = 100},
	{name = "platinum coin", chance = 99540, maxCount = 4},
	{name = "guardian halberd", chance = 560},
	{name = "tower shield", chance = 820},
	{name = "iron ore", chance = 1700},
	{name = "ancient stone", chance = 20020},
	{name = "shiny stone", chance = 800},
	{name = "Zaoan sword", chance = 100},
	{name = "Zaoan halberd", chance = 1860},
	{name = "spiked iron ball", chance = 9960},
	{name = "clay lump", chance = 720},
	{name = "piece of marble rock", chance = 430},
	{id = 13757, chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300}
}

monster.defenses = {
	defense = 40,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 70},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
