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
	{ id = 3035, chance = 100000, maxCount = 58 }, -- Platinum Coin
	{ id = 3033, chance = 12520, maxCount = 9 }, -- Small Amethyst
	{ id = 3028, chance = 17730, maxCount = 4 }, -- Small Diamond
	{ id = 3032, chance = 11180, maxCount = 25 }, -- Small Emerald
	{ id = 3030, chance = 15030, maxCount = 20 }, -- Small Ruby
	{ id = 3029, chance = 13680, maxCount = 17 }, -- Small Sapphire
	{ id = 9057, chance = 14840, maxCount = 12 }, -- Small Topaz
	{ id = 16119, chance = 31434, maxCount = 8 }, -- Blue Crystal Shard
	{ id = 16120, chance = 37502, maxCount = 7 }, -- Violet Crystal Shard
	{ id = 16121, chance = 30700, maxCount = 6 }, -- Green Crystal Shard
	{ id = 9058, chance = 12870 }, -- Gold Ingot
	{ id = 20062, chance = 100000 }, -- Cluster of Solace
	{ id = 5954, chance = 100000 }, -- Demon Horn
	{ id = 7642, chance = 33452, maxCount = 5 }, -- Great Spirit Potion
	{ id = 238, chance = 33275, maxCount = 4 }, -- Great Mana Potion
	{ id = 7643, chance = 32718, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 20276, chance = 9743 }, -- Dream Warden Mask
	{ id = 3041, chance = 14521 }, -- Blue Gem
	{ id = 3038, chance = 25371 }, -- Green Gem
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 281, chance = 41542 }, -- Giant Shimmering Pearl
	{ id = 3415, chance = 2204 }, -- Guardian Shield
	{ id = 3419, chance = 10400 }, -- Crown Shield
	{ id = 3420, chance = 6437 }, -- Demon Shield
	{ id = 5741, chance = 4240 }, -- Skull Helmet
	{ id = 3392, chance = 2700 }, -- Royal Helmet
	{ id = 8063, chance = 11393 }, -- Paladin Armor
	{ id = 813, chance = 14070 }, -- Terra Boots
	{ id = 3554, chance = 5390 }, -- Steel Boots
	{ id = 3079, chance = 5390 }, -- Boots of Haste
	{ id = 8051, chance = 1655 }, -- Voltage Armor
	{ id = 8054, chance = 1000 }, -- Earthborn Titan Armor
	{ id = 8049, chance = 390 }, -- Lavos Armor
	{ id = 20264, chance = 100000 }, -- Unrealized Dream
	{ id = 20063, chance = 100000 }, -- Dream Matter
	{ id = 3366, chance = 1730 }, -- Magic Plate Armor
	{ id = 3031, chance = 17274 }, -- Gold Coin
	{ id = 3414, chance = 737 }, -- Mastermind Shield
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
