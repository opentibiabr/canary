local mType = Game.createMonsterType("Werepanther")
local monster = {}

monster.description = "a werepanther"
monster.experience = 3550
monster.outfit = {
	lookType = 1648,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 67,
	lookFeet = 122,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2390
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Murky Caverns, Oskayaat",
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "blood"
monster.corpse = 43758
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Grrr", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 80 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 11 }, -- Platinum Coin
	{ id = 43731, chance = 14739 }, -- Werepanther Claw
	{ id = 3306, chance = 5980 }, -- Golden Sickle
	{ id = 22083, chance = 4450 }, -- Moonlight Crystals
	{ id = 3577, chance = 5190, maxCount = 2 }, -- Meat
	{ id = 3030, chance = 4360, maxCount = 3 }, -- Small Ruby
	{ id = 827, chance = 1110 }, -- Magma Monocle
	{ id = 3039, chance = 1580 }, -- Red Gem
	{ id = 24392, chance = 830 }, -- Gemmed Figurine
	{ id = 817, chance = 700 }, -- Magma Amulet
	{ id = 3346, chance = 740 }, -- Ripper Lance
	{ id = 22085, chance = 740 }, -- Fur Armor
	{ id = 43917, chance = 140 }, -- Werepanther Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -75, maxDamage = -525 },
	{ name = "combat", interval = 3700, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -265, maxDamage = -400, radius = 3, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "combat", interval = 2700, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -275, maxDamage = -375, radius = 3, effect = CONST_ME_GROUNDSHAKER, range = 4, target = true },
	{ name = "combat", interval = 2300, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -375, radius = 2, effect = CONST_ME_YELLOWSMOKE, target = false },
	{ name = "combat", interval = 3300, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -175, maxDamage = -300, radius = 2, effect = CONST_ME_MORTAREA, range = 4, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 72,
	mitigation = 2.05,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
