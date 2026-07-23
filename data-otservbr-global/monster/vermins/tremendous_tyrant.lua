local mType = Game.createMonsterType("Tremendous Tyrant")
local monster = {}

monster.description = "a tremendous tyrant"
monster.experience = 6100
monster.outfit = {
	lookType = 1396,
	lookHead = 60,
	lookBody = 84,
	lookLegs = 40,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2089
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Dwelling of the Forgotten",
}

monster.health = 11500
monster.maxHealth = 11500
monster.race = "blood"
monster.corpse = 36684
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 3,
	color = 106,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 28 }, -- Platinum Coin
	{ id = 9058, chance = 13000 }, -- Gold Ingot
	{ id = 3039, chance = 9500 }, -- Red Gem
	{ id = 16120, chance = 8100 }, -- Violet Crystal Shard
	{ id = 16121, chance = 6600 }, -- Green Crystal Shard
	{ id = 16119, chance = 6500 }, -- Blue Crystal Shard
	{ id = 36784, chance = 5200 }, -- Tremendous Tyrant Shell
	{ id = 3037, chance = 5000 }, -- Yellow Gem
	{ id = 8073, chance = 5000 }, -- Spellbook of Warding
	{ id = 3284, chance = 3900 }, -- Ice Rapier
	{ id = 822, chance = 3800 }, -- Lightning Legs
	{ id = 3318, chance = 3700 }, -- Knight Axe
	{ id = 7430, chance = 3700 }, -- Dragonbone Staff
	{ id = 36783, chance = 3400 }, -- Tremendous Tyrant Head
	{ id = 8092, chance = 3300 }, -- Wand of Starstorm
	{ id = 3073, chance = 3100 }, -- Wand of Cosmic Energy
	{ id = 3067, chance = 3000 }, -- Hailstorm Rod
	{ id = 824, chance = 2500 }, -- Glacier Robe
	{ id = 14042, chance = 2500 }, -- Warrior's Shield
	{ id = 8043, chance = 2400 }, -- Focus Cape
	{ id = 3082, chance = 2000 }, -- Elven Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -650, length = 5, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -700, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = false }, -- avalanche
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -750, maxDamage = -950, range = 5, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true },
}

monster.defenses = {
	defense = 71,
	armor = 71,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
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
