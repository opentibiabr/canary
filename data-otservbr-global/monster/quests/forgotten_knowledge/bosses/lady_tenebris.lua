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
	{ id = 3031, chance = 100000, maxCount = 369 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 47 }, -- Platinum Coin
	{ id = 3032, chance = 19653, maxCount = 19 }, -- Small Emerald
	{ id = 3033, chance = 16763, maxCount = 18 }, -- Small Amethyst
	{ id = 9057, chance = 20231, maxCount = 18 }, -- Small Topaz
	{ id = 3028, chance = 15028, maxCount = 16 }, -- Small Diamond
	{ id = 3030, chance = 25433, maxCount = 19 }, -- Small Ruby
	{ id = 238, chance = 54335, maxCount = 15 }, -- Great Mana Potion
	{ id = 7642, chance = 49132, maxCount = 12 }, -- Great Spirit Potion
	{ id = 7643, chance = 54913, maxCount = 18 }, -- Ultimate Health Potion
	{ id = 16119, chance = 67630, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16121, chance = 70520, maxCount = 5 }, -- Green Crystal Shard
	{ id = 16120, chance = 65317, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 20062, chance = 5202, maxCount = 3 }, -- Cluster of Solace
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 3324, chance = 98843 }, -- Skull Staff
	{ id = 22195, chance = 45086 }, -- Onyx Pendant
	{ id = 16096, chance = 14450 }, -- Wand of Defiance
	{ id = 22516, chance = 27167 }, -- Silver Token
	{ id = 22721, chance = 23121 }, -- Gold Token
	{ id = 3038, chance = 12716 }, -- Green Gem
	{ id = 3037, chance = 17919 }, -- Yellow Gem
	{ id = 3039, chance = 16184 }, -- Red Gem
	{ id = 3041, chance = 22543 }, -- Blue Gem
	{ id = 3036, chance = 9826 }, -- Violet Gem
	{ id = 3006, chance = 17341 }, -- Ring of the Sky
	{ id = 3021, chance = 3968 }, -- Sapphire Amulet
	{ id = 281, chance = 18497 }, -- Giant Shimmering Pearl
	{ id = 8073, chance = 9248 }, -- Spellbook of Warding
	{ id = 7414, chance = 5555 }, -- Abyss Hammer
	{ id = 10438, chance = 6358 }, -- Spellweaver's Robe
	{ id = 3341, chance = 3448 }, -- Arcane Staff
	{ id = 8075, chance = 3731 }, -- Spellbook of Lost Souls
	{ id = 24957, chance = 4624 }, -- Part of a Rune (Four)
	{ id = 7451, chance = 2325 }, -- Shadow Sceptre
	{ id = 24973, chance = 1149 }, -- Shadow Mask
	{ id = 24974, chance = 1149 }, -- Shadow Paint
	{ id = 20088, chance = 1000 }, -- Crude Umbral Spellbook
	{ id = 20089, chance = 1000 }, -- Umbral Spellbook
	{ id = 22755, chance = 1000 }, -- Book of Lies
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
