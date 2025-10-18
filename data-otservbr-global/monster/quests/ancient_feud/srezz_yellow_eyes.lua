local mType = Game.createMonsterType("Srezz Yellow Eyes")
local monster = {}

monster.description = "Srezz Yellow Eyes"
monster.experience = 4800
monster.outfit = {
	lookType = 220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1983,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "venom"
monster.corpse = 6061
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 34103, chance = 6120 }, -- Srezz' Eye
	{ id = 3035, chance = 99913, maxCount = 9 }, -- Platinum Coin
	{ id = 7643, chance = 100000, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 9058, chance = 21637 }, -- Gold Ingot
	{ id = 9694, chance = 21465, maxCount = 2 }, -- Snake Skin
	{ id = 16119, chance = 9655 }, -- Blue Crystal Shard
	{ id = 282, chance = 13706 }, -- Giant Shimmering Pearl (Brown)
	{ id = 7440, chance = 16379 }, -- Mastermind Potion
	{ id = 24392, chance = 5086 }, -- Gemmed Figurine
	{ id = 3027, chance = 9310 }, -- Black Pearl
	{ id = 3041, chance = 4310 }, -- Blue Gem
	{ id = 3281, chance = 2068 }, -- Giant Sword
	{ id = 823, chance = 3362 }, -- Glacier Kilt
	{ id = 7382, chance = 1379 }, -- Demonrage Sword
	{ id = 3038, chance = 4655 }, -- Green Gem
	{ id = 33778, chance = 289 }, -- Raw Watermelon Tourmaline
	{ id = 5741, chance = 2327 }, -- Skull Helmet
	{ id = 3036, chance = 6293 }, -- Violet Gem
	{ id = 3342, chance = 1896 }, -- War Axe
	{ id = 10313, chance = 6379 }, -- Winged Tail
	{ id = 34258, chance = 433 }, -- Red Silk Flower
	{ id = 824, chance = 3103 }, -- Glacier Robe
	{ id = 3040, chance = 948 }, -- Gold Nugget
	{ id = 23531, chance = 1810 }, -- Ring of Green Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -200 },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 20, minDamage = -400, maxDamage = -500, range = 5, radius = 3, spread = 3, target = true, shootEffect = CONST_ANI_POISON, effect = CONST_ME_YELLOW_RINGS },
	{ name = "lleech waveT", interval = 2000, chance = 30, minDamage = -200, maxDamage = -300 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 30, minDamage = -200, maxDamage = -300, length = 5, spread = 3, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 70, minDamage = -200, maxDamage = -350, radius = 4, target = false, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 340, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
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
