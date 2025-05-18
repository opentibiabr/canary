local mType = Game.createMonsterType("Cyclops Drone")
local monster = {}

monster.description = "a cyclops drone"
monster.experience = 200
monster.outfit = {
	lookType = 280,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 391
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cyclopolis, Mount Sternum, Mistrock and in the Cyclops version of the Forsaken Mine.",
}

monster.health = 325
monster.maxHealth = 325
monster.race = "blood"
monster.corpse = 771
monster.speed = 99
monster.manaCost = 525

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
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
	{ text = "Fee! Fie! Foe! Fum!", yell = false },
	{ text = "Luttl pest!", yell = false },
	{ text = "Me makking you pulp!", yell = false },
	{ text = "Humy tasy! Hum hum!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 82000, maxCount = 30 }, -- gold coin
	{ id = 3093, chance = 90 }, -- club ring
	{ id = 3269, chance = 680 }, -- halberd
	{ id = 3294, chance = 8000 }, -- short sword
	{ id = 3384, chance = 190 }, -- dark helmet
	{ id = 3410, chance = 2000 }, -- plate shield
	{ id = 3413, chance = 1600 }, -- battle shield
	{ id = 3577, chance = 50430, maxCount = 2 }, -- meat
	{ id = 7398, chance = 120 }, -- cyclops trophy
	{ id = 236, chance = 520 }, -- strong health potion
	{ id = 9657, chance = 6750 }, -- cyclops toe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -105 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -80, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
