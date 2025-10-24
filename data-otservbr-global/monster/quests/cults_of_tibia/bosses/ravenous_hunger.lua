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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 3028, chance = 21122, maxCount = 10 }, -- Small Diamond
	{ id = 3029, chance = 20053, maxCount = 10 }, -- Small Sapphire
	{ id = 3032, chance = 18983, maxCount = 10 }, -- Small Emerald
	{ id = 7643, chance = 52139, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 7642, chance = 53208, maxCount = 5 }, -- Great Spirit Potion
	{ id = 238, chance = 56684, maxCount = 5 }, -- Great Mana Potion
	{ id = 23535, chance = 100000, maxCount = 5 }, -- Energy Bar
	{ id = 3037, chance = 20053 }, -- Yellow Gem
	{ id = 3039, chance = 19518 }, -- Red Gem
	{ id = 3038, chance = 27540 }, -- Green Gem
	{ id = 281, chance = 16310 }, -- Giant Shimmering Pearl
	{ id = 21981, chance = 8288 }, -- Oriental Shoes
	{ id = 11652, chance = 13636 }, -- Broken Key Ring
	{ id = 25743, chance = 99732 }, -- Bed of Nails
	{ id = 25744, chance = 48395 }, -- Torn Shirt
	{ id = 16117, chance = 67647 }, -- Muck Rod
	{ id = 822, chance = 4812 }, -- Lightning Legs
	{ id = 25742, chance = 50267 }, -- Fig Leaf
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 9302, chance = 62032 }, -- Sacred Tree Amulet
	{ id = 11454, chance = 15775 }, -- Luminous Orb
	{ id = 11674, chance = 5882 }, -- Cobra Crown
	{ id = 3575, chance = 61764 }, -- Wood Cape
	{ id = 25699, chance = 11497 }, -- Wooden Spellbook
	{ id = 22516, chance = 28074 }, -- Silver Token
	{ id = 22721, chance = 21925 }, -- Gold Token
	{ id = 3401, chance = 1604 }, -- Elven Legs
	{ id = 3399, chance = 1612 }, -- Elven Mail
	{ id = 3033, chance = 17379 }, -- Small Amethyst
	{ id = 3041, chance = 27807 }, -- Blue Gem
	{ id = 811, chance = 5882 }, -- Terra Mantle
	{ id = 9057, chance = 21122 }, -- Small Topaz
	{ id = 25361, chance = 584 }, -- Blood of the Mountain (Item)
	{ id = 5904, chance = 17379 }, -- Magic Sulphur
	{ id = 10451, chance = 9625 }, -- Jade Hat
	{ id = 813, chance = 14438 }, -- Terra Boots
	{ id = 7463, chance = 8556 }, -- Mammoth Fur Cape
	{ id = 3036, chance = 5347 }, -- Violet Gem
	{ id = 3079, chance = 802 }, -- Boots of Haste
	{ id = 8050, chance = 3475 }, -- Crystalline Armor
	{ id = 50154, chance = 1000 }, -- Enchanted Merudri Brooch
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
