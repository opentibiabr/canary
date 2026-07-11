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
	{ id = 3267, chance = 50000 }, -- Dagger
	{ id = 3043, chance = 47000 }, -- Crystal Coin
	{ id = 9302, chance = 7900 }, -- Sacred Tree Amulet
	{ id = 9058, chance = 6100 }, -- Gold Ingot
	{ id = 8043, chance = 4400 }, -- Focus Cape
	{ id = 22193, chance = 4200 }, -- Onyx Chip
	{ id = 3032, chance = 4000 }, -- Small Emerald
	{ id = 3028, chance = 4000 }, -- Small Diamond
	{ id = 3370, chance = 3700 }, -- Knight Armor
	{ id = 3071, chance = 3700 }, -- Wand of Inferno
	{ id = 3073, chance = 3300 }, -- Wand of Cosmic Energy
	{ id = 14042, chance = 3300 }, -- Warrior's Shield
	{ id = 25737, chance = 3300 }, -- Rainbow Quartz
	{ id = 828, chance = 3300 }, -- Lightning Headband
	{ id = 8082, chance = 3000 }, -- Underworld Rod
	{ id = 3036, chance = 3000 }, -- Violet Gem
	{ id = 816, chance = 2800 }, -- Lightning Pendant
	{ id = 830, chance = 2800 }, -- Terra Hood
	{ id = 8092, chance = 2600 }, -- Wand of Starstorm
	{ id = 3098, chance = 2600 }, -- Ring of Healing
	{ id = 818, chance = 2600 }, -- Magma Boots
	{ id = 3037, chance = 2300 }, -- Yellow Gem
	{ id = 826, chance = 2300 }, -- Magma Coat
	{ id = 813, chance = 2100 }, -- Terra Boots
	{ id = 21169, chance = 2100 }, -- Metal Spats
	{ id = 3097, chance = 1900 }, -- Dwarven Ring
	{ id = 31324, chance = 1900 }, -- Golden Mask
	{ id = 23531, chance = 1600 }, -- Ring of Green Plasma
	{ id = 31323, chance = 1400 }, -- Sea Horse Figurine
	{ id = 822, chance = 1400 }, -- Lightning Legs
	{ id = 37003, chance = 700 }, -- Eye-Embroidered Veil
	{ id = 37002, chance = 700 }, -- Tagralt-Inlaid Scabbard
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
