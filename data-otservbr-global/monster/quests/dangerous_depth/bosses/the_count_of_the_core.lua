local mType = Game.createMonsterType("The Count of the Core")
local monster = {}

monster.description = "The Count Of The Core"
monster.experience = 300000
monster.outfit = {
	lookType = 1046,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27637
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1519,
	bossRace = RARITY_BANE,
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
	{ text = "Shluush!", yell = false },
	{ text = "Sluuurp!", yell = false },
}

monster.loot = {
	{ id = 27509, chance = 100000 }, -- Heavy Crystal Fragment
	{ id = 3035, chance = 100000, maxCount = 95 }, -- Platinum Coin
	{ id = 7440, chance = 100000, maxCount = 3 }, -- Mastermind Potion
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 3071, chance = 74000 }, -- Wand of Inferno
	{ id = 7426, chance = 74000 }, -- Amber Staff
	{ id = 16121, chance = 67000, maxCount = 7 }, -- Green Crystal Shard
	{ id = 3280, chance = 64000 }, -- Fire Sword
	{ id = 7643, chance = 55000, maxCount = 33 }, -- Ultimate Health Potion
	{ id = 7642, chance = 51000, maxCount = 29 }, -- Great Spirit Potion
	{ id = 238, chance = 51000, maxCount = 30 }, -- Great Mana Potion
	{ id = 5904, chance = 49000 }, -- Magic Sulphur
	{ id = 11454, chance = 23000 }, -- Luminous Orb
	{ id = 8908, chance = 23000 }, -- Slightly Rusted Helmet
	{ id = 27626, chance = 22000 }, -- Chitinous Mouth (Count of the Core)
	{ id = 3041, chance = 18900 }, -- Blue Gem
	{ id = 3033, chance = 18900, maxCount = 23 }, -- Small Amethyst
	{ id = 22721, chance = 18300 }, -- Gold Token
	{ id = 9057, chance = 17700, maxCount = 23 }, -- Small Topaz
	{ id = 3037, chance = 16600 }, -- Yellow Gem
	{ id = 3030, chance = 16600, maxCount = 22 }, -- Small Ruby
	{ id = 3038, chance = 16600 }, -- Green Gem
	{ id = 3032, chance = 15400, maxCount = 23 }, -- Small Emerald
	{ id = 8902, chance = 15400 }, -- Slightly Rusted Shield
	{ id = 5892, chance = 14900, maxCount = 3 }, -- Huge Chunk of Crude Iron
	{ id = 3028, chance = 14300, maxCount = 23 }, -- Small Diamond
	{ id = 22516, chance = 12600 }, -- Silver Token
	{ id = 3039, chance = 12000 }, -- Red Gem
	{ id = 281, chance = 11400 }, -- Giant Shimmering Pearl
	{ id = 27627, chance = 8600 }, -- Huge Spiky Snail Shell
	{ id = 3036, chance = 7400 }, -- Violet Gem
	{ id = 8050, chance = 6300 }, -- Crystalline Armor
	{ id = 3043, chance = 5700 }, -- Crystal Coin
	{ id = 826, chance = 3400 }, -- Magma Coat
	{ id = 3281, chance = 2900 }, -- Giant Sword
	{ id = 27625, chance = 2900 }, -- Harpoon of a Giant Snail
	{ id = 11657, chance = 2300 }, -- Twiceslicer
	{ id = 27651, chance = 1700 }, -- Gnome Sword
	{ id = 27525, chance = 570 }, -- Mallet Handle
	{ id = 27647, chance = 570 }, -- Gnome Helmet
	{ id = 27605, chance = 570 }, -- Candle Stump
	{ id = 27656, chance = 570 }, -- Tinged Pot
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_BLACKSMOKE, target = false },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
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
