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
	{ id = 3039, chance = 8335 }, -- Red Gem
	{ id = 9058, chance = 11209 }, -- Gold Ingot
	{ id = 16119, chance = 6062 }, -- Blue Crystal Shard
	{ id = 16120, chance = 7695 }, -- Violet Crystal Shard
	{ id = 16121, chance = 6720 }, -- Green Crystal Shard
	{ id = 36784, chance = 4937 }, -- Tremendous Tyrant Shell
	{ id = 822, chance = 3051 }, -- Lightning Legs
	{ id = 824, chance = 2227 }, -- Glacier Robe
	{ id = 3037, chance = 4398 }, -- Yellow Gem
	{ id = 3067, chance = 3146 }, -- Hailstorm Rod
	{ id = 3073, chance = 2793 }, -- Wand of Cosmic Energy
	{ id = 3082, chance = 1986 }, -- Elven Amulet
	{ id = 3284, chance = 3705 }, -- Ice Rapier
	{ id = 3318, chance = 3360 }, -- Knight Axe
	{ id = 7430, chance = 3238 }, -- Dragonbone Staff
	{ id = 8043, chance = 2145 }, -- Focus Cape
	{ id = 8073, chance = 4516 }, -- Spellbook of Warding
	{ id = 8092, chance = 3680 }, -- Wand of Starstorm
	{ id = 14042, chance = 2281 }, -- Warrior's Shield
	{ id = 36783, chance = 3316 }, -- Tremendous Tyrant Head
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
