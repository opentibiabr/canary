local mType = Game.createMonsterType("Lava Golem")
local monster = {}

monster.description = "a lava golem"
monster.experience = 7900
monster.outfit = {
	lookType = 491,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 884
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 2.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "fire"
monster.corpse = 15988
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 10,
	color = 206,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Grrrrunt", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 199 }, -- Gold Coin
	{ id = 3035, chance = 99990, maxCount = 11 }, -- Platinum Coin
	{ id = 16131, chance = 14790 }, -- Blazing Bone
	{ id = 9636, chance = 13420 }, -- Fiery Heart
	{ id = 238, chance = 17120, maxCount = 2 }, -- Great Mana Potion
	{ id = 16122, chance = 14050, maxCount = 2 }, -- Green Crystal Splinter
	{ id = 5880, chance = 11950 }, -- Iron Ore
	{ id = 16130, chance = 14860, maxCount = 2 }, -- Magma Clump
	{ id = 268, chance = 20290, maxCount = 2 }, -- Mana Potion
	{ id = 16141, chance = 12040, maxCount = 5 }, -- Prismatic Bolt
	{ id = 16126, chance = 10770 }, -- Red Crystal Fragment
	{ id = 236, chance = 18770, maxCount = 2 }, -- Strong Health Potion
	{ id = 237, chance = 17380, maxCount = 2 }, -- Strong Mana Potion
	{ id = 7643, chance = 14980 }, -- Ultimate Health Potion
	{ id = 16120, chance = 5850 }, -- Violet Crystal Shard
	{ id = 3037, chance = 6140 }, -- Yellow Gem
	{ id = 5914, chance = 7170 }, -- Yellow Piece of Cloth
	{ id = 5909, chance = 4830 }, -- White Piece of Cloth
	{ id = 817, chance = 3340 }, -- Magma Amulet
	{ id = 818, chance = 2400 }, -- Magma Boots
	{ id = 5911, chance = 3510 }, -- Red Piece of Cloth
	{ id = 3071, chance = 3160 }, -- Wand of Inferno
	{ id = 3419, chance = 1350 }, -- Crown Shield
	{ id = 3320, chance = 1480 }, -- Fire Axe
	{ id = 3280, chance = 1720 }, -- Fire Sword
	{ id = 3039, chance = 1170 }, -- Red Gem
	{ id = 16115, chance = 1320 }, -- Wand of Everblazing
	{ id = 826, chance = 490 }, -- Magma Coat
	{ id = 8074, chance = 510 }, -- Spellbook of Mind Control
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "lava golem soulfire", interval = 2000, chance = 15, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -220, maxDamage = -350, radius = 4, effect = CONST_ME_FIREAREA, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, length = 5, spread = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 30000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -280, maxDamage = -350, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 84,
	mitigation = 2.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
