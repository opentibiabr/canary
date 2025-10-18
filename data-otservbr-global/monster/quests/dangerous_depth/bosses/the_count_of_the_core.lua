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
	{ id = 3043, chance = 8056 }, -- Crystal Coin
	{ id = 3035, chance = 100000, maxCount = 53 }, -- Platinum Coin
	{ id = 22721, chance = 21011 }, -- Gold Token
	{ id = 3037, chance = 19115 }, -- Yellow Gem
	{ id = 7642, chance = 53712, maxCount = 18 }, -- Great Spirit Potion
	{ id = 9057, chance = 20063, maxCount = 12 }, -- Small Topaz
	{ id = 7440, chance = 100000, maxCount = 2 }, -- Mastermind Potion
	{ id = 16121, chance = 65718, maxCount = 4 }, -- Green Crystal Shard
	{ id = 5904, chance = 47235 }, -- Magic Sulphur
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 7426, chance = 69194 }, -- Amber Staff
	{ id = 3071, chance = 70300 }, -- Wand of Inferno
	{ id = 3280, chance = 63349 }, -- Fire Sword
	{ id = 22516, chance = 10426 }, -- Silver Token
	{ id = 27625, chance = 4739 }, -- Harpoon of a Giant Snail
	{ id = 27627, chance = 12796 }, -- Huge Spiky Snail Shell
	{ id = 27626, chance = 17693 }, -- Chitinous Mouth (Count of the Core)
	{ id = 8908, chance = 20853 }, -- Slightly Rusted Helmet
	{ id = 8902, chance = 20537 }, -- Slightly Rusted Shield
	{ id = 3036, chance = 6793 }, -- Violet Gem
	{ id = 3033, chance = 20221 }, -- Small Amethyst
	{ id = 238, chance = 55134 }, -- Great Mana Potion
	{ id = 5892, chance = 16903 }, -- Huge Chunk of Crude Iron
	{ id = 11454, chance = 20853 }, -- Luminous Orb
	{ id = 3041, chance = 18325 }, -- Blue Gem
	{ id = 3038, chance = 18009 }, -- Green Gem
	{ id = 3030, chance = 18799 }, -- Small Ruby
	{ id = 27509, chance = 100000 }, -- Heavy Crystal Fragment
	{ id = 3032, chance = 15639 }, -- Small Emerald
	{ id = 3039, chance = 18483 }, -- Red Gem
	{ id = 7643, chance = 54976 }, -- Ultimate Health Potion
	{ id = 281, chance = 10584 }, -- Giant Shimmering Pearl
	{ id = 3028, chance = 16587 }, -- Small Diamond
	{ id = 27651, chance = 1105 }, -- Gnome Sword
	{ id = 27650, chance = 1612 }, -- Gnome Shield
	{ id = 27647, chance = 789 }, -- Gnome Helmet
	{ id = 27605, chance = 1263 }, -- Candle Stump
	{ id = 27656, chance = 789 }, -- Tinged Pot
	{ id = 27525, chance = 315 }, -- Mallet Handle
	{ id = 14043, chance = 2620 }, -- Guardian Axe
	{ id = 3281, chance = 3475 }, -- Giant Sword
	{ id = 11657, chance = 1895 }, -- Twiceslicer
	{ id = 826, chance = 2369 }, -- Magma Coat
	{ id = 8050, chance = 4581 }, -- Crystalline Armor
	{ id = 50290, chance = 1000 }, -- Gnomish Footwraps
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
