local mType = Game.createMonsterType("The Flaming Orchid")
local monster = {}

monster.description = "a flaming orchid"
monster.experience = 8500
monster.outfit = {
	lookType = 150,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 21987 -- review later
monster.speed = 210
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
	interval = 2000,
	chance = 7,
	{ text = "I will end your torment. Do not run, little mortal.", yell = true },
	{ text = "*SNIFF* *SNIFF* BLOOD! I CAN SMELL YOU, MORTAL!!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 284 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 7368, chance = 46000, maxCount = 15 }, -- Assassin Star
	{ id = 6558, chance = 37000, maxCount = 3 }, -- Flask of Demonic Blood
	{ id = 6499, chance = 32000 }, -- Demonic Essence
	{ id = 3033, chance = 25000, maxCount = 3 }, -- Small Amethyst
	{ id = 238, chance = 18500, maxCount = 5 }, -- Great Mana Potion
	{ id = 5944, chance = 18500 }, -- Soul Orb
	{ id = 7642, chance = 16200, maxCount = 5 }, -- Great Spirit Potion
	{ id = 3070, chance = 15800 }, -- Moonlight Rod
	{ id = 3007, chance = 13800 }, -- Crystal Ring
	{ id = 7643, chance = 13100, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3039, chance = 11200 }, -- Red Gem
	{ id = 3069, chance = 7300 }, -- Necrotic Rod
	{ id = 48238, chance = 6500 }, -- Rose Milk Cake
	{ id = 9058, chance = 5400, maxCount = 3 }, -- Gold Ingot
	{ id = 8082, chance = 5400 }, -- Underworld Rod
	{ id = 3038, chance = 4600 }, -- Green Gem
	{ id = 6299, chance = 3800 }, -- Death Ring
	{ id = 21981, chance = 3100 }, -- Oriental Shoes
	{ id = 3036, chance = 2700 }, -- Violet Gem
	{ id = 821, chance = 2300 }, -- Magma Legs
	{ id = 7404, chance = 1500 }, -- Assassin Dagger
	{ id = 38634, chance = 1500 }, -- Flamingo Feather
	{ id = 826, chance = 770 }, -- Magma Coat
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -25 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, range = 7, effect = CONST_ANI_DEATH, target = true },
	{ name = "Ignite", interval = 2000, chance = 20, range = 7, radius = 1, target = true, shootEffect = CONST_ANI_FIRE },
	{ name = "big death wave", interval = 4000, chance = 18, minDamage = 0, maxDamage = -500 }, -- review later
	{ name = "aggressivelavawave", interval = 5000, chance = 19, minDamage = 0, maxDamage = -200 }, -- review later
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_FIREDAMAGE, range = 5, radius = 7, target = true, minDamage = -100, maxDamage = -250, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, duration = 5000, areaEffect = CONST_ME_MAGIC_RED },
	{ name = "invisible", interval = 1000, chance = 100, duration = 10000, areaEffect = CONST_ME_MAGIC_BLUE },
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
