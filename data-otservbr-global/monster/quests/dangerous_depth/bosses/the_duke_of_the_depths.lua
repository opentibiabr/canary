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
	{ id = 3035, chance = 100000, maxCount = 36 }, -- Platinum Coin
	{ id = 3043, chance = 8306 }, -- Crystal Coin
	{ id = 16119, chance = 65495, maxCount = 4 }, -- Blue Crystal Shard
	{ id = 27619, chance = 16293 }, -- Giant Tentacle
	{ id = 5892, chance = 19648 }, -- Huge Chunk of Crude Iron
	{ id = 3037, chance = 17092 }, -- Yellow Gem
	{ id = 3041, chance = 23482 }, -- Blue Gem
	{ id = 3039, chance = 15654 }, -- Red Gem
	{ id = 3028, chance = 21086, maxCount = 2 }, -- Small Diamond
	{ id = 3032, chance = 17571, maxCount = 12 }, -- Small Emerald
	{ id = 3033, chance = 19329, maxCount = 12 }, -- Small Amethyst
	{ id = 3030, chance = 16613, maxCount = 12 }, -- Small Ruby
	{ id = 9057, chance = 17412, maxCount = 12 }, -- Small Topaz
	{ id = 3071, chance = 67571 }, -- Wand of Inferno
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 7440, chance = 100000, maxCount = 2 }, -- Mastermind Potion
	{ id = 11454, chance = 43929 }, -- Luminous Orb
	{ id = 811, chance = 3194 }, -- Terra Mantle
	{ id = 5904, chance = 18370 }, -- Magic Sulphur
	{ id = 3320, chance = 69169 }, -- Fire Axe
	{ id = 3280, chance = 63578 }, -- Fire Sword
	{ id = 239, chance = 1000, maxCount = 8 }, -- Great Health Potion
	{ id = 7643, chance = 52076, maxCount = 8 }, -- Ultimate Health Potion
	{ id = 238, chance = 57987, maxCount = 18 }, -- Great Mana Potion
	{ id = 7642, chance = 58626, maxCount = 10 }, -- Great Spirit Potion
	{ id = 27620, chance = 16613 }, -- Damaged Worm Head
	{ id = 27618, chance = 5750 }, -- Pristine Worm Head
	{ id = 16117, chance = 7507 }, -- Muck Rod
	{ id = 8908, chance = 19009 }, -- Slightly Rusted Helmet
	{ id = 8050, chance = 2236 }, -- Crystalline Armor
	{ id = 3038, chance = 18210 }, -- Green Gem
	{ id = 8902, chance = 18370 }, -- Slightly Rusted Shield
	{ id = 27509, chance = 100319 }, -- Heavy Crystal Fragment
	{ id = 281, chance = 13418 }, -- Giant Shimmering Pearl
	{ id = 22516, chance = 11661 }, -- Silver Token
	{ id = 22721, chance = 24281 }, -- Gold Token
	{ id = 27651, chance = 3180 }, -- Gnome Sword
	{ id = 27650, chance = 2076 }, -- Gnome Shield
	{ id = 27605, chance = 479 }, -- Candle Stump
	{ id = 27657, chance = 198 }, -- Crude Wood Planks
	{ id = 27649, chance = 958 }, -- Gnome Legs
	{ id = 27526, chance = 397 }, -- Mallet Pommel
	{ id = 3036, chance = 4153 }, -- Violet Gem
	{ id = 826, chance = 2236 }, -- Magma Coat
	{ id = 10438, chance = 1118 }, -- Spellweaver's Robe
	{ id = 50290, chance = 1000 }, -- Gnomish Footwraps
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
