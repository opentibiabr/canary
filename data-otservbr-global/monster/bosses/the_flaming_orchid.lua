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
	{ id = 3031, chance = 100000, maxCount = 238 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 7 }, -- Platinum Coin
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 7642, chance = 15384, maxCount = 2 }, -- Great Spirit Potion
	{ id = 21981, chance = 3978 }, -- Oriental Shoes
	{ id = 8082, chance = 4320 }, -- Underworld Rod
	{ id = 6558, chance = 36870 }, -- Flask of Demonic Blood
	{ id = 7368, chance = 47745 }, -- Assassin Star
	{ id = 3033, chance = 28116 }, -- Small Amethyst
	{ id = 3039, chance = 10609 }, -- Red Gem
	{ id = 9058, chance = 4774 }, -- Gold Ingot
	{ id = 238, chance = 16975 }, -- Great Mana Potion
	{ id = 5944, chance = 18036 }, -- Soul Orb
	{ id = 3070, chance = 14853 }, -- Moonlight Rod
	{ id = 6299, chance = 4244 }, -- Death Ring
	{ id = 7643, chance = 14322 }, -- Ultimate Health Potion
	{ id = 6499, chance = 30769 }, -- Demonic Essence
	{ id = 3007, chance = 12466 }, -- Crystal Ring
	{ id = 3038, chance = 5304 }, -- Green Gem
	{ id = 3069, chance = 6897 }, -- Necrotic Rod
	{ id = 7404, chance = 1857 }, -- Assassin Dagger
	{ id = 38634, chance = 3703 }, -- Flamingo Feather
	{ id = 3036, chance = 2160 }, -- Violet Gem
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
