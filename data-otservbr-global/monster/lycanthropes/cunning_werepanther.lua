local mType = Game.createMonsterType("Cunning Werepanther")
local monster = {}

monster.description = "a cunning werepanther"
monster.experience = 3620
monster.outfit = {
	lookType = 1648,
	lookHead = 18,
	lookBody = 124,
	lookLegs = 74,
	lookFeet = 81,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2403
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

monster.health = 4300
monster.maxHealth = 4300
monster.race = "blood"
monster.corpse = 43959
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
	{ id = 43731, chance = 8060 }, -- Werepanther Claw
	{ id = 3306, chance = 5600 }, -- Golden Sickle
	{ id = 22083, chance = 1010 }, -- Moonlight Crystals
	{ id = 9057, chance = 5040, maxCount = 4 }, -- Small Topaz
	{ id = 3577, chance = 4850, maxCount = 2 }, -- Meat
	{ id = 3037, chance = 3080 }, -- Yellow Gem
	{ id = 828, chance = 1020 }, -- Lightning Headband
	{ id = 816, chance = 1060 }, -- Lightning Pendant
	{ id = 3346, chance = 850 }, -- Ripper Lance
	{ id = 22085, chance = 770 }, -- Fur Armor
	{ id = 24392, chance = 670 }, -- Gemmed Figurine
	{ id = 43917, chance = 250 }, -- Werepanther Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -75, maxDamage = -540 },
	{ name = "combat", interval = 3300, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -175, maxDamage = -350, radius = 2, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_ENERGY, range = 4, target = true },
	{ name = "combat", interval = 2300, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -425, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2700, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -225, maxDamage = -350, radius = 2, effect = CONST_ME_YELLOWSMOKE, shootEffect = CONST_ANI_LARGEROCK, range = 4, target = true },
	{ name = "combat", interval = 3700, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -375, radius = 3, effect = CONST_ME_STONE_STORM, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 72,
	mitigation = 2.05,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -25 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
