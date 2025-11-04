local mType = Game.createMonsterType("Renegade Quara Hydromancer")
local monster = {}

monster.description = "a renegade quara hydromancer"
monster.experience = 1800
monster.outfit = {
	lookType = 47,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1098
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

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6066
monster.speed = 245
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
	{ id = 3035, chance = 80380, maxCount = 4 }, -- Platinum Coin
	{ id = 11488, chance = 18430 }, -- Quara Eye
	{ id = 3062, chance = 10390 }, -- Mind Stone
	{ id = 3581, chance = 7379 }, -- Shrimp
	{ id = 9057, chance = 6450, maxCount = 2 }, -- Small Topaz
	{ id = 3032, chance = 7050, maxCount = 2 }, -- Small Emerald
	{ id = 238, chance = 5490, maxCount = 2 }, -- Great Mana Potion
	{ id = 239, chance = 5060, maxCount = 2 }, -- Great Health Potion
	{ id = 8042, chance = 5000 }, -- Spirit Cloak
	{ id = 5914, chance = 2580 }, -- Yellow Piece of Cloth
	{ id = 5910, chance = 2910 }, -- Green Piece of Cloth
	{ id = 16121, chance = 2980 }, -- Green Crystal Shard
	{ id = 3052, chance = 1850 }, -- Life Ring
	{ id = 281, chance = 1320 }, -- Giant Shimmering Pearl (Green)
	{ id = 5895, chance = 1420 }, -- Fish Fin
	{ id = 3073, chance = 930 }, -- Wand of Cosmic Energy
	{ id = 3370, chance = 759 }, -- Knight Armor
	{ id = 3038, chance = 429 }, -- Green Gem
	{ id = 3027, chance = 1000 }, -- Black Pearl
	{ id = 3098, chance = 1000 }, -- Ring of Healing
	{ id = 3026, chance = 1000 }, -- White Pearl
	{ id = 281, chance = 29 }, -- Giant Shimmering Pearl
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 110, attack = 90, effect = CONST_ME_DRAWBLOOD, condition = { type = CONDITION_POISON, totalDamage = 5, interval = 4000 } },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -350, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 15,
	armor = 30,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
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
