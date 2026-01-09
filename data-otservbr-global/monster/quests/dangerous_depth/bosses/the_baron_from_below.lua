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
	{ id = 3035, chance = 99829, maxCount = 49 }, -- Platinum Coin
	{ id = 3043, chance = 9353 }, -- Crystal Coin
	{ id = 238, chance = 55952, maxCount = 10 }, -- Great Mana Potion
	{ id = 7643, chance = 53401, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 7642, chance = 54421, maxCount = 8 }, -- Great Spirit Potion
	{ id = 7440, chance = 99829, maxCount = 2 }, -- Mastermind Potion
	{ id = 3028, chance = 17857, maxCount = 12 }, -- Small Diamond
	{ id = 3032, chance = 17006, maxCount = 12 }, -- Small Emerald
	{ id = 16120, chance = 70068, maxCount = 4 }, -- Violet Crystal Shard
	{ id = 3038, chance = 19557 }, -- Green Gem
	{ id = 3041, chance = 18197 }, -- Blue Gem
	{ id = 3081, chance = 99829 }, -- Stone Skin Amulet
	{ id = 5892, chance = 20748 }, -- Huge Chunk of Crude Iron
	{ id = 3071, chance = 67687 }, -- Wand of Inferno
	{ id = 5904, chance = 44557 }, -- Magic Sulphur
	{ id = 22086, chance = 4761 }, -- Badger Boots
	{ id = 3280, chance = 64455 }, -- Fire Sword
	{ id = 3333, chance = 36224 }, -- Crystal Mace
	{ id = 8902, chance = 22959 }, -- Slightly Rusted Shield
	{ id = 27622, chance = 20238 }, -- Chitinous Mouth (Baron from Below)
	{ id = 27621, chance = 5952 }, -- Huge Shell
	{ id = 27624, chance = 16156 }, -- Longing Eyes
	{ id = 27623, chance = 3911 }, -- Slimy Leg
	{ id = 3033, chance = 19047 }, -- Small Amethyst
	{ id = 8908, chance = 18707 }, -- Slightly Rusted Helmet
	{ id = 14086, chance = 3231 }, -- Calopteryx Cape
	{ id = 826, chance = 3571 }, -- Magma Coat
	{ id = 11454, chance = 15986 }, -- Luminous Orb
	{ id = 3030, chance = 15136 }, -- Small Ruby
	{ id = 3037, chance = 19217 }, -- Yellow Gem
	{ id = 9058, chance = 12074 }, -- Gold Ingot
	{ id = 27509, chance = 99829 }, -- Heavy Crystal Fragment
	{ id = 3039, chance = 17006 }, -- Red Gem
	{ id = 9057, chance = 21428 }, -- Small Topaz
	{ id = 22516, chance = 21428 }, -- Silver Token
	{ id = 22721, chance = 9693 }, -- Gold Token
	{ id = 27651, chance = 850 }, -- Gnome Sword
	{ id = 27650, chance = 2380 }, -- Gnome Shield
	{ id = 27648, chance = 850 }, -- Gnome Armor
	{ id = 27655, chance = 212 }, -- Plan for a Makeshift Armour
	{ id = 27524, chance = 424 }, -- Mallet Head
	{ id = 3036, chance = 4421 }, -- Violet Gem
	{ id = 8073, chance = 2760 }, -- Spellbook of Warding
	{ id = 27605, chance = 510 }, -- Candle Stump
	{ id = 50290, chance = 1000 }, -- Gnomish Footwraps
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
