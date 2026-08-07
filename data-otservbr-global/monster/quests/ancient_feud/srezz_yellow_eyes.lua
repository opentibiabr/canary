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
	{ id = 7643, chance = 100000, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3035, chance = 100000, maxCount = 17 }, -- Platinum Coin
	{ id = 9058, chance = 26000 }, -- Gold Ingot
	{ id = 9694, chance = 21000, maxCount = 3 }, -- Snake Skin
	{ id = 7440, chance = 16600 }, -- Mastermind Potion
	{ id = 282, chance = 15200 }, -- Giant Shimmering Pearl (Brown)
	{ id = 3027, chance = 9800 }, -- Black Pearl
	{ id = 34103, chance = 8800 }, -- Srezz' Eye
	{ id = 16119, chance = 7100 }, -- Blue Crystal Shard
	{ id = 24392, chance = 5100 }, -- Gemmed Figurine
	{ id = 10313, chance = 5100 }, -- Winged Tail
	{ id = 3036, chance = 4700 }, -- Violet Gem
	{ id = 3038, chance = 3700 }, -- Green Gem
	{ id = 5741, chance = 2400 }, -- Skull Helmet
	{ id = 824, chance = 2400 }, -- Glacier Robe
	{ id = 3041, chance = 2400 }, -- Blue Gem
	{ id = 23531, chance = 2000 }, -- Ring of Green Plasma
	{ id = 823, chance = 1700 }, -- Glacier Kilt
	{ id = 7382, chance = 1400 }, -- Demonrage Sword
	{ id = 3040, chance = 1400 }, -- Gold Nugget
	{ id = 3342, chance = 1400 }, -- War Axe
	{ id = 3281, chance = 680 }, -- Giant Sword
	{ id = 34258, chance = 340 }, -- Red Silk Flower
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
