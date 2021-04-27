local mType = Game.createMonsterType("Schiach")
local monster = {}

monster.description = "an schiach"
monster.experience = 580
monster.outfit = {
	lookType = 1162,
	lookHead = 19,
	lookBody = 10,
	lookLegs = 19,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1741
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Percht Island."
	}

monster.health = 600
monster.maxHealth = 600
monster.race = "blood"
monster.corpse = 35127
monster.speed = 280
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 100,
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
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "Krik Krik!", yell = false},
	{text = "Psh psh psh!!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 50},
	{name = "fireworks capsule", chance = 13220},
	{name = "broken bell", chance = 11070},
	{name = "grainy fireworks powder", chance = 7700},
	{name = "versicolour fireworks powder", chance = 4290},
	{name = "percht horns", chance = 3960},
	{name = "bright bell", chance = 2920},
	{name = "green fireworks powder", chance = 2550},
	{name = "purple fireworks powder", chance = 2440},
	{name = "turquoise fireworks powder", chance = 40},
	{name = "orange fireworks powder", chance = 2260},
	{name = "yellow fireworks powder", chance = 2180},
	{name = "red fireworks powder", chance = 1780},
	{name = "glacier kilt", chance = 1180},
	{name = "glacier robe", chance = 630}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 70, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -125, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = false},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_ICEDAMAGE, minDamage = -90, maxDamage = -250, length = 3, spread = 0, effect = CONST_ME_GIANTICE, target = false},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, radius = 3, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -250, length = 3, spread = 0, effect = CONST_ME_FIREATTACK, target = false}
}

monster.defenses = {
	defense = 43,
	armor = 43
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
