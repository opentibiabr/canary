local mType = Game.createMonsterType("The Baron from Below")
local monster = {}

monster.description = "The Baron From Below"
monster.experience = 50000
monster.outfit = {
	lookType = 1045,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
	"TheBaronFromBelowThink",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27633
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1518,
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
	{ text = "Krrrk!", yell = false },
}

monster.loot = {
	{ id = 27509, chance = 99000 }, -- Heavy Crystal Fragment
	{ id = 3035, chance = 99000, maxCount = 81 }, -- Platinum Coin
	{ id = 7440, chance = 99000, maxCount = 3 }, -- Mastermind Potion
	{ id = 3081, chance = 99000 }, -- Stone Skin Amulet
	{ id = 16120, chance = 72000, maxCount = 7 }, -- Violet Crystal Shard
	{ id = 3071, chance = 69000 }, -- Wand of Inferno
	{ id = 238, chance = 61000, maxCount = 26 }, -- Great Mana Potion
	{ id = 3280, chance = 61000 }, -- Fire Sword
	{ id = 7642, chance = 55000, maxCount = 28 }, -- Great Spirit Potion
	{ id = 5904, chance = 51000 }, -- Magic Sulphur
	{ id = 7643, chance = 49000, maxCount = 28 }, -- Ultimate Health Potion
	{ id = 3333, chance = 41000 }, -- Crystal Mace
	{ id = 9057, chance = 27000, maxCount = 23 }, -- Small Topaz
	{ id = 8902, chance = 24000 }, -- Slightly Rusted Shield
	{ id = 3038, chance = 23000 }, -- Green Gem
	{ id = 27622, chance = 18500 }, -- Chitinous Mouth (Baron from Below)
	{ id = 3032, chance = 18500, maxCount = 23 }, -- Small Emerald
	{ id = 5892, chance = 18500, maxCount = 3 }, -- Huge Chunk of Crude Iron
	{ id = 22516, chance = 17700 }, -- Silver Token
	{ id = 3033, chance = 17700, maxCount = 23 }, -- Small Amethyst
	{ id = 3041, chance = 17700 }, -- Blue Gem
	{ id = 8908, chance = 16200 }, -- Slightly Rusted Helmet
	{ id = 27624, chance = 15400 }, -- Longing Eyes
	{ id = 3037, chance = 14600 }, -- Yellow Gem
	{ id = 3039, chance = 14600 }, -- Red Gem
	{ id = 9058, chance = 14600, maxCount = 3 }, -- Gold Ingot
	{ id = 3028, chance = 13800, maxCount = 22 }, -- Small Diamond
	{ id = 3030, chance = 13800, maxCount = 22 }, -- Small Ruby
	{ id = 11454, chance = 12300 }, -- Luminous Orb
	{ id = 22721, chance = 11500 }, -- Gold Token
	{ id = 3043, chance = 9200 }, -- Crystal Coin
	{ id = 27621, chance = 7700 }, -- Huge Shell
	{ id = 3036, chance = 6200 }, -- Violet Gem
	{ id = 22086, chance = 6200 }, -- Badger Boots
	{ id = 27623, chance = 3100 }, -- Slimy Leg
	{ id = 27650, chance = 3100 }, -- Gnome Shield
	{ id = 27605, chance = 2300 }, -- Candle Stump
	{ id = 826, chance = 2300 }, -- Magma Coat
	{ id = 14086, chance = 1500 }, -- Calopteryx Cape
	{ id = 27648, chance = 770 }, -- Gnome Armor
	{ id = 27651, chance = 770 }, -- Gnome Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, length = 8, spread = 5, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, length = 8, spread = 9, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1000, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, radius = 5, effect = CONST_ME_SMALLPLANTS, target = false },
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
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
