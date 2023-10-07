local mType = Game.createMonsterType("feral werecrocodile")
local monster = {}

monster.description = "a feral werecrocodile"
monster.experience = 5430
monster.outfit = {
	lookType = 1647,
	lookHead = 116,
	lookBody = 95,
	lookLegs = 19,
	lookFeet = 21,
}

monster.raceId = 510
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Oskayaat, Murky Caverns.",
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 43753
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "BRIZZLE!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 98000, maxCount = 100 },
	{ name = "platinum coin", chance = 870, maxCount = 20 },
	{ name = "moonlight crystal", chance = 800 },
	{ name = "werecrocodile tongue", chance = 800 },
	{ name = "swamplair armor", chance = 800 },
	{ name = "violet gem", chance = 800 },
	{ name = "terra mantle", chance = 800 },
	{ name = "ornate crossbow", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, radius = 1, effect = CONST_ME_SOUND_GREEN, target = false },
}

monster.defenses = {
	defense = 85,
	armor = 85,
	mitigation = 2.37,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0},
	{ type = COMBAT_MANADRAIN, percent = 0},
	{ type = COMBAT_DROWNDAMAGE, percent = 0},
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
