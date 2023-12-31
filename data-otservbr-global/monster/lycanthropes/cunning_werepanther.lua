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
	{ name = "gold coin", chance = 100000, maxCount = 80 },
	{ name = "platinum coin", chance = 100000, maxCount = 11 },
	{ name = "werepanther claw", chance = 12780 },
	{ name = "golden sickle", chance = 5120 },
	{ name = "meat", chance = 5500, maxCount = 2 },
	{ name = "small topaz", chance = 7120, maxCount = 4 },
	{ name = "moonlight crystals", chance = 2550 },
	{ id = 3037, chance = 5130 }, -- yellow gem
	{ name = "lightning headband", chance = 7200 },
	{ name = "ripper lance", chance = 850 },
	{ name = "gemmed figurine", chance = 1770 },
	{ id = 816, chance = 4710 }, -- lightning pendant
	{ name = "fur armor", chance = 2620 },
	{ id = 43917, chance = 600 }, -- werepanther trophy
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
