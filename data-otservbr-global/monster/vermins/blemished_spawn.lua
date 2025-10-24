local mType = Game.createMonsterType("Blemished Spawn")
local monster = {}

monster.description = "a blemished spawn"
monster.experience = 5300
monster.outfit = {
	lookType = 1401,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2093
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Antrum of the Fallen.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 36701
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 66,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 18 }, -- Platinum Coin
	{ id = 3065, chance = 25612 }, -- Terra Rod
	{ id = 16119, chance = 5555 }, -- Blue Crystal Shard
	{ id = 16120, chance = 6898 }, -- Violet Crystal Shard
	{ id = 16125, chance = 7346 }, -- Cyan Crystal Fragment
	{ id = 36779, chance = 9427 }, -- Blemished Spawn Abdomen
	{ id = 3036, chance = 4835 }, -- Violet Gem
	{ id = 3067, chance = 4506 }, -- Hailstorm Rod
	{ id = 281, chance = 3784 }, -- Giant Shimmering Pearl (Green)
	{ id = 3037, chance = 3867 }, -- Yellow Gem
	{ id = 3073, chance = 3588 }, -- Wand of Cosmic Energy
	{ id = 3284, chance = 3860 }, -- Ice Rapier
	{ id = 3289, chance = 3539 }, -- Staff
	{ id = 3318, chance = 4677 }, -- Knight Axe
	{ id = 7387, chance = 3970 }, -- Diamond Sceptre
	{ id = 7430, chance = 4191 }, -- Dragonbone Staff
	{ id = 8083, chance = 4642 }, -- Northwind Rod
	{ id = 8084, chance = 3879 }, -- Springsprout Rod
	{ id = 8092, chance = 4022 }, -- Wand of Starstorm
	{ id = 9302, chance = 4140 }, -- Sacred Tree Amulet
	{ id = 22085, chance = 1266 }, -- Fur Armor
	{ id = 36778, chance = 4545 }, -- Blemished Spawn Head
	{ id = 36780, chance = 2931 }, -- Blemished Spawn Tail
	{ id = 49373, chance = 250 }, -- Greater Spiritualist Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = { type = CONDITION_POISON, totalDamage = 340, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -510, maxDamage = -610, range = 7, radius = 3, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -750, radius = 4, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = {
	defense = 61,
	armor = 61,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 225, maxDamage = 380, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
