local mType = Game.createMonsterType("The Nightmare Beast")
local monster = {}

monster.description = "The Nightmare Beast"
monster.experience = 75000
monster.outfit = {
	lookType = 1144,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 850000
monster.maxHealth = 850000
monster.race = "blood"
monster.corpse = 30159
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1718,
	bossRace = RARITY_ARCHFOE,
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
}

monster.loot = {
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 22516, chance = 95000, maxCount = 6 }, -- Silver Token
	{ id = 22721, chance = 81000, maxCount = 5 }, -- Gold Token
	{ id = 23374, chance = 63000, maxCount = 34 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 57000, maxCount = 31 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 52000, maxCount = 29 }, -- Supreme Health Potion
	{ id = 3039, chance = 39000, maxCount = 2 }, -- Red Gem
	{ id = 5892, chance = 28000 }, -- Huge Chunk of Crude Iron
	{ id = 25759, chance = 26000, maxCount = 198 }, -- Royal Star
	{ id = 3037, chance = 24000, maxCount = 2 }, -- Yellow Gem
	{ id = 7439, chance = 20000, maxCount = 19 }, -- Berserk Potion
	{ id = 7443, chance = 18300, maxCount = 16 }, -- Bullseye Potion
	{ id = 7440, chance = 18300, maxCount = 19 }, -- Mastermind Potion
	{ id = 3324, chance = 17200 }, -- Skull Staff
	{ id = 3043, chance = 14000, maxCount = 3 }, -- Crystal Coin
	{ id = 3038, chance = 14000 }, -- Green Gem
	{ id = 9058, chance = 12900 }, -- Gold Ingot
	{ id = 281, chance = 12900 }, -- Giant Shimmering Pearl
	{ id = 3041, chance = 11800 }, -- Blue Gem
	{ id = 23543, chance = 11800 }, -- Collar of Green Plasma
	{ id = 23526, chance = 10800 }, -- Collar of Blue Plasma
	{ id = 23544, chance = 10800 }, -- Collar of Red Plasma
	{ id = 3006, chance = 9700 }, -- Ring of the Sky
	{ id = 23529, chance = 8600 }, -- Ring of Blue Plasma
	{ id = 23533, chance = 8600 }, -- Ring of Red Plasma
	{ id = 5904, chance = 7500 }, -- Magic Sulphur
	{ id = 30170, chance = 7500 }, -- Turquoise Tendril Lantern
	{ id = 30171, chance = 7500 }, -- Purple Tendril Lantern
	{ id = 49271, chance = 6500, maxCount = 17 }, -- Transcendence Potion
	{ id = 3036, chance = 6500 }, -- Violet Gem
	{ id = 30168, chance = 6500 }, -- Ice Shield
	{ id = 5809, chance = 5400 }, -- Soul Stone
	{ id = 30061, chance = 4300 }, -- Giant Sapphire
	{ id = 23531, chance = 4300 }, -- Ring of Green Plasma
	{ id = 30053, chance = 4300 }, -- Dragon Figurine
	{ id = 29427, chance = 4300 }, -- Dark Whispers
	{ id = 7427, chance = 4300 }, -- Chaos Mace
	{ id = 7414, chance = 4300 }, -- Abyss Hammer
	{ id = 29946, chance = 2200 }, -- Beast's Nightmare-Cushion
	{ id = 30342, chance = 1100 }, -- Enchanted Sleep Shawl
	{ id = 30059, chance = 1100 }, -- Giant Ruby
	{ id = 30054, chance = 1100 }, -- Unicorn Figurine
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -3500, target = true }, -- basic attack (1000-3500)
	{ name = "death beam", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2100, target = false }, -- -_death_beam(1000-2100)
	{ name = "big death wave", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2000, target = false }, -- -_death_wave(1000-2000)
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1000, radius = 5, effect = CONST_ME_MORTAREA, target = false }, -- -_great_death_bomb(700-1000)
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
