local mType = Game.createMonsterType("The Last Lore Keeper")
local monster = {}

monster.description = "the last lore keeper"
monster.experience = 45000
monster.outfit = {
	lookType = 939,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.health = 750000
monster.maxHealth = 750000
monster.race = "undead"
monster.corpse = 0
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1304,
	bossRace = RARITY_NEMESIS,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 340,
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

monster.summon = {
	maxSummons = 6,
	summons = {
		{ name = "sword of vengeance", chance = 50, interval = 2000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 9632, chance = 100000 }, -- Ancient Stone
	{ id = 3031, chance = 100000, maxCount = 364 }, -- Gold Coin
	{ id = 22193, chance = 100000 }, -- Onyx Chip
	{ id = 3035, chance = 98000, maxCount = 38 }, -- Platinum Coin
	{ id = 5887, chance = 98000 }, -- Piece of Royal Steel
	{ id = 5880, chance = 98000 }, -- Iron Ore
	{ id = 22721, chance = 98000, maxCount = 2 }, -- Gold Token
	{ id = 22516, chance = 98000, maxCount = 2 }, -- Silver Token
	{ id = 238, chance = 72000, maxCount = 12 }, -- Great Mana Potion
	{ id = 16120, chance = 70000, maxCount = 12 }, -- Violet Crystal Shard
	{ id = 16119, chance = 65000, maxCount = 9 }, -- Blue Crystal Shard
	{ id = 7642, chance = 63000, maxCount = 12 }, -- Great Spirit Potion
	{ id = 16121, chance = 57000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7643, chance = 44000, maxCount = 15 }, -- Ultimate Health Potion
	{ id = 3039, chance = 28000 }, -- Red Gem
	{ id = 3041, chance = 28000 }, -- Blue Gem
	{ id = 281, chance = 24000 }, -- Giant Shimmering Pearl
	{ id = 3029, chance = 22000, maxCount = 37 }, -- Small Sapphire
	{ id = 9058, chance = 22000 }, -- Gold Ingot
	{ id = 5909, chance = 20000, maxCount = 7 }, -- White Piece of Cloth
	{ id = 3032, chance = 20000, maxCount = 36 }, -- Small Emerald
	{ id = 3033, chance = 20000, maxCount = 37 }, -- Small Amethyst
	{ id = 3037, chance = 18500 }, -- Yellow Gem
	{ id = 9660, chance = 18500 }, -- Mystical Hourglass
	{ id = 9057, chance = 18500, maxCount = 36 }, -- Small Topaz
	{ id = 3038, chance = 18500 }, -- Green Gem
	{ id = 5904, chance = 18500 }, -- Magic Sulphur
	{ id = 22194, chance = 14800, maxCount = 3 }, -- Opal
	{ id = 3030, chance = 14800, maxCount = 31 }, -- Small Ruby
	{ id = 3324, chance = 13000 }, -- Skull Staff
	{ id = 7437, chance = 11100 }, -- Sapphire Hammer
	{ id = 23533, chance = 11100 }, -- Ring of Red Plasma
	{ id = 5891, chance = 11100 }, -- Enchanted Chicken Wing
	{ id = 3340, chance = 7400 }, -- Heavy Mace
	{ id = 8029, chance = 7400 }, -- Silkweaver Bow
	{ id = 3036, chance = 5600 }, -- Violet Gem
	{ id = 8051, chance = 3700 }, -- Voltage Armor
	{ id = 3408, chance = 3700 }, -- Bonelord Helmet
	{ id = 24976, chance = 1900 }, -- Astral Glyph
	{ id = 24975, chance = 1900 }, -- Astral Source
	{ id = 24971, chance = 1900 }, -- Forbidden Tome
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 140, attack = 80 },
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -650, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -850, maxDamage = -2260, length = 10, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -640, maxDamage = -800, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -420, maxDamage = -954, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -640, maxDamage = -800, radius = 5, effect = CONST_ME_STONES, target = true },
	{ name = "medusa paralyze", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
