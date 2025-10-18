local mType = Game.createMonsterType("Izcandar the Banished")
local monster = {}

monster.description = "Izcandar the Banished"
monster.experience = 55000
monster.outfit = {
	lookType = 1137,
	lookHead = 19,
	lookBody = 95,
	lookLegs = 76,
	lookFeet = 38,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1699,
	bossRace = RARITY_NEMESIS,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"izcandarThink",
}

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
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 29944, chance = 1000 }, -- Izcandar's Snow Globe
	{ id = 23373, chance = 49350, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 7439, chance = 22077, maxCount = 10 }, -- Berserk Potion
	{ id = 3043, chance = 11688 }, -- Crystal Coin
	{ id = 22721, chance = 77922, maxCount = 2 }, -- Gold Token
	{ id = 25759, chance = 36363, maxCount = 100 }, -- Royal Star
	{ id = 23374, chance = 48051, maxCount = 14 }, -- Ultimate Spirit Potion
	{ id = 7443, chance = 27272, maxCount = 10 }, -- Bullseye Potion
	{ id = 7427, chance = 9090 }, -- Chaos Mace
	{ id = 30061, chance = 3896 }, -- Giant Sapphire
	{ id = 281, chance = 16883 }, -- Giant Shimmering Pearl
	{ id = 3038, chance = 25974, maxCount = 2 }, -- Green Gem
	{ id = 5892, chance = 40259 }, -- Huge Chunk of Crude Iron
	{ id = 3039, chance = 36363 }, -- Red Gem
	{ id = 23531, chance = 11688 }, -- Ring of Green Plasma
	{ id = 23375, chance = 58441, maxCount = 6 }, -- Supreme Health Potion
	{ id = 3037, chance = 27272 }, -- Yellow Gem
	{ id = 29422, chance = 5194 }, -- Winterblade
	{ id = 29421, chance = 5194 }, -- Summerblade
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23543, chance = 5194 }, -- Collar of Green Plasma
	{ id = 5904, chance = 7792 }, -- Magic Sulphur
	{ id = 3341, chance = 2597 }, -- Arcane Staff
	{ id = 7440, chance = 23376 }, -- Mastermind Potion
	{ id = 30169, chance = 23376 }, -- Pomegranate
	{ id = 29945, chance = 2631 }, -- Izcandar's Sundial
	{ id = 3041, chance = 14285 }, -- Blue Gem
	{ id = 3324, chance = 25974 }, -- Skull Staff
	{ id = 23526, chance = 12987 }, -- Collar of Blue Plasma
	{ id = 23529, chance = 6493 }, -- Ring of Blue Plasma
	{ id = 3036, chance = 10389 }, -- Violet Gem
	{ id = 9058, chance = 18181 }, -- Gold Ingot
	{ id = 23544, chance = 9090 }, -- Collar of Red Plasma
	{ id = 3006, chance = 6493 }, -- Ring of the Sky
	{ id = 30056, chance = 7792 }, -- Ornate Locket
	{ id = 30059, chance = 2597 }, -- Giant Ruby
	{ id = 5809, chance = 5263 }, -- Soul Stone
	{ id = 23533, chance = 6493 }, -- Ring of Red Plasma
	{ id = 30170, chance = 2564 }, -- Turquoise Tendril Lantern
	{ id = 7414, chance = 2564 }, -- Abyss Hammer
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 3600, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1500, length = 5, spread = 2, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 4100, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -2000, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 4700, chance = 17, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -1500, length = 5, spread = 2, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 3100, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -2000, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
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
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
