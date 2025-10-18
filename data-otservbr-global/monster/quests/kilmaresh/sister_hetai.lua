local mType = Game.createMonsterType("Sister Hetai")
local monster = {}

monster.description = "Sister Hetai"
monster.experience = 20500
monster.outfit = {
	lookType = 1199,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 31419
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2104,
	bossRace = RARITY_ARCHFOE,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	{ id = 37002, chance = 530 }, -- Tagralt-Inlaid Scabbard
	{ id = 813, chance = 2130 }, -- Terra Boots
	{ id = 3370, chance = 3730 }, -- Knight Armor
	{ id = 3043, chance = 46130 }, -- Crystal Coin
	{ id = 9058, chance = 6670 }, -- Gold Ingot
	{ id = 3037, chance = 1330 }, -- Yellow Gem
	{ id = 3032, chance = 4270 }, -- Small Emerald
	{ id = 828, chance = 3730 }, -- Lightning Headband
	{ id = 3028, chance = 4000 }, -- Small Diamond
	{ id = 25737, chance = 3470 }, -- Rainbow Quartz
	{ id = 3036, chance = 3470 }, -- Violet Gem
	{ id = 822, chance = 1070 }, -- Lightning Legs
	{ id = 3071, chance = 3730 }, -- Wand of Inferno
	{ id = 816, chance = 2930 }, -- Lightning Pendant
	{ id = 37003, chance = 800 }, -- Eye-Embroidered Veil
	{ id = 31323, chance = 1070 }, -- Sea Horse Figurine
	{ id = 8043, chance = 4270 }, -- Focus Cape
	{ id = 826, chance = 2400 }, -- Magma Coat
	{ id = 23531, chance = 1870 }, -- Ring of Green Plasma
	{ id = 8082, chance = 3200 }, -- Underworld Rod
	{ id = 3267, chance = 49070 }, -- Dagger
	{ id = 9302, chance = 7730 }, -- Sacred Tree Amulet
	{ id = 818, chance = 2400 }, -- Magma Boots
	{ id = 8092, chance = 2930 }, -- Wand of Starstorm
	{ id = 21169, chance = 2400 }, -- Metal Spats
	{ id = 3097, chance = 1600 }, -- Dwarven Ring
	{ id = 3073, chance = 3730 }, -- Wand of Cosmic Energy
	{ id = 3098, chance = 2670 }, -- Ring of Healing
	{ id = 31324, chance = 1870 }, -- Golden Mask
	{ id = 14042, chance = 3200 }, -- Warrior's Shield
	{ id = 22193, chance = 4270 }, -- Onyx Chip
	{ id = 830, chance = 2670 }, -- Terra Hood
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "targetfirering", interval = 2000, chance = 40, minDamage = -500, maxDamage = -650, target = true },
	{ name = "combat", interval = 2000, chance = 70, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -500, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -750, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
