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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 9632, chance = 100000 }, -- Ancient Stone
	{ id = 22193, chance = 100000 }, -- Onyx Chip
	{ id = 22721, chance = 99395, maxCount = 3 }, -- Gold Token
	{ id = 5880, chance = 99395, maxCount = 5 }, -- Iron Ore
	{ id = 5887, chance = 99395 }, -- Piece of Royal Steel
	{ id = 3035, chance = 99395, maxCount = 35 }, -- Platinum Coin
	{ id = 22516, chance = 99395, maxCount = 4 }, -- Silver Token
	{ id = 16119, chance = 71601, maxCount = 6 }, -- Blue Crystal Shard
	{ id = 16120, chance = 67673, maxCount = 10 }, -- Violet Crystal Shard
	{ id = 16121, chance = 64652, maxCount = 3 }, -- Green Crystal Shard
	{ id = 238, chance = 60422, maxCount = 10 }, -- Great Mana Potion
	{ id = 7643, chance = 53172, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 7642, chance = 54682, maxCount = 10 }, -- Great Spirit Potion
	{ id = 3029, chance = 26888, maxCount = 20 }, -- Small Sapphire
	{ id = 3039, chance = 27794 }, -- Red Gem
	{ id = 3037, chance = 24471 }, -- Yellow Gem
	{ id = 9058, chance = 20241 }, -- Gold Ingot
	{ id = 3032, chance = 21450, maxCount = 20 }, -- Small Emerald
	{ id = 3041, chance = 19939 }, -- Blue Gem
	{ id = 9660, chance = 17220 }, -- Mystical Hourglass
	{ id = 22194, chance = 16918, maxCount = 2 }, -- Opal
	{ id = 3038, chance = 17220 }, -- Green Gem
	{ id = 9057, chance = 17220, maxCount = 20 }, -- Small Topaz
	{ id = 5909, chance = 16012, maxCount = 4 }, -- White Piece of Cloth
	{ id = 3030, chance = 14199, maxCount = 20 }, -- Small Ruby
	{ id = 5904, chance = 15407 }, -- Magic Sulphur
	{ id = 281, chance = 17220 }, -- Giant Shimmering Pearl
	{ id = 3033, chance = 14501, maxCount = 20 }, -- Small Amethyst
	{ id = 23533, chance = 11782 }, -- Ring of Red Plasma
	{ id = 5891, chance = 10876 }, -- Enchanted Chicken Wing
	{ id = 3324, chance = 11480 }, -- Skull Staff
	{ id = 3036, chance = 9969 }, -- Violet Gem
	{ id = 7437, chance = 9969 }, -- Sapphire Hammer
	{ id = 24954, chance = 1000 }, -- Part of a Rune (One)
	{ id = 24955, chance = 1000 }, -- Part of a Rune (Two)
	{ id = 24956, chance = 1000 }, -- Part of a Rune (Three)
	{ id = 24957, chance = 1000 }, -- Part of a Rune (Four)
	{ id = 24958, chance = 1000 }, -- Part of a Rune (Five)
	{ id = 24959, chance = 1000 }, -- Part of a Rune (Six)
	{ id = 8029, chance = 4833 }, -- Silkweaver Bow
	{ id = 8051, chance = 3323 }, -- Voltage Armor
	{ id = 3408, chance = 2114 }, -- Bonelord Helmet
	{ id = 8076, chance = 1423 }, -- Spellscroll of Prophecies
	{ id = 3360, chance = 1779 }, -- Golden Armor
	{ id = 3340, chance = 2416 }, -- Heavy Mace
	{ id = 7418, chance = 711 }, -- Nightmare Blade
	{ id = 24975, chance = 1208 }, -- Astral Source
	{ id = 24971, chance = 906 }, -- Forbidden Tome
	{ id = 24972, chance = 711 }, -- Key to Knowledge
	{ id = 24976, chance = 906 }, -- Astral Glyph
	{ id = 16160, chance = 355 }, -- Crystalline Sword
	{ id = 20080, chance = 355 }, -- Umbral Hammer
	{ id = 20079, chance = 1000 }, -- Crude Umbral Hammer
	{ id = 5809, chance = 355 }, -- Soul Stone
	{ id = 7450, chance = 1000 }, -- Hammer of Prophecy
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
