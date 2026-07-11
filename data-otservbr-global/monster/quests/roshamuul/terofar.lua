local mType = Game.createMonsterType("Terofar")
local monster = {}

monster.description = "Terofar"
monster.experience = 24000
monster.outfit = {
	lookType = 12,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 77,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	{ text = "Terofar cast a greater death curse on you!", yell = false },
	{ text = "IT TOOK AN ARMY OF YOUR KIND TO DEFEAT THE WARDEN. NOW YOU ARE ALONE!", yell = true },
	{ text = "THE WARDS ARE FAILING! MY ESCAPE IS ONLY A MATTER OF TIME!!", yell = true },
	{ text = "FEELS GOOD TO BE BACK IN ACTION!", yell = true },
}

monster.loot = {
	{ id = 20062, chance = 100000 }, -- Cluster of Solace
	{ id = 20264, chance = 100000 }, -- Unrealized Dream
	{ id = 3035, chance = 100000, maxCount = 60 }, -- Platinum Coin
	{ id = 20063, chance = 100000 }, -- Dream Matter
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 5954, chance = 100000 }, -- Demon Horn
	{ id = 281, chance = 42000 }, -- Giant Shimmering Pearl
	{ id = 16120, chance = 38000, maxCount = 8 }, -- Violet Crystal Shard
	{ id = 238, chance = 34000, maxCount = 10 }, -- Great Mana Potion
	{ id = 7642, chance = 33000, maxCount = 10 }, -- Great Spirit Potion
	{ id = 7643, chance = 33000, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 16119, chance = 32000, maxCount = 8 }, -- Blue Crystal Shard
	{ id = 16121, chance = 30000, maxCount = 8 }, -- Green Crystal Shard
	{ id = 3038, chance = 26000 }, -- Green Gem
	{ id = 3028, chance = 17700, maxCount = 25 }, -- Small Diamond
	{ id = 3030, chance = 15000, maxCount = 25 }, -- Small Ruby
	{ id = 9057, chance = 14800, maxCount = 25 }, -- Small Topaz
	{ id = 3041, chance = 14500 }, -- Blue Gem
	{ id = 813, chance = 14100 }, -- Terra Boots
	{ id = 3029, chance = 13700, maxCount = 25 }, -- Small Sapphire
	{ id = 3031, chance = 13300, maxCount = 177 }, -- Gold Coin
	{ id = 9058, chance = 12700 }, -- Gold Ingot
	{ id = 3033, chance = 12500, maxCount = 25 }, -- Small Amethyst
	{ id = 8063, chance = 11800 }, -- Paladin Armor
	{ id = 3032, chance = 11200, maxCount = 25 }, -- Small Emerald
	{ id = 3419, chance = 10400 }, -- Crown Shield
	{ id = 20276, chance = 10000 }, -- Dream Warden Mask
	{ id = 3420, chance = 6200 }, -- Demon Shield
	{ id = 3079, chance = 5400 }, -- Boots of Haste
	{ id = 3554, chance = 5400 }, -- Steel Boots
	{ id = 5741, chance = 4200 }, -- Skull Helmet
	{ id = 3392, chance = 2700 }, -- Royal Helmet
	{ id = 3366, chance = 1700 }, -- Magic Plate Armor
	{ id = 3415, chance = 1500 }, -- Guardian Shield
	{ id = 8051, chance = 1300 }, -- Voltage Armor
	{ id = 3414, chance = 580 }, -- Mastermind Shield
	{ id = 8049, chance = 390 }, -- Lavos Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 180, attack = 100 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -750, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 300, maxDamage = 500, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 18, speedChange = 784, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
