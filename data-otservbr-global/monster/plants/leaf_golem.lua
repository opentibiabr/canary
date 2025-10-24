local mType = Game.createMonsterType("Leaf Golem")
local monster = {}

monster.description = "a leaf golem"
monster.experience = 45
monster.outfit = {
	lookType = 567,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 979
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Leaf dungeon in Hellgate, Lair of the Treeling Witch, Forest Fury Camp and in the \z
		Forest Fury version of the Forsaken Mine.",
}

monster.health = 90
monster.maxHealth = 90
monster.race = "undead"
monster.corpse = 19041
monster.speed = 68
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "*crackle*", yell = false },
	{ text = "*swwwwishhhh*", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 87510, maxCount = 27 }, -- Gold Coin
	{ id = 19110, chance = 12160 }, -- Dowser
	{ id = 19111, chance = 14890 }, -- Fir Cone
	{ id = 3723, chance = 4940, maxCount = 3 }, -- White Mushroom
	{ id = 17824, chance = 5140 }, -- Swampling Club
	{ id = 3032, chance = 970 }, -- Small Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -15, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 3, effect = CONST_ME_SMALLPLANTS, target = false, duration = 9000 },
}

monster.defenses = {
	defense = 10,
	armor = 11,
	mitigation = 0.41,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
