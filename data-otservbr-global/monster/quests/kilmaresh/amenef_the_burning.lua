local mType = Game.createMonsterType("Amenef the Burning")
local monster = {}

monster.description = "Amenef the Burning"
monster.experience = 21500
monster.outfit = {
	lookType = 541,
	lookHead = 113,
	lookBody = 114,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2103,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "blood"
monster.corpse = 31646
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = true,
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
	{ id = 3043, chance = 46000 }, -- Crystal Coin
	{ id = 8899, chance = 15200 }, -- Slightly Rusted Legs
	{ id = 8896, chance = 12200 }, -- Slightly Rusted Armor
	{ id = 3315, chance = 11200 }, -- Guardian Halberd
	{ id = 3097, chance = 8100 }, -- Dwarven Ring
	{ id = 3379, chance = 7600 }, -- Doublet
	{ id = 3370, chance = 7100 }, -- Knight Armor
	{ id = 7440, chance = 6900 }, -- Mastermind Potion
	{ id = 8082, chance = 4300 }, -- Underworld Rod
	{ id = 3318, chance = 4100 }, -- Knight Axe
	{ id = 3326, chance = 4100 }, -- Epee
	{ id = 23529, chance = 3800 }, -- Ring of Blue Plasma
	{ id = 8084, chance = 3600 }, -- Springsprout Rod
	{ id = 8092, chance = 3600 }, -- Wand of Starstorm
	{ id = 281, chance = 3600 }, -- Giant Shimmering Pearl
	{ id = 9302, chance = 3300 }, -- Sacred Tree Amulet
	{ id = 3073, chance = 3000 }, -- Wand of Cosmic Energy
	{ id = 3071, chance = 2500 }, -- Wand of Inferno
	{ id = 7404, chance = 2300 }, -- Assassin Dagger
	{ id = 8073, chance = 2300 }, -- Spellbook of Warding
	{ id = 3041, chance = 2300 }, -- Blue Gem
	{ id = 3036, chance = 2000 }, -- Violet Gem
	{ id = 14040, chance = 1800 }, -- Warrior's Axe
	{ id = 37003, chance = 1500 }, -- Eye-Embroidered Veil
	{ id = 7386, chance = 1500 }, -- Mercenary Sword
	{ id = 8043, chance = 1300 }, -- Focus Cape
	{ id = 7426, chance = 1300 }, -- Amber Staff
	{ id = 7456, chance = 1300 }, -- Noble Axe
	{ id = 31324, chance = 1000 }, -- Golden Mask
	{ id = 31323, chance = 510 }, -- Sea Horse Figurine
	{ id = 37002, chance = 250 }, -- Tagralt-Inlaid Scabbard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -510 },
	{ name = "firering", interval = 2000, chance = 10, minDamage = -300, maxDamage = -600, target = false },
	{ name = "firex", interval = 2000, chance = 15, minDamage = -450, maxDamage = -750, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -600, radius = 2, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -750, length = 3, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
