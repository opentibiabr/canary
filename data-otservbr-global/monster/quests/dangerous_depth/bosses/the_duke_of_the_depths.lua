local mType = Game.createMonsterType("The Duke of the Depths")
local monster = {}

monster.description = "The Duke Of The Depths"
monster.experience = 300000
monster.outfit = {
	lookType = 1047,
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
monster.corpse = 27641
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
}

monster.bosstiary = {
	bossRaceId = 1520,
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
	{ text = "SzzzSzzz!", yell = false },
	{ text = "Chhhhhh!", yell = false },
}

monster.loot = {
	{ id = 27509, chance = 100000 }, -- Heavy Crystal Fragment
	{ id = 3035, chance = 100000, maxCount = 88 }, -- Platinum Coin
	{ id = 7440, chance = 100000, maxCount = 3 }, -- Mastermind Potion
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 3071, chance = 73000 }, -- Wand of Inferno
	{ id = 3320, chance = 72000 }, -- Fire Axe
	{ id = 3280, chance = 68000 }, -- Fire Sword
	{ id = 16119, chance = 66000, maxCount = 7 }, -- Blue Crystal Shard
	{ id = 238, chance = 60000, maxCount = 31 }, -- Great Mana Potion
	{ id = 7642, chance = 57000, maxCount = 24 }, -- Great Spirit Potion
	{ id = 7643, chance = 51000, maxCount = 27 }, -- Ultimate Health Potion
	{ id = 11454, chance = 46000 }, -- Luminous Orb
	{ id = 22721, chance = 26000 }, -- Gold Token
	{ id = 3041, chance = 26000 }, -- Blue Gem
	{ id = 3033, chance = 25000, maxCount = 23 }, -- Small Amethyst
	{ id = 3039, chance = 23000 }, -- Red Gem
	{ id = 8902, chance = 21000 }, -- Slightly Rusted Shield
	{ id = 3028, chance = 20000, maxCount = 22 }, -- Small Diamond
	{ id = 8908, chance = 20000 }, -- Slightly Rusted Helmet
	{ id = 5892, chance = 19500, maxCount = 3 }, -- Huge Chunk of Crude Iron
	{ id = 3032, chance = 19500, maxCount = 23 }, -- Small Emerald
	{ id = 27620, chance = 18800 }, -- Damaged Worm Head
	{ id = 9057, chance = 17400, maxCount = 23 }, -- Small Topaz
	{ id = 3037, chance = 16100 }, -- Yellow Gem
	{ id = 27619, chance = 15400 }, -- Giant Tentacle
	{ id = 3038, chance = 15400 }, -- Green Gem
	{ id = 5904, chance = 14800 }, -- Magic Sulphur
	{ id = 3030, chance = 11400, maxCount = 19 }, -- Small Ruby
	{ id = 22516, chance = 10100 }, -- Silver Token
	{ id = 3043, chance = 9400 }, -- Crystal Coin
	{ id = 281, chance = 9400 }, -- Giant Shimmering Pearl
	{ id = 27618, chance = 5400 }, -- Pristine Worm Head
	{ id = 16117, chance = 4000 }, -- Muck Rod
	{ id = 3036, chance = 3400 }, -- Violet Gem
	{ id = 826, chance = 3400 }, -- Magma Coat
	{ id = 811, chance = 2000 }, -- Terra Mantle
	{ id = 10438, chance = 2000 }, -- Spellweaver's Robe
	{ id = 27650, chance = 2000 }, -- Gnome Shield
	{ id = 27605, chance = 1300 }, -- Candle Stump
	{ id = 8050, chance = 1300 }, -- Crystalline Armor
	{ id = 27649, chance = 670 }, -- Gnome Legs
	{ id = 50290, chance = 670 }, -- Gnomish Footwraps
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 6, spread = 8, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -1000, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false },
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

monster.heals = {
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
}

mType:register(monster)
