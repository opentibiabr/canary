local mType = Game.createMonsterType("Maxxenius")
local monster = {}

monster.description = "Maxxenius"
monster.experience = 55000
monster.outfit = {
	lookType = 1142,
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
monster.corpse = 30151
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
	bossRaceId = 1697,
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
	{ id = 22516, chance = 100000, maxCount = 4 }, -- Silver Token
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22721, chance = 77000, maxCount = 3 }, -- Gold Token
	{ id = 23375, chance = 65000, maxCount = 37 }, -- Supreme Health Potion
	{ id = 23374, chance = 56000, maxCount = 36 }, -- Ultimate Spirit Potion
	{ id = 25759, chance = 45000, maxCount = 199 }, -- Royal Star
	{ id = 23373, chance = 42000, maxCount = 31 }, -- Ultimate Mana Potion
	{ id = 3037, chance = 37000 }, -- Yellow Gem
	{ id = 3039, chance = 37000, maxCount = 2 }, -- Red Gem
	{ id = 5892, chance = 35000 }, -- Huge Chunk of Crude Iron
	{ id = 3043, chance = 26000, maxCount = 4 }, -- Crystal Coin
	{ id = 3041, chance = 24000, maxCount = 2 }, -- Blue Gem
	{ id = 7443, chance = 21000, maxCount = 19 }, -- Bullseye Potion
	{ id = 7439, chance = 21000, maxCount = 19 }, -- Berserk Potion
	{ id = 7440, chance = 16100, maxCount = 18 }, -- Mastermind Potion
	{ id = 5904, chance = 16100 }, -- Magic Sulphur
	{ id = 3038, chance = 16100 }, -- Green Gem
	{ id = 3324, chance = 14500 }, -- Skull Staff
	{ id = 30169, chance = 14500 }, -- Pomegranate
	{ id = 23526, chance = 14500 }, -- Collar of Blue Plasma
	{ id = 281, chance = 12900 }, -- Giant Shimmering Pearl
	{ id = 23544, chance = 12900 }, -- Collar of Red Plasma
	{ id = 23543, chance = 12900 }, -- Collar of Green Plasma
	{ id = 9058, chance = 12900 }, -- Gold Ingot
	{ id = 3036, chance = 9700 }, -- Violet Gem
	{ id = 3006, chance = 9700 }, -- Ring of the Sky
	{ id = 7427, chance = 9700 }, -- Chaos Mace
	{ id = 30056, chance = 8100 }, -- Ornate Locket
	{ id = 5809, chance = 6500 }, -- Soul Stone
	{ id = 23531, chance = 4800 }, -- Ring of Green Plasma
	{ id = 23533, chance = 3200 }, -- Ring of Red Plasma
	{ id = 29426, chance = 3200 }, -- Brain in a Jar
	{ id = 7414, chance = 1600 }, -- Abyss Hammer
	{ id = 29942, chance = 1600 }, -- Maxxenius Head
	{ id = 49271, chance = 1600, maxCount = 12 }, -- Transcendence Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -500, maxDamage = -1000 },
	{ name = "energy beam", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy wave", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 600 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.heals = {
	{ type = COMBAT_ENERGYDAMAGE, percent = 500 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
