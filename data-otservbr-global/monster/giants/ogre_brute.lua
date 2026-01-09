local mType = Game.createMonsterType("Ogre Brute")
local monster = {}

monster.description = "an ogre brute"
monster.experience = 800
monster.outfit = {
	lookType = 857,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1161
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Krailos Steppe.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "blood"
monster.corpse = 22143
monster.speed = 102
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
	{ text = "You so juicy!", yell = false },
	{ text = "Smash you face in!!!", yell = false },
	{ text = "You stop! You lunch!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99690, maxCount = 125 }, -- Gold Coin
	{ id = 3577, chance = 15000, maxCount = 2 }, -- Meat
	{ id = 236, chance = 12440 }, -- Strong Health Potion
	{ id = 22189, chance = 14600 }, -- Ogre Nose Ring
	{ id = 22188, chance = 18750 }, -- Ogre Ear Stud
	{ id = 3598, chance = 3780, maxCount = 5 }, -- Cookie
	{ id = 1781, chance = 5110, maxCount = 5 }, -- Small Stone
	{ id = 11447, chance = 4670 }, -- Battle Stone
	{ id = 22191, chance = 3440 }, -- Skull Fetish
	{ id = 3050, chance = 1590 }, -- Power Ring
	{ id = 3093, chance = 2290 }, -- Club Ring
	{ id = 22193, chance = 1970, maxCount = 2 }, -- Onyx Chip
	{ id = 3030, chance = 2340 }, -- Small Ruby
	{ id = 3026, chance = 2220 }, -- White Pearl
	{ id = 22194, chance = 1700, maxCount = 2 }, -- Opal
	{ id = 22171, chance = 940 }, -- Ogre Klubba
	{ id = 8907, chance = 210 }, -- Rusted Helmet
	{ id = 9632, chance = 210 }, -- Ancient Stone
	{ id = 3465, chance = 270 }, -- Pot
	{ id = 7428, chance = 100 }, -- Bonebreaker
	{ id = 22192, chance = 140 }, -- Shamanic Mask
	{ id = 7412, chance = 10 }, -- Butcher's Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = { type = CONDITION_FIRE, totalDamage = 6, interval = 9000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_TELEPORT, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 41,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
