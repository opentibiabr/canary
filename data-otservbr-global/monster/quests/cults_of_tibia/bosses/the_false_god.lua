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
	{ id = 3031, chance = 100000, maxCount = 325 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 37 }, -- Platinum Coin
	{ id = 21196, chance = 100000 }, -- Necromantic Rust
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23535, chance = 98437, maxCount = 7 }, -- Energy Bar
	{ id = 3028, chance = 25000, maxCount = 10 }, -- Small Diamond
	{ id = 3032, chance = 21875, maxCount = 10 }, -- Small Emerald
	{ id = 3029, chance = 21875, maxCount = 10 }, -- Small Sapphire
	{ id = 3033, chance = 15625, maxCount = 10 }, -- Small Amethyst
	{ id = 9057, chance = 14062, maxCount = 10 }, -- Small Topaz
	{ id = 7642, chance = 56250, maxCount = 15 }, -- Great Spirit Potion
	{ id = 238, chance = 64062, maxCount = 11 }, -- Great Mana Potion
	{ id = 7643, chance = 50000, maxCount = 9 }, -- Ultimate Health Potion
	{ id = 5887, chance = 21875 }, -- Piece of Royal Steel
	{ id = 5889, chance = 17187, maxCount = 3 }, -- Piece of Draconian Steel
	{ id = 5888, chance = 64062, maxCount = 12 }, -- Piece of Hell Steel
	{ id = 5892, chance = 10714 }, -- Huge Chunk of Crude Iron
	{ id = 5880, chance = 100000 }, -- Iron Ore
	{ id = 5904, chance = 35937 }, -- Magic Sulphur
	{ id = 5911, chance = 31250, maxCount = 9 }, -- Red Piece of Cloth
	{ id = 3039, chance = 25000 }, -- Red Gem
	{ id = 3037, chance = 17187 }, -- Yellow Gem
	{ id = 3038, chance = 20312 }, -- Green Gem
	{ id = 3041, chance = 25000 }, -- Blue Gem
	{ id = 3036, chance = 14814 }, -- Violet Gem
	{ id = 22516, chance = 26562 }, -- Silver Token
	{ id = 22721, chance = 37500 }, -- Gold Token
	{ id = 8082, chance = 15625 }, -- Underworld Rod
	{ id = 3342, chance = 3448 }, -- War Axe
	{ id = 7383, chance = 1000 }, -- Relic Sword
	{ id = 17828, chance = 28125 }, -- Pair of Iron Fists
	{ id = 22762, chance = 7407 }, -- Maimer
	{ id = 8040, chance = 1000 }, -- Velvet Mantle
	{ id = 25361, chance = 3703 }, -- Blood of the Mountain (Item)
	{ id = 3281, chance = 8108 }, -- Giant Sword
	{ id = 281, chance = 13513 }, -- Giant Shimmering Pearl
	{ id = 21175, chance = 8571 }, -- Mino Shield
	{ id = 21176, chance = 3703 }, -- Execowtioner Axe
	{ id = 14001, chance = 3703 }, -- Ornate Mace
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
