local mType = Game.createMonsterType("Goldhanded Cultist")
local monster = {}

monster.description = "a goldhanded cultist"
monster.experience = 2000
monster.outfit = {
	lookType = 132,
	lookHead = 95,
	lookBody = 79,
	lookLegs = 41,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 1481
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Museum of Tibian Arts."
	}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 3058
monster.speed = 230
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "Give me your money!", yell = false},
	{text = "Your backpack looks very compelling!", yell = false},
	{text = "You can't ever be rich enough!", yell = false}
}

monster.loot = {
	{name = "golden backpack", chance = 4290},
	{name = "tiger eye", chance = 11430},
	{id = 2148, chance = 41430, maxCount = 235},
	{name = "golden brush", chance = 20000},
	{name = "green gem", chance = 5710},
	{name = "gold ingot", chance = 2860},
	{name = "opal", chance = 11430},
	{name = "yellow gem", chance = 5710},
	{id = 1997, chance = 1430}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", interval = 3000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -150, radius = 5, target = false},
	{name ="combat", interval = 3000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -200, effect = CONST_ME_LOSEENERGY, target = true},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -250, range = 5, radius = 2, target = true}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="speed", interval = 2000, chance = 30, speedChange = 290, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -30},
	{type = COMBAT_ENERGYDAMAGE, percent = -20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
