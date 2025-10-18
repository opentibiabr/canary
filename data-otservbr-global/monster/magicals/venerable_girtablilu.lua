local mType = Game.createMonsterType("Venerable Girtablilu")
local monster = {}

monster.description = "a venerable girtablilu"
monster.experience = 5300
monster.outfit = {
	lookType = 1407,
	lookHead = 38,
	lookBody = 58,
	lookLegs = 114,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2098
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Ruins of Nuur",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36963
monster.speed = 180
monster.manaCost = 0

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
	targetDistance = 4,
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
}

monster.loot = {
	{ id = 3035, chance = 86471, maxCount = 19 }, -- Platinum Coin
	{ id = 3028, chance = 5789 }, -- Small Diamond
	{ id = 3039, chance = 4463 }, -- Red Gem
	{ id = 9058, chance = 15643 }, -- Gold Ingot
	{ id = 16125, chance = 5293 }, -- Cyan Crystal Fragment
	{ id = 36972, chance = 4365 }, -- Old Girtablilu Carapace
	{ id = 3036, chance = 4335 }, -- Violet Gem
	{ id = 3037, chance = 2836 }, -- Yellow Gem
	{ id = 3041, chance = 2288 }, -- Blue Gem
	{ id = 3072, chance = 1336 }, -- Wand of Decay
	{ id = 3073, chance = 2765 }, -- Wand of Cosmic Energy
	{ id = 8082, chance = 2481 }, -- Underworld Rod
	{ id = 8083, chance = 4754 }, -- Northwind Rod
	{ id = 8094, chance = 1684 }, -- Wand of Voodoo
	{ id = 16119, chance = 2613 }, -- Blue Crystal Shard
	{ id = 16120, chance = 1830 }, -- Violet Crystal Shard
	{ id = 16121, chance = 1778 }, -- Green Crystal Shard
	{ id = 16126, chance = 2271 }, -- Red Crystal Fragment
	{ id = 16127, chance = 2308 }, -- Green Crystal Fragment
	{ id = 23529, chance = 2008 }, -- Ring of Blue Plasma
	{ id = 36822, chance = 3708 }, -- Scorpion Charm
	{ id = 3069, chance = 1244 }, -- Necrotic Rod
	{ id = 3575, chance = 1150 }, -- Wood Cape
	{ id = 8084, chance = 1034 }, -- Springsprout Rod
	{ id = 16096, chance = 1569 }, -- Wand of Defiance
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2750, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -500, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "girtablilu poison wave", interval = 2000, chance = 30, minDamage = -200, maxDamage = -400 },
}

monster.defenses = {
	defense = 80,
	armor = 80,
	mitigation = 2.16,
	{ name = "speed", interval = 1000, chance = 10, speedChange = 160, effect = CONST_ME_POFF, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
