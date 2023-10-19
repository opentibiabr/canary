local mType = Game.createMonsterType("White Weretiger")
local monster = {}

monster.description = "a White Weretiger"
monster.experience = 5200
monster.outfit = {
	lookType = 1646,
	lookHead = 0,
	lookBody = 40,
	lookLegs = 113,
	lookFeet = 124,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 6100
monster.maxHealth = 6100
monster.race = "undead"
monster.corpse = 43762
monster.speed = 120
monster.manaCost = 0

monster.raceId = 2387
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sanctuary."
	}

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {

}

monster.loot = {
	{ name = "gold coin", chance = 14175, maxCount = 100 },
	{ name = "platinum coin", chance = 11256, maxCount = 20 },
	{ name = "weretiger teeth", chance = 1750, maxCount = 1 },
	{ name = "beastslayer axe", chance = 1750, maxCount = 1 },
	{ name = "ham", chance = 7843, maxCount = 2 },
	{ name = "white gem", chance = 1903, maxCount = 1 },
	{ name = "silver moon coin", chance = 1660, maxCount = 1 },
	{ name = "moon pin", chance = 2124, maxCount = 1 },
	{ name = "crystal mace", chance = 2124, maxCount = 1 },
	{ name = "blue robe", chance = 1640, maxCount = 1 },
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480},
	{name ="explosion wave", interval = 2000, chance = 15, minDamage = -280, maxDamage = -400, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, radius = 4, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS, target = true}
}

monster.defenses = {
	defense = 83,
	armor = 83
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 60},
	{type = COMBAT_EARTHDAMAGE, percent = -20},
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 40},
	{type = COMBAT_HOLYDAMAGE , percent = 25},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
