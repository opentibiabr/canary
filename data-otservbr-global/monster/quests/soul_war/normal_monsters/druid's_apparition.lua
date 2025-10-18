local mType = Game.createMonsterType("Druid's Apparition")
local monster = {}

monster.description = "a druid's apparition"
monster.experience = 28600
monster.outfit = {
	lookType = 148,
	lookHead = 114,
	lookBody = 48,
	lookLegs = 114,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1946
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Mirrored Nightmare.",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 6081
monster.speed = 235
monster.manaCost = 0

monster.events = {
	"MirroredNightmareBossAccess",
}

monster.changeTarget = {
	interval = 4000,
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
	{ text = "Healing is what I do best.", yell = false },
	{ text = "I'll take your place when you are gone.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 60510 }, -- Crystal Coin
	{ id = 238, chance = 11870, maxCount = 3 }, -- Great Mana Potion
	{ id = 3038, chance = 6903 }, -- Green Gem
	{ id = 3041, chance = 7327 }, -- Blue Gem
	{ id = 3065, chance = 14439 }, -- Terra Rod
	{ id = 3081, chance = 4548 }, -- Stone Skin Amulet
	{ id = 817, chance = 1000 }, -- Magma Amulet
	{ id = 3055, chance = 1671 }, -- Platinum Amulet
	{ id = 8082, chance = 1582 }, -- Underworld Rod
	{ id = 8084, chance = 2338 }, -- Springsprout Rod
	{ id = 9302, chance = 3034 }, -- Sacred Tree Amulet
	{ id = 23544, chance = 765 }, -- Collar of Red Plasma
	{ id = 815, chance = 2551 }, -- Glacier Amulet
	{ id = 3081, chance = 4548 }, -- Stone Skin Amulet
	{ id = 824, chance = 1452 }, -- Glacier Robe
	{ id = 34109, chance = 1000 }, -- Bag You Desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -850 },
	{ name = "combat", interval = 3000, chance = 31, type = COMBAT_ICEDAMAGE, minDamage = -1080, maxDamage = -1300, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true },
	{ name = "ice chain", interval = 9500, chance = 37, minDamage = -1100, maxDamage = -1300, range = 7 },
	{ name = "combat", interval = 4000, chance = 55, type = COMBAT_HOLYDAMAGE, minDamage = -1100, maxDamage = -1250, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 3000, chance = 23, type = COMBAT_HOLYDAMAGE, minDamage = -1250, maxDamage = -1400, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
