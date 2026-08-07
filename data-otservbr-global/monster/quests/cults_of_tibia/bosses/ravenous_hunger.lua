local mType = Game.createMonsterType("Ravenous Hunger")
local monster = {}

monster.description = "Ravenous Hunger"
monster.experience = 0
monster.outfit = {
	lookType = 556,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1427,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 6323
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	staticAttackChance = 95,
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "SU-*burp* SUFFEEER!", yell = false },
}

monster.loot = {
	{ id = 23535, chance = 100000, maxCount = 9 }, -- Energy Bar
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 3031, chance = 100000, maxCount = 378 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 48 }, -- Platinum Coin
	{ id = 25743, chance = 99000 }, -- Bed of Nails
	{ id = 9302, chance = 70000 }, -- Sacred Tree Amulet
	{ id = 238, chance = 59000, maxCount = 16 }, -- Great Mana Potion
	{ id = 16117, chance = 59000 }, -- Muck Rod
	{ id = 3575, chance = 58000 }, -- Wood Cape
	{ id = 7643, chance = 53000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 25742, chance = 52000 }, -- Fig Leaf
	{ id = 7642, chance = 48000, maxCount = 18 }, -- Great Spirit Potion
	{ id = 25744, chance = 47000 }, -- Torn Shirt
	{ id = 3041, chance = 32000, maxCount = 2 }, -- Blue Gem
	{ id = 22721, chance = 26000 }, -- Gold Token
	{ id = 3029, chance = 26000, maxCount = 19 }, -- Small Sapphire
	{ id = 3038, chance = 25000, maxCount = 2 }, -- Green Gem
	{ id = 5904, chance = 21000 }, -- Magic Sulphur
	{ id = 22516, chance = 21000 }, -- Silver Token
	{ id = 3028, chance = 19000, maxCount = 19 }, -- Small Diamond
	{ id = 3032, chance = 19000, maxCount = 19 }, -- Small Emerald
	{ id = 3039, chance = 16400 }, -- Red Gem
	{ id = 281, chance = 15500 }, -- Giant Shimmering Pearl
	{ id = 813, chance = 15500 }, -- Terra Boots
	{ id = 9057, chance = 15500, maxCount = 17 }, -- Small Topaz
	{ id = 3037, chance = 15500 }, -- Yellow Gem
	{ id = 11454, chance = 15500 }, -- Luminous Orb
	{ id = 3033, chance = 14700, maxCount = 19 }, -- Small Amethyst
	{ id = 11652, chance = 12900 }, -- Broken Key Ring
	{ id = 21981, chance = 12100 }, -- Oriental Shoes
	{ id = 25699, chance = 12100 }, -- Wooden Spellbook
	{ id = 7463, chance = 10300 }, -- Mammoth Fur Cape
	{ id = 822, chance = 6900 }, -- Lightning Legs
	{ id = 811, chance = 6000 }, -- Terra Mantle
	{ id = 10451, chance = 4300 }, -- Jade Hat
	{ id = 3036, chance = 4300 }, -- Violet Gem
	{ id = 11674, chance = 2600 }, -- Cobra Crown
	{ id = 3399, chance = 1700 }, -- Elven Mail
	{ id = 3401, chance = 1700 }, -- Elven Legs
	{ id = 8050, chance = 1700 }, -- Crystalline Armor
	{ id = 3079, chance = 860 }, -- Boots of Haste
	{ id = 50154, chance = 860 }, -- Enchanted Merudri Brooch
	{ id = 49372, chance = 860 }, -- Spiritualist Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
