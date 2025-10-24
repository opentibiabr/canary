local mType = Game.createMonsterType("Ghulosh")
local monster = {}

monster.description = "Ghulosh"
monster.experience = 45000
monster.outfit = {
	lookType = 1062,
	lookHead = 78,
	lookBody = 113,
	lookLegs = 94,
	lookFeet = 18,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ghuloshThink",
}

monster.bosstiary = {
	bossRaceId = 1608,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 26133
monster.speed = 50
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
	{ id = 3041, chance = 18750 }, -- Blue Gem
	{ id = 9057, chance = 37500, maxCount = 12 }, -- Small Topaz
	{ id = 7412, chance = 41176 }, -- Butcher's Axe
	{ id = 3043, chance = 88235, maxCount = 5 }, -- Crystal Coin
	{ id = 5954, chance = 39285 }, -- Demon Horn
	{ id = 23374, chance = 61764, maxCount = 4 }, -- Ultimate Spirit Potion
	{ id = 23375, chance = 61764, maxCount = 8 }, -- Supreme Health Potion
	{ id = 3035, chance = 100000, maxCount = 39 }, -- Platinum Coin
	{ id = 7440, chance = 50000, maxCount = 2 }, -- Mastermind Potion
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 23517, chance = 34375 }, -- Solid Rage
	{ id = 7443, chance = 41176 }, -- Bullseye Potion
	{ id = 7439, chance = 34375 }, -- Berserk Potion
	{ id = 22516, chance = 67647, maxCount = 6 }, -- Silver Token
	{ id = 28572, chance = 1000 }, -- Ornate Tome
	{ id = 27934, chance = 3846 }, -- Knowledgeable Book
	{ id = 28831, chance = 1000 }, -- Unliving Demonbone
	{ id = 28793, chance = 1000 }, -- Epaulette
	{ id = 8075, chance = 7142 }, -- Spellbook of Lost Souls
	{ id = 22721, chance = 35294 }, -- Gold Token
	{ id = 3028, chance = 20588 }, -- Small Diamond
	{ id = 23373, chance = 41176 }, -- Ultimate Mana Potion
	{ id = 3033, chance = 14285 }, -- Small Amethyst
	{ id = 3039, chance = 26470 }, -- Red Gem
	{ id = 7386, chance = 23529 }, -- Mercenary Sword
	{ id = 30060, chance = 39285 }, -- Giant Emerald
	{ id = 7419, chance = 38235 }, -- Dreaded Cleaver
	{ id = 22193, chance = 58823 }, -- Onyx Chip
	{ id = 8908, chance = 35294 }, -- Slightly Rusted Helmet
	{ id = 3038, chance = 20588 }, -- Green Gem
	{ id = 5904, chance = 25000 }, -- Magic Sulphur
	{ id = 27932, chance = 7692 }, -- Sinister Book
	{ id = 3030, chance = 23076 }, -- Small Ruby
	{ id = 8902, chance = 9375 }, -- Slightly Rusted Shield
	{ id = 3037, chance = 18750 }, -- Yellow Gem
	{ id = 3032, chance = 12500 }, -- Small Emerald
	{ id = 281, chance = 11538 }, -- Giant Shimmering Pearl
	{ id = 6499, chance = 18750 }, -- Demonic Essence
	{ id = 3036, chance = 7692 }, -- Violet Gem
	{ id = 27933, chance = 3846 }, -- Ominous Book
	{ id = 8094, chance = 31250 }, -- Wand of Voodoo
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, skill = 150, attack = 280 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -900, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -600, range = 7, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -2000, range = 7, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
