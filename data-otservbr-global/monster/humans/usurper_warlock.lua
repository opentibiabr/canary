local mType = Game.createMonsterType("Usurper Warlock")
local monster = {}

monster.description = "an usurper warlock"
monster.experience = 7000
monster.outfit = {
	lookType = 1316,
	lookHead = 57,
	lookBody = 2,
	lookLegs = 21,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1974
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bounac, the Order of the Lion settlement.",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 34184
monster.speed = 165
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

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
	staticAttackChance = 70,
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
	{ text = "What, are you afraid? So you should be!", yell = false },
	{ text = "Die in the flames of true righteousness!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 79230, maxCount = 4 }, -- Platinum Coin
	{ id = 34162, chance = 6960 }, -- Lion Cloak Patch
	{ id = 34160, chance = 7420 }, -- Lion Crest
	{ id = 830, chance = 4910 }, -- Terra Hood
	{ id = 9058, chance = 10720 }, -- Gold Ingot
	{ id = 3027, chance = 6270 }, -- Black Pearl
	{ id = 3582, chance = 2870 }, -- Ham
	{ id = 3073, chance = 1650 }, -- Wand of Cosmic Energy
	{ id = 8084, chance = 3450 }, -- Springsprout Rod
	{ id = 8092, chance = 1220 }, -- Wand of Starstorm
	{ id = 281, chance = 4110 }, -- Giant Shimmering Pearl (Green)
	{ id = 8082, chance = 1580 }, -- Underworld Rod
	{ id = 828, chance = 3430 }, -- Lightning Headband
	{ id = 3038, chance = 3960 }, -- Green Gem
	{ id = 827, chance = 2040 }, -- Magma Monocle
	{ id = 3371, chance = 2500 }, -- Knight Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_DRAWBLOOD },
	{ name = "singledeathchain", interval = 6000, chance = 15, minDamage = -250, maxDamage = -530, range = 5, effect = CONST_ME_MORTAREA, target = true },
	{ name = "singleicechain", interval = 6000, chance = 18, minDamage = -150, maxDamage = -450, range = 5, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 4000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -450, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- avalanche
}

monster.defenses = {
	defense = 50,
	armor = 80,
	mitigation = 2.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 32 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
