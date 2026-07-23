local mType = Game.createMonsterType("The Brainstealer")
local monster = {}

monster.description = "The Brainstealer"
monster.experience = 72000
monster.outfit = {
	lookType = 1412,
	lookHead = 94,
	lookBody = 88,
	lookLegs = 88,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2055,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 36843
monster.speed = 425

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "brain parasite", chance = 20, interval = 4000, count = 1 },
	},
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
	{ id = 3043, chance = 100000, maxCount = 3 }, -- Crystal Coin
	{ id = 3035, chance = 58000, maxCount = 28 }, -- Platinum Coin
	{ id = 32769, chance = 50000 }, -- White Gem
	{ id = 23373, chance = 44000, maxCount = 11 }, -- Ultimate Mana Potion
	{ id = 7643, chance = 38000, maxCount = 9 }, -- Ultimate Health Potion
	{ id = 239, chance = 31000, maxCount = 18 }, -- Great Health Potion
	{ id = 238, chance = 31000, maxCount = 16 }, -- Great Mana Potion
	{ id = 23374, chance = 29000, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 32771, chance = 29000 }, -- Moonstone
	{ id = 23375, chance = 27000, maxCount = 11 }, -- Supreme Health Potion
	{ id = 7439, chance = 21000, maxCount = 19 }, -- Berserk Potion
	{ id = 7440, chance = 12500, maxCount = 19 }, -- Mastermind Potion
	{ id = 7443, chance = 10400, maxCount = 15 }, -- Bullseye Potion
	{ id = 34025, chance = 8300 }, -- Diabolic Skull
	{ id = 36794, chance = 8300 }, -- Brainstealer's Tissue
	{ id = 3036, chance = 8300 }, -- Violet Gem
	{ id = 36835, chance = 6200 }, -- Eldritch Crystal
	{ id = 36795, chance = 6200 }, -- Brainstealer's Brain
	{ id = 36668, chance = 2100 }, -- Eldritch Wand
	{ id = 30061, chance = 2100 }, -- Giant Sapphire
	{ id = 30059, chance = 2100 }, -- Giant Ruby
	{ id = 49271, chance = 2100, maxCount = 2 }, -- Transcendence Potion
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = 0, maxDamage = -900 },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 20, radius = 4, minDamage = -1200, maxDamage = -1900, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true, range = 7 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 20, radius = 4, minDamage = -700, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 10, length = 8, spread = 0, minDamage = -1200, maxDamage = -1600, effect = CONST_ME_ELECTRICALSPARK },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
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
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
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
