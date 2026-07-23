local mType = Game.createMonsterType("The False God")
local monster = {}

monster.description = "The False God"
monster.experience = 50000
monster.outfit = {
	lookType = 984,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1409,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	canPushCreatures = false,
	staticAttackChance = 95,
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
	{ text = "CREEEAK!", yell = true },
}

monster.loot = {
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 45 }, -- Platinum Coin
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 21196, chance = 100000 }, -- Necromantic Rust
	{ id = 5880, chance = 100000 }, -- Iron Ore
	{ id = 3031, chance = 100000, maxCount = 378 }, -- Gold Coin
	{ id = 5888, chance = 60000, maxCount = 17 }, -- Piece of Hell Steel
	{ id = 7642, chance = 60000, maxCount = 15 }, -- Great Spirit Potion
	{ id = 7643, chance = 57000, maxCount = 18 }, -- Ultimate Health Potion
	{ id = 238, chance = 52000, maxCount = 18 }, -- Great Mana Potion
	{ id = 5887, chance = 35000 }, -- Piece of Royal Steel
	{ id = 5904, chance = 32000 }, -- Magic Sulphur
	{ id = 22721, chance = 28000 }, -- Gold Token
	{ id = 22516, chance = 27000 }, -- Silver Token
	{ id = 3032, chance = 27000, maxCount = 17 }, -- Small Emerald
	{ id = 5911, chance = 25000, maxCount = 11 }, -- Red Piece of Cloth
	{ id = 3038, chance = 23000 }, -- Green Gem
	{ id = 3029, chance = 23000, maxCount = 18 }, -- Small Sapphire
	{ id = 3028, chance = 22000, maxCount = 16 }, -- Small Diamond
	{ id = 3039, chance = 22000 }, -- Red Gem
	{ id = 17828, chance = 22000 }, -- Pair of Iron Fists
	{ id = 3041, chance = 20000 }, -- Blue Gem
	{ id = 3037, chance = 20000 }, -- Yellow Gem
	{ id = 9057, chance = 18300, maxCount = 18 }, -- Small Topaz
	{ id = 5889, chance = 16700, maxCount = 3 }, -- Piece of Draconian Steel
	{ id = 3033, chance = 10000, maxCount = 19 }, -- Small Amethyst
	{ id = 5892, chance = 10000 }, -- Huge Chunk of Crude Iron
	{ id = 3036, chance = 8300 }, -- Violet Gem
	{ id = 281, chance = 6700 }, -- Giant Shimmering Pearl
	{ id = 8082, chance = 5000 }, -- Underworld Rod
	{ id = 21175, chance = 5000 }, -- Mino Shield
	{ id = 3281, chance = 5000 }, -- Giant Sword
	{ id = 22762, chance = 5000 }, -- Maimer
	{ id = 14001, chance = 3300 }, -- Ornate Mace
	{ id = 8040, chance = 1700 }, -- Velvet Mantle
	{ id = 21176, chance = 1700 }, -- Execowtioner Axe
	{ id = 25361, chance = 1700 }, -- Blood of the Mountain (Item)
	{ id = 3342, chance = 1700 }, -- War Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -500, range = 4, radius = 4, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -650, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
