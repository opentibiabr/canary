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
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 22516, chance = 100000, maxCount = 4 }, -- Silver Token
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22721, chance = 73000, maxCount = 3 }, -- Gold Token
	{ id = 3039, chance = 57000, maxCount = 2 }, -- Red Gem
	{ id = 23375, chance = 55000, maxCount = 36 }, -- Supreme Health Potion
	{ id = 5892, chance = 53000 }, -- Huge Chunk of Crude Iron
	{ id = 23374, chance = 51000, maxCount = 34 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 49000, maxCount = 30 }, -- Ultimate Mana Potion
	{ id = 25759, chance = 47000, maxCount = 194 }, -- Royal Star
	{ id = 3037, chance = 29000, maxCount = 2 }, -- Yellow Gem
	{ id = 7440, chance = 24000, maxCount = 19 }, -- Mastermind Potion
	{ id = 30169, chance = 24000 }, -- Pomegranate
	{ id = 7439, chance = 22000, maxCount = 19 }, -- Berserk Potion
	{ id = 9058, chance = 22000 }, -- Gold Ingot
	{ id = 3324, chance = 22000 }, -- Skull Staff
	{ id = 3038, chance = 18400 }, -- Green Gem
	{ id = 3041, chance = 16300 }, -- Blue Gem
	{ id = 7443, chance = 16300, maxCount = 18 }, -- Bullseye Potion
	{ id = 3043, chance = 12200, maxCount = 2 }, -- Crystal Coin
	{ id = 23531, chance = 10200 }, -- Ring of Green Plasma
	{ id = 281, chance = 10200 }, -- Giant Shimmering Pearl
	{ id = 3036, chance = 8200 }, -- Violet Gem
	{ id = 23544, chance = 8200 }, -- Collar of Red Plasma
	{ id = 23526, chance = 8200 }, -- Collar of Blue Plasma
	{ id = 23533, chance = 6100 }, -- Ring of Red Plasma
	{ id = 3006, chance = 6100 }, -- Ring of the Sky
	{ id = 30056, chance = 6100 }, -- Ornate Locket
	{ id = 23529, chance = 6100 }, -- Ring of Blue Plasma
	{ id = 5904, chance = 6100 }, -- Magic Sulphur
	{ id = 7427, chance = 6100 }, -- Chaos Mace
	{ id = 29422, chance = 4100 }, -- Winterblade
	{ id = 30061, chance = 4100 }, -- Giant Sapphire
	{ id = 29421, chance = 4100 }, -- Summerblade
	{ id = 7414, chance = 4100 }, -- Abyss Hammer
	{ id = 30059, chance = 2000 }, -- Giant Ruby
	{ id = 23543, chance = 2000 }, -- Collar of Green Plasma
	{ id = 3341, chance = 2000 }, -- Arcane Staff
	{ id = 30170, chance = 2000 }, -- Turquoise Tendril Lantern
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
