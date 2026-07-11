local mType = Game.createMonsterType("Neferi the Spy")
local monster = {}

monster.description = "Neferi the Spy"
monster.experience = 19650
monster.outfit = {
	lookType = 149,
	lookHead = 95,
	lookBody = 121,
	lookLegs = 94,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 36982
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2105,
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
	{ id = 3043, chance = 47000 }, -- Crystal Coin
	{ id = 3267, chance = 22000 }, -- Dagger
	{ id = 3065, chance = 22000 }, -- Terra Rod
	{ id = 9058, chance = 10900 }, -- Gold Ingot
	{ id = 7643, chance = 10700, maxCount = 4 }, -- Ultimate Health Potion
	{ id = 7642, chance = 7200, maxCount = 2 }, -- Great Spirit Potion
	{ id = 3280, chance = 6900 }, -- Fire Sword
	{ id = 813, chance = 4600 }, -- Terra Boots
	{ id = 3067, chance = 4400 }, -- Hailstorm Rod
	{ id = 828, chance = 4400 }, -- Lightning Headband
	{ id = 23533, chance = 4400 }, -- Ring of Red Plasma
	{ id = 830, chance = 3300 }, -- Terra Hood
	{ id = 3318, chance = 3200 }, -- Knight Axe
	{ id = 822, chance = 3200 }, -- Lightning Legs
	{ id = 829, chance = 2600 }, -- Glacier Mask
	{ id = 3049, chance = 2500 }, -- Stealth Ring
	{ id = 16120, chance = 2500 }, -- Violet Crystal Shard
	{ id = 3036, chance = 2300 }, -- Violet Gem
	{ id = 819, chance = 2100 }, -- Glacier Shoes
	{ id = 3370, chance = 1800 }, -- Knight Armor
	{ id = 8073, chance = 1600 }, -- Spellbook of Warding
	{ id = 31324, chance = 1200 }, -- Golden Mask
	{ id = 37003, chance = 1100 }, -- Eye-Embroidered Veil
	{ id = 31323, chance = 700 }, -- Sea Horse Figurine
	{ id = 37002, chance = 180 }, -- Tagralt-Inlaid Scabbard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1100, radius = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -650, maxDamage = -800, range = 5, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
