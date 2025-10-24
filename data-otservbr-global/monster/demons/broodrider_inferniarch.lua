local mType = Game.createMonsterType("Broodrider Inferniarch")
local monster = {}

monster.description = "a broodrider inferniarch"
monster.experience = 7400
monster.outfit = {
	lookType = 1796,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2603
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle.",
}

monster.health = 9600
monster.maxHealth = 9600
monster.race = "fire"
monster.corpse = 50006
monster.speed = 165
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Mah...Hun Hur...!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 25 }, -- Platinum Coin
	{ id = 16124, chance = 5190 }, -- Blue Crystal Splinter
	{ id = 3450, chance = 2830, maxCount = 5 }, -- Power Bolt
	{ id = 16142, chance = 2750, maxCount = 5 }, -- Drill Bolt
	{ id = 22193, chance = 5080, maxCount = 3 }, -- Onyx Chip
	{ id = 49909, chance = 2540 }, -- Demonic Core Essence
	{ id = 50058, chance = 1900 }, -- Broodrider Saddle
	{ id = 821, chance = 720 }, -- Magma Legs
	{ id = 49894, chance = 430 }, -- Demonic Matter
	{ id = 49908, chance = 1150 }, -- Mummified Demon Finger
	{ id = 5803, chance = 70 }, -- Arbalest
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -167, maxDamage = -374 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -402, maxDamage = -426, range = 1, effect = CONST_ME_BITE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -219, maxDamage = -261, range = 4, shootEffect = CONST_ANI_BOLT, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -472, range = 4, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 70,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
