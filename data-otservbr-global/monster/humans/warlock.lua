local mType = Game.createMonsterType("Warlock")
local monster = {}

monster.description = "a warlock"
monster.experience = 4000
monster.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 52,
	lookLegs = 128,
	lookFeet = 95,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 10
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Demona, Ghostland (Banshee Quest area), Temple of Xayepocax, Oasis Tomb, Kharos, Magician Quarter, \z
		beneath Fenrock, The Arcanum.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 18246
monster.speed = 115
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 900,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "stone golem", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Even a rat is a better mage than you!", yell = false },
	{ text = "Learn the secret of our magic! YOUR death!", yell = false },
	{ text = "We don't like intruders!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 80 }, -- gold coin
	{ id = 3590, chance = 80000, maxCount = 4 }, -- cherry
	{ id = 3600, chance = 80000 }, -- bread
	{ id = 3299, chance = 80000 }, -- poison dagger
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 7368, chance = 5000, maxCount = 4 }, -- assassin star
	{ id = 3728, chance = 5000 }, -- dark mushroom
	{ id = 3051, chance = 5000 }, -- energy ring
	{ id = 3062, chance = 5000 }, -- mind stone
	{ id = 2917, chance = 1000 }, -- candlestick
	{ id = 3567, chance = 1000 }, -- blue robe
	{ id = 3029, chance = 1000 }, -- small sapphire
	{ id = 3034, chance = 1000 }, -- talon
	{ id = 825, chance = 1000 }, -- lightning robe
	{ id = 28568, chance = 1000 }, -- inkwell
	{ id = 6093, chance = 1000 }, -- crystal ring
	{ id = 11454, chance = 1000 }, -- luminous orb
	{ id = 3006, chance = 260 }, -- ring of the sky
	{ id = 3081, chance = 260 }, -- stone skin amulet
	{ id = 2852, chance = 260 }, -- red tome
	{ id = 3360, chance = 260 }, -- golden armor
	{ id = 2995, chance = 260 }, -- piggy bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -90, maxDamage = -180, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "warlock skill reducer", interval = 2000, chance = 5, range = 5, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -180, range = 7, radius = 3, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_FIREAREA, target = true },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -230, length = 8, spread = 0, effect = CONST_ME_BIGCLOUDS, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 20,
	armor = 33,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 225, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 95 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -8 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
