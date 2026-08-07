local mType = Game.createMonsterType("Lady Tenebris")
local monster = {}

monster.description = "Lady Tenebris"
monster.experience = 50000
monster.outfit = {
	lookType = 433,
	lookHead = 76,
	lookBody = 95,
	lookLegs = 38,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"HealthForgotten",
}

monster.bosstiary = {
	bossRaceId = 1315,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "blood"
monster.corpse = 6560
monster.speed = 185
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
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
	{ text = "May the embrace of darkness kill you!", yell = false },
	{ text = "I'm the one and only mistress of shadows!", yell = false },
	{ text = "Blackout!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 386 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 47 }, -- Platinum Coin
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 3324, chance = 98000 }, -- Skull Staff
	{ id = 16121, chance = 70000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 7643, chance = 63000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 16119, chance = 59000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16120, chance = 57000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 238, chance = 56000, maxCount = 13 }, -- Great Mana Potion
	{ id = 7642, chance = 52000, maxCount = 14 }, -- Great Spirit Potion
	{ id = 22195, chance = 48000 }, -- Onyx Pendant
	{ id = 22721, chance = 30000 }, -- Gold Token
	{ id = 22516, chance = 26000 }, -- Silver Token
	{ id = 3032, chance = 26000, maxCount = 18 }, -- Small Emerald
	{ id = 3039, chance = 22000 }, -- Red Gem
	{ id = 3030, chance = 22000, maxCount = 19 }, -- Small Ruby
	{ id = 16096, chance = 20000 }, -- Wand of Defiance
	{ id = 3037, chance = 18500 }, -- Yellow Gem
	{ id = 3028, chance = 18500, maxCount = 19 }, -- Small Diamond
	{ id = 9057, chance = 16700, maxCount = 15 }, -- Small Topaz
	{ id = 8073, chance = 16700 }, -- Spellbook of Warding
	{ id = 3006, chance = 14800 }, -- Ring of the Sky
	{ id = 3038, chance = 14800 }, -- Green Gem
	{ id = 281, chance = 14800 }, -- Giant Shimmering Pearl
	{ id = 3033, chance = 13000, maxCount = 19 }, -- Small Amethyst
	{ id = 3041, chance = 13000 }, -- Blue Gem
	{ id = 3036, chance = 13000 }, -- Violet Gem
	{ id = 7414, chance = 7400 }, -- Abyss Hammer
	{ id = 20062, chance = 5600, maxCount = 3 }, -- Cluster of Solace
	{ id = 8075, chance = 5600 }, -- Spellbook of Lost Souls
	{ id = 3021, chance = 3700 }, -- Sapphire Amulet
	{ id = 24974, chance = 1900 }, -- Shadow Paint
	{ id = 24957, chance = 3700 }, -- Part of a Rune (Four)
	{ id = 3341, chance = 1900 }, -- Arcane Staff
	{ id = 7451, chance = 1900 }, -- Shadow Sceptre
	{ id = 10438, chance = 1900 }, -- Spellweaver's Robe
	{ id = 24954, chance = 3700 }, -- Part of a Rune (One)
	{ id = 24955, chance = 3700 }, -- Part of a Rune (Two)
	{ id = 24956, chance = 3700 }, -- Part of a Rune (Three)
	{ id = 24958, chance = 3700 }, -- Part of a Rune (Five)
	{ id = 24959, chance = 3700 }, -- Part of a Rune (Six)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1800 },
	{ name = "combat", interval = 6000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "tenebris summon", interval = 2000, chance = 14, target = false },
	{ name = "tenebris ultimate", interval = 15000, chance = 30, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 600, maxDamage = 2700, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
