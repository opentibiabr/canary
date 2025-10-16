local mType = Game.createMonsterType("Distorted Phantom")
local monster = {}

monster.description = "a distorted phantom"
monster.experience = 18870
monster.outfit = {
	lookType = 1298,
	lookHead = 113,
	lookBody = 94,
	lookLegs = 132,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1962
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Mirrored Nightmare.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "undead"
monster.corpse = 34133
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I'm not here. I am there.", yell = false },
	{ text = "The night is coming for you.", yell = false },
	{ text = "Too late... No turning back now.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7642, chance = 23000, maxCount = 5 }, -- great spirit potion
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 8073, chance = 5000 }, -- spellbook of warding
	{ id = 8082, chance = 5000 }, -- underworld rod
	{ id = 8084, chance = 5000 }, -- springsprout rod
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 16118, chance = 5000 }, -- glacial rod
	{ id = 23529, chance = 5000 }, -- ring of blue plasma
	{ id = 23531, chance = 5000 }, -- ring of green plasma
	{ id = 23533, chance = 5000 }, -- ring of red plasma
	{ id = 34142, chance = 5000 }, -- distorted heart
	{ id = 34149, chance = 5000 }, -- distorted robe
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -750 },
	{ name = "combat", interval = 4000, chance = 33, type = COMBAT_HOLYDAMAGE, minDamage = -1000, maxDamage = -1250, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 5000, chance = 44, type = COMBAT_ICEDAMAGE, minDamage = -1050, maxDamage = -1300, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "ice chain", interval = 10000, chance = 59, minDamage = -1100, maxDamage = -1300, range = 7 },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_HOLYDAMAGE, minDamage = -1050, maxDamage = -1250, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -900, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "extended holy chain", interval = 10000, chance = 59, minDamage = -400, maxDamage = -700, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
