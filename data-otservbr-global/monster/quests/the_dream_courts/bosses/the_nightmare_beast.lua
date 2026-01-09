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
	{ id = 23375, chance = 57311, maxCount = 6 }, -- Supreme Health Potion
	{ id = 23374, chance = 51415, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 58018, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 7439, chance = 22405, maxCount = 10 }, -- Berserk Potion
	{ id = 7443, chance = 16037, maxCount = 10 }, -- Bullseye Potion
	{ id = 7440, chance = 17924, maxCount = 10 }, -- Mastermind Potion
	{ id = 49271, chance = 1886, maxCount = 13 }, -- Transcendence Potion
	{ id = 3035, chance = 99764, maxCount = 5 }, -- Platinum Coin
	{ id = 25759, chance = 34198, maxCount = 100 }, -- Royal Star
	{ id = 5892, chance = 34669 }, -- Huge Chunk of Crude Iron
	{ id = 2995, chance = 99764 }, -- Piggy Bank
	{ id = 3041, chance = 17688 }, -- Blue Gem
	{ id = 3039, chance = 31367 }, -- Red Gem
	{ id = 3038, chance = 19103 }, -- Green Gem
	{ id = 3037, chance = 29952 }, -- Yellow Gem
	{ id = 9058, chance = 14150 }, -- Gold Ingot
	{ id = 281, chance = 13679 }, -- Giant Shimmering Pearl
	{ id = 30061, chance = 4716 }, -- Giant Sapphire
	{ id = 30060, chance = 2362 }, -- Giant Emerald
	{ id = 23509, chance = 99764 }, -- Mysterious Remains
	{ id = 23535, chance = 99764 }, -- Energy Bar
	{ id = 22516, chance = 97405, maxCount = 6 }, -- Silver Token
	{ id = 22721, chance = 74528, maxCount = 3 }, -- Gold Token
	{ id = 23529, chance = 7547 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 8726 }, -- Ring of Green Plasma
	{ id = 23533, chance = 4952 }, -- Ring of Red Plasma
	{ id = 23543, chance = 8490 }, -- Collar of Green Plasma
	{ id = 23526, chance = 10141 }, -- Collar of Blue Plasma
	{ id = 7414, chance = 1650 }, -- Abyss Hammer
	{ id = 3324, chance = 16509 }, -- Skull Staff
	{ id = 3006, chance = 9433 }, -- Ring of the Sky
	{ id = 5809, chance = 5660 }, -- Soul Stone
	{ id = 29946, chance = 6367 }, -- Beast's Nightmare-Cushion
	{ id = 30170, chance = 5188 }, -- Turquoise Tendril Lantern
	{ id = 30171, chance = 8490 }, -- Purple Tendril Lantern
	{ id = 30168, chance = 11792 }, -- Ice Shield
	{ id = 29427, chance = 3066 }, -- Dark Whispers
	{ id = 30342, chance = 2964 }, -- Enchanted Sleep Shawl
	{ id = 3036, chance = 8254 }, -- Violet Gem
	{ id = 30053, chance = 5660 }, -- Dragon Figurine
	{ id = 30054, chance = 1176 }, -- Unicorn Figurine
	{ id = 7427, chance = 8490 }, -- Chaos Mace
	{ id = 3043, chance = 18867 }, -- Crystal Coin
	{ id = 3341, chance = 1617 }, -- Arcane Staff
	{ id = 5904, chance = 7075 }, -- Magic Sulphur
	{ id = 23544, chance = 13679 }, -- Collar of Red Plasma
	{ id = 30059, chance = 2931 }, -- Giant Ruby
	{ id = 50190, chance = 1000 }, -- Dark Vision Bandana
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
