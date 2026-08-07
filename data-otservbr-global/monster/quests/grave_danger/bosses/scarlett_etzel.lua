local mType = Game.createMonsterType("Scarlett Etzel")
local monster = {}

monster.description = "Scarlett Etzel"
monster.experience = 20000
monster.outfit = {
	lookType = 1201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"scarlettThink",
	"scarlettHealth",
	"grave_danger_death",
}

monster.bosstiary = {
	bossRaceId = 1804,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 31453
monster.speed = 120
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
	{ text = "Galthen... is that you? ", yell = false },
	{ text = " Where... have you been all that time? ", yell = false },
	{ text = " What...? How dare you? Give me that back! ", yell = false },
	{ text = " Aaaaaaah!!!", yell = false },
}

monster.loot = {
	{ id = 3038, chance = 100000, maxCount = 3 }, -- Green Gem
	{ id = 23535, chance = 99000 }, -- Energy Bar
	{ id = 3035, chance = 99000, maxCount = 9 }, -- Platinum Coin
	{ id = 23373, chance = 58000, maxCount = 32 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 49000, maxCount = 35 }, -- Supreme Health Potion
	{ id = 3039, chance = 38000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 34000, maxCount = 2 }, -- Yellow Gem
	{ id = 23374, chance = 32000, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 25759, chance = 25000, maxCount = 199 }, -- Royal Star
	{ id = 7439, chance = 20000, maxCount = 19 }, -- Berserk Potion
	{ id = 3041, chance = 17400, maxCount = 2 }, -- Blue Gem
	{ id = 7440, chance = 15800, maxCount = 19 }, -- Mastermind Potion
	{ id = 281, chance = 15400 }, -- Giant Shimmering Pearl
	{ id = 826, chance = 14600 }, -- Magma Coat
	{ id = 3065, chance = 13000 }, -- Terra Rod
	{ id = 7443, chance = 12600, maxCount = 19 }, -- Bullseye Potion
	{ id = 827, chance = 12600 }, -- Magma Monocle
	{ id = 49271, chance = 12300, maxCount = 19 }, -- Transcendence Potion
	{ id = 9058, chance = 11100 }, -- Gold Ingot
	{ id = 3043, chance = 10700 }, -- Crystal Coin
	{ id = 3036, chance = 9500, maxCount = 2 }, -- Violet Gem
	{ id = 817, chance = 8700 }, -- Magma Amulet
	{ id = 22516, chance = 8700, maxCount = 5 }, -- Silver Token
	{ id = 811, chance = 7900 }, -- Terra Mantle
	{ id = 812, chance = 7500 }, -- Terra Legs
	{ id = 30059, chance = 6300 }, -- Giant Ruby
	{ id = 30061, chance = 5500 }, -- Giant Sapphire
	{ id = 830, chance = 3600 }, -- Terra Hood
	{ id = 814, chance = 2000 }, -- Terra Amulet
	{ id = 30396, chance = 400 }, -- Cobra Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200 },
	{ name = "sudden death rune", interval = 2000, chance = 16, minDamage = -400, maxDamage = -600, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -640, length = 7, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -480, maxDamage = -800, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 88,
	armor = 88,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
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
