local mType = Game.createMonsterType("Magma Crawler")
local monster = {}

monster.description = "a magma crawler"
monster.experience = 3900
monster.outfit = {
	lookType = 492,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 885
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzone 2.",
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "fire"
monster.corpse = 15991
monster.speed = 230
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 200,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Crrroak!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 16131, chance = 12600 }, -- Blazing Bone
	{ id = 16130, chance = 11800 }, -- Magma Clump
	{ id = 16123, chance = 8800, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 3028, chance = 8600, maxCount = 3 }, -- Small Diamond
	{ id = 9636, chance = 7700 }, -- Fiery Heart
	{ id = 239, chance = 7200 }, -- Great Health Potion
	{ id = 16127, chance = 7000 }, -- Green Crystal Fragment
	{ id = 238, chance = 6700 }, -- Great Mana Potion
	{ id = 15793, chance = 6000, maxCount = 10 }, -- Crystalline Arrow
	{ id = 5880, chance = 4600 }, -- Iron Ore
	{ id = 16119, chance = 3900 }, -- Blue Crystal Shard
	{ id = 8093, chance = 3900 }, -- Wand of Draconia
	{ id = 5914, chance = 3300 }, -- Yellow Piece of Cloth
	{ id = 817, chance = 3000 }, -- Magma Amulet
	{ id = 5909, chance = 2300 }, -- White Piece of Cloth
	{ id = 818, chance = 1900 }, -- Magma Boots
	{ id = 3051, chance = 1800 }, -- Energy Ring
	{ id = 3280, chance = 1700 }, -- Fire Sword
	{ id = 12600, chance = 1600 }, -- Coal
	{ id = 3429, chance = 1600 }, -- Black Shield
	{ id = 3037, chance = 1000 }, -- Yellow Gem
	{ id = 5911, chance = 950 }, -- Red Piece of Cloth
	{ id = 16115, chance = 670 }, -- Wand of Everblazing
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -203 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -1100, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "magma crawler wave", interval = 2000, chance = 15, minDamage = -290, maxDamage = -800, target = false },
	{ name = "magma crawler soulfire", interval = 2000, chance = 20, target = false },
	{ name = "soulfire rune", interval = 2000, chance = 10, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -140, maxDamage = -180, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 45,
	armor = 84,
	mitigation = 2.51,
	{ name = "invisible", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
