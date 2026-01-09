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
	{ id = 23535, chance = 99074 }, -- Energy Bar
	{ id = 3035, chance = 99074, maxCount = 9 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 5 }, -- Silver Token
	{ id = 22721, chance = 73148, maxCount = 3 }, -- Gold Token
	{ id = 3043, chance = 18518, maxCount = 3 }, -- Crystal Coin
	{ id = 23509, chance = 99074 }, -- Mysterious Remains
	{ id = 2995, chance = 99074 }, -- Piggy Bank
	{ id = 9058, chance = 18518 }, -- Gold Ingot
	{ id = 23374, chance = 51851, maxCount = 35 }, -- Ultimate Spirit Potion
	{ id = 23375, chance = 57407, maxCount = 35 }, -- Supreme Health Potion
	{ id = 23373, chance = 55555, maxCount = 35 }, -- Ultimate Mana Potion
	{ id = 7439, chance = 21296, maxCount = 20 }, -- Berserk Potion
	{ id = 7443, chance = 18518, maxCount = 20 }, -- Bullseye Potion
	{ id = 7440, chance = 17592, maxCount = 20 }, -- Mastermind Potion
	{ id = 25759, chance = 41666, maxCount = 200 }, -- Royal Star
	{ id = 5892, chance = 42592 }, -- Huge Chunk of Crude Iron
	{ id = 281, chance = 17592 }, -- Giant Shimmering Pearl
	{ id = 30059, chance = 4629 }, -- Giant Ruby
	{ id = 3039, chance = 34259, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 32407, maxCount = 2 }, -- Yellow Gem
	{ id = 3041, chance = 24074, maxCount = 2 }, -- Blue Gem
	{ id = 3038, chance = 13888, maxCount = 2 }, -- Green Gem
	{ id = 3036, chance = 11111, maxCount = 2 }, -- Violet Gem
	{ id = 3324, chance = 17592 }, -- Skull Staff
	{ id = 3341, chance = 1851 }, -- Arcane Staff
	{ id = 7414, chance = 1851 }, -- Abyss Hammer
	{ id = 7427, chance = 4629 }, -- Chaos Mace
	{ id = 23543, chance = 17592 }, -- Collar of Green Plasma
	{ id = 23526, chance = 6481 }, -- Collar of Blue Plasma
	{ id = 23544, chance = 4629 }, -- Collar of Red Plasma
	{ id = 23531, chance = 10185 }, -- Ring of Green Plasma
	{ id = 23529, chance = 5555 }, -- Ring of Blue Plasma
	{ id = 23533, chance = 4629 }, -- Ring of Red Plasma
	{ id = 3006, chance = 6481 }, -- Ring of the Sky
	{ id = 5904, chance = 8333 }, -- Magic Sulphur
	{ id = 5809, chance = 6481 }, -- Soul Stone
	{ id = 29424, chance = 4629 }, -- Pair of Dreamwalkers
	{ id = 29423, chance = 5555 }, -- Dream Shroud
	{ id = 29943, chance = 6481 }, -- Alptramun's Toothbrush
	{ id = 30055, chance = 1851 }, -- Crunor Idol
	{ id = 30169, chance = 13888 }, -- Pomegranate
	{ id = 30171, chance = 1000 }, -- Purple Tendril Lantern
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
