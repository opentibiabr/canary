local mType = Game.createMonsterType("Werecrocodile")
local monster = {}

monster.description = "a Werecrocodile"
monster.experience = 4140
monster.outfit = {
	lookType = 1647,
	lookHead = 84,
	lookBody = 84,
	lookLegs = 84,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5280
monster.maxHealth = 5280
monster.race = "undead"
monster.corpse = 43754
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.raceId = 2388
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Sanctuary."
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
	{ name = "gold coin", chance = 5858, maxCount = 100 },
	{ name = "platinum coin", chance = 12777, maxCount = 10 },
	{ name = "serpent sword", chance = 3588, maxCount = 1 },
	{ name = "meat", chance = 7051, maxCount = 2 },
	{ name = "moonlight crystals", chance = 2194, maxCount = 1 },
	{ name = "werecrocodile tongue", chance = 1788, maxCount = 1 },
	{ name = "crocodile boots", chance = 1788, maxCount = 1 },
	{ name = "glorious axe", chance = 2728, maxCount = 1 },
	{ name = "green crystal shard", chance = 2013, maxCount = 1 },
	{ name = "bonebreaker", chance = 2013, maxCount = 1 },
	{ name = "golden sun coin", chance = 1646, maxCount = 1 },
	{ name = "werecrocodile trophy", chance = 1390, maxCount = 1 },
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 6000, chance = 9, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, radius = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 6000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -150, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false},
	}

monster.defenses = {
	defense = 82,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 35},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 60}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
