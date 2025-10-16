local mType = Game.createMonsterType("Mummy")
local monster = {}

monster.description = "a mummy"
monster.experience = 150
monster.outfit = {
	lookType = 65,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 65
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Drefia, Darama's Dark Pyramid, Draconia, Mount Sternum Undead Cave, Green Claw Swamp, \z
		Venore Amazon Camp underground, Helheim, Upper Spike, all Tombs, Dark Cathedral, Lion's Rock.",
}

monster.health = 240
monster.maxHealth = 240
monster.race = "undead"
monster.corpse = 6004
monster.speed = 75
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "I will ssswallow your sssoul!", yell = false },
	{ text = "Mort ulhegh dakh visss.", yell = false },
	{ text = "Flesssh to dussst!", yell = false },
	{ text = "I will tassste life again!", yell = false },
	{ text = "Ahkahra exura belil mort!", yell = false },
	{ text = "Yohag Sssetham!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 80 }, -- gold coin
	{ id = 11466, chance = 80000 }, -- flask of embalming fluid
	{ id = 9649, chance = 80000 }, -- gauze bandage
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3492, chance = 80000, maxCount = 3 }, -- worm
	{ id = 3045, chance = 5000 }, -- strange talisman
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 3027, chance = 1000 }, -- black pearl
	{ id = 5914, chance = 1000 }, -- yellow piece of cloth
	{ id = 3299, chance = 1000 }, -- poison dagger
	{ id = 3429, chance = 260 }, -- black shield
	{ id = 3054, chance = 260 }, -- silver amulet
	{ id = 10290, chance = 260 }, -- mini mummy
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -85, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -40, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -226, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 10000 },
}

monster.defenses = {
	defense = 15,
	armor = 14,
	mitigation = 0.59,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
