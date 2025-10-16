local mType = Game.createMonsterType("Crazed Winter Vanguard")
local monster = {}

monster.description = "a crazed winter vanguard"
monster.experience = 5400
monster.outfit = {
	lookType = 1137,
	lookHead = 8,
	lookBody = 67,
	lookLegs = 8,
	lookFeet = 1,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1730
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Winter, Dream Labyrinth.",
}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "blood"
monster.corpse = 30122
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Nobody will ever escape from this place, muwahaha!!!", yell = false },
	{ text = "These voices… they never stop!", yell = false },
	{ text = " I am getting crazy here...Wa wa wahhh!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 13 }, -- platinum coin
	{ id = 676, chance = 23000 }, -- small enchanted ruby
	{ id = 11474, chance = 23000 }, -- miraculum
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 30005, chance = 23000 }, -- dream essence egg
	{ id = 24961, chance = 23000 }, -- tiger eye
	{ id = 8083, chance = 23000 }, -- northwind rod
	{ id = 815, chance = 23000 }, -- glacier amulet
	{ id = 3284, chance = 23000 }, -- ice rapier
	{ id = 824, chance = 5000 }, -- glacier robe
	{ id = 3082, chance = 1000 }, -- elven amulet
	{ id = 3041, chance = 260 }, -- blue gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, range = 5, radius = 1, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, length = 4, spread = 0, effect = CONST_ME_GIANTICE, target = false },
	{ name = "combat", interval = 3500, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -300, radius = 3, effect = CONST_ME_ICEAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 77,
	mitigation = 2.16,
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
