local mType = Game.createMonsterType("Renegade Quara Pincher")
local monster = {}

monster.description = "a renegade quara pincher"
monster.experience = 2200
monster.outfit = {
	lookType = 77,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1100
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 6063
monster.speed = 198
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 81000, maxCount = 5 }, -- Platinum Coin
	{ id = 11490, chance = 18600 }, -- Quara Pincers
	{ id = 238, chance = 10300, maxCount = 2 }, -- Great Mana Potion
	{ id = 239, chance = 9300, maxCount = 2 }, -- Great Health Potion
	{ id = 3030, chance = 7900, maxCount = 2 }, -- Small Ruby
	{ id = 3028, chance = 7600, maxCount = 2 }, -- Small Diamond
	{ id = 3062, chance = 6700 }, -- Mind Stone
	{ id = 3581, chance = 5100 }, -- Shrimp
	{ id = 3039, chance = 4900 }, -- Red Gem
	{ id = 14252, chance = 3900, maxCount = 5 }, -- Vortex Bolt
	{ id = 282, chance = 1800 }, -- Giant Shimmering Pearl (Brown)
	{ id = 3369, chance = 1600 }, -- Warrior Helmet
	{ id = 5895, chance = 1500 }, -- Fish Fin
	{ id = 3053, chance = 510 }, -- Time Ring
	{ id = 3381, chance = 420 }, -- Crown Armor
	{ id = 3034, chance = 290 }, -- Talon
	{ id = 824, chance = 230 }, -- Glacier Robe
	{ id = 12318, chance = 96 }, -- Giant Shrimp
	{ id = 11657, chance = 32 }, -- Twiceslicer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 60, effect = CONST_ME_DRAWBLOOD },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -300, range = 1, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.defenses = {
	defense = 50,
	armor = 85,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
