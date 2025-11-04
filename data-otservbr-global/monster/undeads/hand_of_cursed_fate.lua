local mType = Game.createMonsterType("Hand of Cursed Fate")
local monster = {}

monster.description = "a hand of cursed fate"
monster.experience = 5000
monster.outfit = {
	lookType = 230,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 281
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, The Battlefield, The Arcanum, The Blood Halls and The Crystal Caves.",
}

monster.health = 6600
monster.maxHealth = 6600
monster.race = "blood"
monster.corpse = 6311
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	staticAttackChance = 20,
	targetDistance = 1,
	runHealth = 3500,
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
	{ id = 3031, chance = 99096, maxCount = 267 }, -- Gold Coin
	{ id = 3035, chance = 74317, maxCount = 7 }, -- Platinum Coin
	{ id = 5944, chance = 21501 }, -- Soul Orb
	{ id = 6558, chance = 32514, maxCount = 4 }, -- Flask of Demonic Blood
	{ id = 238, chance = 19411, maxCount = 2 }, -- Great Mana Potion
	{ id = 7643, chance = 19662 }, -- Ultimate Health Potion
	{ id = 3062, chance = 12091 }, -- Mind Stone
	{ id = 7368, chance = 13763, maxCount = 5 }, -- Assassin Star
	{ id = 3029, chance = 12403, maxCount = 4 }, -- Small Sapphire
	{ id = 6499, chance = 10566 }, -- Demonic Essence
	{ id = 3084, chance = 7620 }, -- Protection Amulet
	{ id = 3037, chance = 5995 }, -- Yellow Gem
	{ id = 3010, chance = 5134 }, -- Emerald Bangle
	{ id = 3071, chance = 4216 }, -- Wand of Inferno
	{ id = 3155, chance = 4471, maxCount = 8 }, -- Sudden Death Rune
	{ id = 3370, chance = 3662 }, -- Knight Armor
	{ id = 3051, chance = 1456 }, -- Energy Ring
	{ id = 3041, chance = 1314 }, -- Blue Gem
	{ id = 6299, chance = 1514 }, -- Death Ring
	{ id = 3381, chance = 955 }, -- Crown Armor
	{ id = 3055, chance = 848 }, -- Platinum Amulet
	{ id = 3324, chance = 821 }, -- Skull Staff
	{ id = 3036, chance = 845 }, -- Violet Gem
	{ id = 2828, chance = 1003 }, -- Book (Orange)
	{ id = 9058, chance = 687 }, -- Gold Ingot
	{ id = 3079, chance = 170 }, -- Boots of Haste
	{ id = 5668, chance = 90 }, -- Mysterious Voodoo Skull
	{ id = 7414, chance = 249 }, -- Abyss Hammer
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520, condition = { type = CONDITION_POISON, totalDamage = 380, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -620, range = 1, target = false },
	{ name = "drunk", interval = 2000, chance = 10, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 3000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -220, maxDamage = -880, range = 1, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 53,
	mitigation = 1.88,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 1000, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
