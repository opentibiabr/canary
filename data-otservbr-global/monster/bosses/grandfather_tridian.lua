local mType = Game.createMonsterType("Grandfather Tridian")
local monster = {}

monster.description = "Grandfather Tridian"
monster.experience = 1400
monster.outfit = {
	lookType = 193,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 431,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 18110
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 50,
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Crypt Shambler", chance = 10, interval = 2000, count = 1 },
		{ name = "Ghost", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I will bring peace to your misguided soul!", yell = false },
	{ text = "Your intrusion can't be tolerated!", yell = false },
	{ text = "You should have joined us when there was time!", yell = false },
	{ text = "Rejoice! You will die in the name of the triangle!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 58330, maxCount = 80 }, -- Gold Coin
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 237, chance = 8330 }, -- Strong Mana Potion
	{ id = 3725, chance = 1000 }, -- Brown Mushroom
	{ id = 3071, chance = 16670 }, -- Wand of Inferno
	{ id = 3324, chance = 25000 }, -- Skull Staff
	{ id = 3002, chance = 1000 }, -- Voodoo Doll
	{ id = 5810, chance = 8330 }, -- Pirate Voodoo Doll
	{ id = 7426, chance = 1000 }, -- Amber Staff
	{ id = 6087, chance = 1000 }, -- Music Sheet (First Verse)
	{ id = 6088, chance = 1000 }, -- Music Sheet (Second Verse)
	{ id = 6089, chance = 1000 }, -- Music Sheet (Third Verse)
	{ id = 6090, chance = 1000 }, -- Music Sheet (Fourth Verse)
	{ id = 8094, chance = 1000 }, -- Wand of Voodoo
	{ id = 3084, chance = 16670 }, -- Protection Amulet
	{ id = 3029, chance = 16670 }, -- Small Sapphire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -138, maxDamage = -362, range = 1, radius = 1, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -50, range = 1, radius = 1, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 60, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_YELLOW_RINGS },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
