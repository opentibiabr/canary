local mType = Game.createMonsterType("King Zelos")
local monster = {}

monster.description = "King Zelos"
monster.experience = 75000
monster.outfit = {
	lookType = 1224,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 480000
monster.maxHealth = 480000
monster.race = "venom"
monster.corpse = 31611
monster.speed = 212

monster.events = {
	"zelos_damage",
	"zelos_init",
	"grave_danger_death",
}

monster.bosstiary = {
	bossRaceId = 1784,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 7 }, -- Crystal Coin
	{ id = 22516, chance = 100000, maxCount = 6 }, -- Silver Token
	{ id = 22721, chance = 81000, maxCount = 5 }, -- Gold Token
	{ id = 23373, chance = 71000, maxCount = 37 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 48000, maxCount = 31 }, -- Ultimate Spirit Potion
	{ id = 23375, chance = 42000, maxCount = 26 }, -- Supreme Health Potion
	{ id = 3039, chance = 35000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 31000 }, -- Yellow Gem
	{ id = 7440, chance = 23000, maxCount = 19 }, -- Mastermind Potion
	{ id = 31590, chance = 16700 }, -- Young Lich Worm
	{ id = 3038, chance = 16700 }, -- Green Gem
	{ id = 3381, chance = 16700 }, -- Crown Armor
	{ id = 23526, chance = 16700 }, -- Collar of Blue Plasma
	{ id = 23531, chance = 14600 }, -- Ring of Green Plasma
	{ id = 3041, chance = 14600 }, -- Blue Gem
	{ id = 7439, chance = 14600, maxCount = 17 }, -- Berserk Potion
	{ id = 3036, chance = 12500 }, -- Violet Gem
	{ id = 23529, chance = 12500 }, -- Ring of Blue Plasma
	{ id = 31588, chance = 12500 }, -- Ancient Liche Bone
	{ id = 824, chance = 12500 }, -- Glacier Robe
	{ id = 2852, chance = 10400 }, -- Red Tome
	{ id = 826, chance = 10400 }, -- Magma Coat
	{ id = 9058, chance = 10400 }, -- Gold Ingot
	{ id = 3079, chance = 8300 }, -- Boots of Haste
	{ id = 23544, chance = 8300 }, -- Collar of Red Plasma
	{ id = 811, chance = 8300 }, -- Terra Mantle
	{ id = 5904, chance = 6200 }, -- Magic Sulphur
	{ id = 31582, chance = 6200 }, -- Galea Mortis
	{ id = 23543, chance = 6200 }, -- Collar of Green Plasma
	{ id = 7443, chance = 6200, maxCount = 14 }, -- Bullseye Potion
	{ id = 31589, chance = 4200 }, -- Rotten Heart
	{ id = 31737, chance = 4200 }, -- Shadow Cowl
	{ id = 23533, chance = 4200 }, -- Ring of Red Plasma
	{ id = 30061, chance = 4200 }, -- Giant Sapphire
	{ id = 30059, chance = 4200 }, -- Giant Ruby
	{ id = 7414, chance = 4200 }, -- Abyss Hammer
	{ id = 825, chance = 2100 }, -- Lightning Robe
	{ id = 5892, chance = 2100 }, -- Huge Chunk of Crude Iron
	{ id = 5885, chance = 2100 }, -- Flask of Warrior's Sweat
	{ id = 11674, chance = 2100 }, -- Cobra Crown
	{ id = 5884, chance = 2100 }, -- Spirit Container
	{ id = 49271, chance = 2100, maxCount = 4 }, -- Transcendence Potion
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = -900, maxDamage = -2700 },
	{ name = "combat", type = COMBAT_FIREDAMAGE, interval = 2000, chance = 15, length = 8, spread = 0, minDamage = -1200, maxDamage = -3200, effect = CONST_ME_HITBYFIRE },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 10, length = 8, spread = 0, minDamage = -600, maxDamage = -1600, effect = CONST_ME_SMALLCLOUDS },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 30, radius = 6, minDamage = -1200, maxDamage = -1500, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 20, length = 8, minDamage = -1700, maxDamage = -2000, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 130,
	armor = 130,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
