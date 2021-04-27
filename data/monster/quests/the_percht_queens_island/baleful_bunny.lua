local mType = Game.createMonsterType("Baleful Bunny")
local monster = {}

monster.description = "an baleful bunny"
monster.experience = 450
monster.outfit = {
	lookType = 1157,
	lookHead = 95,
	lookBody = 42,
	lookLegs = 19,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1742
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Percht Island."
	}

monster.health = 500
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 35137
monster.speed = 340
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
	{text = "Borborygmus... borborygmus...", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 100000},
	{name = "terra amulet", chance = 8480},
	{name = "snakebite rod", chance = 7420},
	{name = "leaf star", chance = 7120, maxCount = 2},
	{name = "lightning pendant", chance = 6820},
	{name = "strange talisman", chance = 5760},
	{name = "sacred tree amulet", chance = 2730},
	{name = "yetislippers", chance = 450}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 1, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -150, radius = 4, effect = CONST_ME_POFF, target = true},
	{name ="combat", interval = 2000, chance = 1, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -150, radius = 1, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 111, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -150, radius = 4, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 5},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
