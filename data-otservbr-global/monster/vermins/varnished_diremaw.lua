local mType = Game.createMonsterType("Varnished Diremaw")
local monster = {}

monster.description = "a varnished diremaw"
monster.experience = 5900
monster.outfit = {
	lookType = 1397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2090
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dwelling of the Forgotten.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 36688
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 71,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 11 }, -- Platinum Coin
	{ id = 3065, chance = 31616 }, -- Terra Rod
	{ id = 3010, chance = 12537 }, -- Emerald Bangle
	{ id = 3028, chance = 7379 }, -- Small Diamond
	{ id = 3032, chance = 6551 }, -- Small Emerald
	{ id = 3038, chance = 6259 }, -- Green Gem
	{ id = 3039, chance = 8318 }, -- Red Gem
	{ id = 3067, chance = 5296 }, -- Hailstorm Rod
	{ id = 16120, chance = 7356 }, -- Violet Crystal Shard
	{ id = 16121, chance = 5858 }, -- Green Crystal Shard
	{ id = 16122, chance = 8189 }, -- Green Crystal Splinter
	{ id = 16123, chance = 10630 }, -- Brown Crystal Splinter
	{ id = 16125, chance = 6748 }, -- Cyan Crystal Fragment
	{ id = 36781, chance = 5883 }, -- Varnished Diremaw Brainpan
	{ id = 36782, chance = 7409 }, -- Varnished Diremaw Legs
	{ id = 819, chance = 2326 }, -- Glacier Shoes
	{ id = 823, chance = 1292 }, -- Glacier Kilt
	{ id = 3419, chance = 1277 }, -- Crown Shield
	{ id = 3575, chance = 1740 }, -- Wood Cape
	{ id = 7387, chance = 3803 }, -- Diamond Sceptre
	{ id = 7407, chance = 1525 }, -- Haunted Blade
	{ id = 8073, chance = 1999 }, -- Spellbook of Warding
	{ id = 8084, chance = 3313 }, -- Springsprout Rod
	{ id = 8092, chance = 3696 }, -- Wand of Starstorm
	{ id = 22085, chance = 1618 }, -- Fur Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -750, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- avalanche
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HOLYDAMAGE, minDamage = -730, maxDamage = -750, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -800, maxDamage = -850, range = 4, shootEffect = CONST_ANI_ICE, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 50,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
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
