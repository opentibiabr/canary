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
	{ id = 3031, chance = 39796, maxCount = 80 }, -- Gold Coin
	{ id = 11466, chance = 11421 }, -- Flask of Embalming Fluid
	{ id = 9649, chance = 9929 }, -- Gauze Bandage
	{ id = 3046, chance = 14388 }, -- Magic Light Wand
	{ id = 3492, chance = 46072, maxCount = 3 }, -- Worm
	{ id = 3045, chance = 4817 }, -- Strange Talisman
	{ id = 3017, chance = 3990 }, -- Silver Brooch
	{ id = 3007, chance = 1411 }, -- Crystal Ring
	{ id = 3027, chance = 1134 }, -- Black Pearl
	{ id = 5914, chance = 938 }, -- Yellow Piece of Cloth
	{ id = 3299, chance = 2412 }, -- Poison Dagger
	{ id = 3429, chance = 192 }, -- Black Shield
	{ id = 3054, chance = 109 }, -- Silver Amulet
	{ id = 10290, chance = 0 }, -- Mini Mummy
	{ id = 3081, chance = 120 }, -- Stone Skin Amulet
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
