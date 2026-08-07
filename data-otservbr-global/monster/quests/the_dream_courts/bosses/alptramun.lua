local mType = Game.createMonsterType("Alptramun")
local monster = {}

monster.description = "Alptramun"
monster.experience = 55000
monster.outfit = {
	lookType = 1143,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 30155
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessHealth",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1698, -- or 1715 need test
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
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 22516, chance = 100000, maxCount = 5 }, -- Silver Token
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22721, chance = 68000, maxCount = 3 }, -- Gold Token
	{ id = 23374, chance = 63000, maxCount = 31 }, -- Ultimate Spirit Potion
	{ id = 23375, chance = 52000, maxCount = 31 }, -- Supreme Health Potion
	{ id = 23373, chance = 44000, maxCount = 34 }, -- Ultimate Mana Potion
	{ id = 5892, chance = 40000 }, -- Huge Chunk of Crude Iron
	{ id = 25759, chance = 38000, maxCount = 194 }, -- Royal Star
	{ id = 3037, chance = 32000, maxCount = 2 }, -- Yellow Gem
	{ id = 3039, chance = 30000, maxCount = 2 }, -- Red Gem
	{ id = 3041, chance = 27000, maxCount = 2 }, -- Blue Gem
	{ id = 3043, chance = 21000, maxCount = 3 }, -- Crystal Coin
	{ id = 23543, chance = 19000 }, -- Collar of Green Plasma
	{ id = 3038, chance = 19000 }, -- Green Gem
	{ id = 30169, chance = 17500 }, -- Pomegranate
	{ id = 281, chance = 17500 }, -- Giant Shimmering Pearl
	{ id = 3324, chance = 17500 }, -- Skull Staff
	{ id = 7439, chance = 17500, maxCount = 17 }, -- Berserk Potion
	{ id = 7443, chance = 15900, maxCount = 19 }, -- Bullseye Potion
	{ id = 9058, chance = 14300 }, -- Gold Ingot
	{ id = 7440, chance = 11100, maxCount = 16 }, -- Mastermind Potion
	{ id = 3036, chance = 9500 }, -- Violet Gem
	{ id = 5809, chance = 9500 }, -- Soul Stone
	{ id = 49271, chance = 7900, maxCount = 17 }, -- Transcendence Potion
	{ id = 3006, chance = 7900 }, -- Ring of the Sky
	{ id = 5904, chance = 7900 }, -- Magic Sulphur
	{ id = 29423, chance = 7900 }, -- Dream Shroud
	{ id = 23544, chance = 7900 }, -- Collar of Red Plasma
	{ id = 23526, chance = 7900 }, -- Collar of Blue Plasma
	{ id = 29943, chance = 7900 }, -- Alptramun's Toothbrush
	{ id = 23533, chance = 6300 }, -- Ring of Red Plasma
	{ id = 23531, chance = 6300 }, -- Ring of Green Plasma
	{ id = 29424, chance = 6300 }, -- Pair of Dreamwalkers
	{ id = 7427, chance = 6300 }, -- Chaos Mace
	{ id = 23529, chance = 4800 }, -- Ring of Blue Plasma
	{ id = 30059, chance = 4800 }, -- Giant Ruby
	{ id = 7414, chance = 1600 }, -- Abyss Hammer
	{ id = 3341, chance = 1600 }, -- Arcane Staff
	{ id = 30055, chance = 1600 }, -- Crunor Idol
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -2000, range = 7, length = 6, spread = 0, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, range = 3, length = 6, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -500, range = 3, length = 6, spread = 0, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
