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
	{ id = 3043, chance = 100000, maxCount = 12 }, -- Crystal Coin
	{ id = 22516, chance = 99584, maxCount = 4 }, -- Silver Token
	{ id = 22721, chance = 74428, maxCount = 3 }, -- Gold Token
	{ id = 23374, chance = 54469, maxCount = 14 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 55093, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 57588, maxCount = 14 }, -- Supreme Health Potion
	{ id = 5909, chance = 3104, maxCount = 4 }, -- White Piece of Cloth
	{ id = 7440, chance = 15176, maxCount = 10 }, -- Mastermind Potion
	{ id = 7439, chance = 17463, maxCount = 10 }, -- Berserk Potion
	{ id = 7443, chance = 14553, maxCount = 10 }, -- Bullseye Potion
	{ id = 3037, chance = 28274, maxCount = 2 }, -- Yellow Gem
	{ id = 23543, chance = 10643 }, -- Collar of Green Plasma
	{ id = 3039, chance = 26819 }, -- Red Gem
	{ id = 3041, chance = 14345 }, -- Blue Gem
	{ id = 3038, chance = 13929 }, -- Green Gem
	{ id = 3036, chance = 7900 }, -- Violet Gem
	{ id = 14112, chance = 665 }, -- Bar of Gold
	{ id = 3381, chance = 16632 }, -- Crown Armor
	{ id = 5885, chance = 3021 }, -- Flask of Warrior's Sweat
	{ id = 11674, chance = 1149 }, -- Cobra Crown
	{ id = 2852, chance = 8108 }, -- Red Tome
	{ id = 23533, chance = 6652 }, -- Ring of Red Plasma
	{ id = 5904, chance = 3950 }, -- Magic Sulphur
	{ id = 23529, chance = 8316 }, -- Ring of Blue Plasma
	{ id = 23526, chance = 10187 }, -- Collar of Blue Plasma
	{ id = 825, chance = 7760 }, -- Lightning Robe
	{ id = 811, chance = 10602 }, -- Terra Mantle
	{ id = 3079, chance = 2079 }, -- Boots of Haste
	{ id = 31580, chance = 1108 }, -- Mortal Mace
	{ id = 31582, chance = 1663 }, -- Galea Mortis
	{ id = 31581, chance = 1330 }, -- Bow of Cataclysm
	{ id = 31737, chance = 2079 }, -- Shadow Cowl
	{ id = 31583, chance = 1330 }, -- Toga Mortis
	{ id = 23531, chance = 9771 }, -- Ring of Green Plasma
	{ id = 824, chance = 7484 }, -- Glacier Robe
	{ id = 31588, chance = 6652 }, -- Ancient Liche Bone
	{ id = 9058, chance = 12474 }, -- Gold Ingot
	{ id = 23544, chance = 10395 }, -- Collar of Red Plasma
	{ id = 31589, chance = 4781 }, -- Rotten Heart
	{ id = 31590, chance = 8316 }, -- Young Lich Worm
	{ id = 30061, chance = 4781 }, -- Giant Sapphire
	{ id = 30060, chance = 3547 }, -- Giant Emerald
	{ id = 826, chance = 8523 }, -- Magma Coat
	{ id = 12543, chance = 1330 }, -- Golden Hyaena Pendant
	{ id = 5892, chance = 2030 }, -- Huge Chunk of Crude Iron
	{ id = 7414, chance = 1871 }, -- Abyss Hammer
	{ id = 30056, chance = 1108 }, -- Ornate Locket
	{ id = 30059, chance = 1108 }, -- Giant Ruby
	{ id = 5884, chance = 549 }, -- Spirit Container
	{ id = 24392, chance = 443 }, -- Gemmed Figurine
	{ id = 50260, chance = 1000 }, -- Death Oyoroi
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
