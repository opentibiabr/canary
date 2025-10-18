local mType = Game.createMonsterType("Lost Soul")
local monster = {}

monster.description = "a lost soul"
monster.experience = 4000
monster.outfit = {
	lookType = 232,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 283
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Helheim, Roshamuul Prison and in The Arcanum Part of the Inquisition quest, Oramond Fury Dungeon",
}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "undead"
monster.corpse = 6309
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 450,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Mouuuurn meeee!", yell = false },
	{ text = "Forgive Meee!", yell = false },
	{ text = "Help meee!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99977, maxCount = 198 }, -- Gold Coin
	{ id = 3035, chance = 70127, maxCount = 7 }, -- Platinum Coin
	{ id = 3147, chance = 34775, maxCount = 3 }, -- Blank Rune
	{ id = 10316, chance = 32656 }, -- Unholy Bone
	{ id = 5944, chance = 12361 }, -- Soul Orb
	{ id = 238, chance = 13656, maxCount = 2 }, -- Great Mana Potion
	{ id = 239, chance = 10093, maxCount = 2 }, -- Great Health Potion
	{ id = 3026, chance = 11683, maxCount = 3 }, -- White Pearl
	{ id = 3027, chance = 14232, maxCount = 3 }, -- Black Pearl
	{ id = 6499, chance = 5317 }, -- Demonic Essence
	{ id = 3016, chance = 1314 }, -- Ruby Necklace
	{ id = 3039, chance = 1680 }, -- Red Gem
	{ id = 5806, chance = 4887 }, -- Silver Goblet
	{ id = 6299, chance = 1854 }, -- Death Ring
	{ id = 6525, chance = 1116 }, -- Skeleton Decoration
	{ id = 7413, chance = 846 }, -- Titan Axe
	{ id = 8896, chance = 3925 }, -- Slightly Rusted Armor
	{ id = 3081, chance = 2446 }, -- Stone Skin Amulet
	{ id = 3324, chance = 899 }, -- Skull Staff
	{ id = 3428, chance = 514 }, -- Tower Shield
	{ id = 7407, chance = 929 }, -- Haunted Blade
	{ id = 5741, chance = 229 }, -- Skull Helmet
	{ id = 8895, chance = 1000 }, -- Rusted Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -420 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -40, maxDamage = -210, length = 3, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, radius = 6, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 4000 },
}

monster.defenses = {
	defense = 30,
	armor = 28,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
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
