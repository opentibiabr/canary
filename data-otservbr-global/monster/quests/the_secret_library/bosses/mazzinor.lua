local mType = Game.createMonsterType("Mazzinor")
local monster = {}

monster.description = "Mazzinor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 85,
	lookBody = 7,
	lookLegs = 3,
	lookFeet = 15,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"mazzinorDeath",
	"mazzinorHealth",
}

monster.bosstiary = {
	bossRaceId = 1605,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
	staticAttackChance = 98,
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
	{ id = 3035, chance = 100000, maxCount = 51 }, -- Platinum Coin
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 22516, chance = 88000, maxCount = 11 }, -- Silver Token
	{ id = 23374, chance = 88000, maxCount = 12 }, -- Ultimate Spirit Potion
	{ id = 3043, chance = 75000, maxCount = 9 }, -- Crystal Coin
	{ id = 8092, chance = 75000 }, -- Wand of Starstorm
	{ id = 23373, chance = 63000, maxCount = 18 }, -- Ultimate Mana Potion
	{ id = 22193, chance = 63000, maxCount = 20 }, -- Onyx Chip
	{ id = 7439, chance = 50000 }, -- Berserk Potion
	{ id = 7443, chance = 50000 }, -- Bullseye Potion
	{ id = 3033, chance = 50000, maxCount = 10 }, -- Small Amethyst
	{ id = 23375, chance = 38000, maxCount = 13 }, -- Supreme Health Potion
	{ id = 8908, chance = 38000 }, -- Slightly Rusted Helmet
	{ id = 23519, chance = 38000 }, -- Frozen Lightning
	{ id = 3038, chance = 38000 }, -- Green Gem
	{ id = 6499, chance = 38000, maxCount = 8 }, -- Demonic Essence
	{ id = 3041, chance = 38000 }, -- Blue Gem
	{ id = 5954, chance = 38000 }, -- Demon Horn
	{ id = 3028, chance = 25000, maxCount = 19 }, -- Small Diamond
	{ id = 3032, chance = 25000, maxCount = 12 }, -- Small Emerald
	{ id = 3039, chance = 25000 }, -- Red Gem
	{ id = 7440, chance = 25000, maxCount = 2 }, -- Mastermind Potion
	{ id = 5904, chance = 25000 }, -- Magic Sulphur
	{ id = 820, chance = 25000 }, -- Lightning Boots
	{ id = 22721, chance = 25000, maxCount = 5 }, -- Gold Token
	{ id = 7419, chance = 25000 }, -- Dreaded Cleaver
	{ id = 27932, chance = 12500 }, -- Sinister Book
	{ id = 16163, chance = 12500 }, -- Crystal Crossbow
	{ id = 8902, chance = 12500 }, -- Slightly Rusted Shield
	{ id = 7404, chance = 12500 }, -- Assassin Dagger
	{ id = 49271, chance = 12500 }, -- Transcendence Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "divine missile", interval = 2000, chance = 10, minDamage = -135, maxDamage = -700, target = true },
	{ name = "berserk", interval = 2000, chance = 20, minDamage = -90, maxDamage = -500, range = 7, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, effect = CONST_ME_MAGIC_BLUE, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -210, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
