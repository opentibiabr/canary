local mType = Game.createMonsterType("Angry Demon")
local monster = {}

monster.description = "an angry demon"
monster.experience = 6000
monster.outfit = {
	lookType = 35,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "fire"
monster.corpse = 5995
monster.speed = 128
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	maxSummons = 1,
	summons = {
		{ name = "fire elemental", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your soul will be mine!", yell = false },
	{ text = "CHAMEK ATH UTHUL ARAK!", yell = true },
	{ text = "I SMELL FEEEEAAAAAR!", yell = true },
	{ text = "Your resistance is futile!", yell = false },
	{ text = "MUHAHAHA", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 6 }, -- Platinum Coin
	{ id = 238, chance = 9090, maxCount = 3 }, -- Great Mana Potion
	{ id = 7642, chance = 18180, maxCount = 3 }, -- Great Spirit Potion
	{ id = 6499, chance = 9090 }, -- Demonic Essence
	{ id = 7643, chance = 18180, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 5954, chance = 9090 }, -- Demon Horn
	{ id = 3731, chance = 27269, maxCount = 6 }, -- Fire Mushroom
	{ id = 7368, chance = 27269, maxCount = 10 }, -- Assassin Star
	{ id = 9057, chance = 1000, maxCount = 5 }, -- Small Topaz
	{ id = 3030, chance = 9090, maxCount = 5 }, -- Small Ruby
	{ id = 3033, chance = 36360, maxCount = 5 }, -- Small Amethyst
	{ id = 3032, chance = 9090, maxCount = 5 }, -- Small Emerald
	{ id = 3034, chance = 18180 }, -- Talon
	{ id = 3060, chance = 9090 }, -- Orb
	{ id = 3320, chance = 1000 }, -- Fire Axe
	{ id = 3049, chance = 1000 }, -- Stealth Ring
	{ id = 3039, chance = 1000 }, -- Red Gem
	{ id = 3098, chance = 9090 }, -- Ring of Healing
	{ id = 3048, chance = 18180 }, -- Might Ring
	{ id = 3281, chance = 1000 }, -- Giant Sword
	{ id = 3284, chance = 1000 }, -- Ice Rapier
	{ id = 3306, chance = 1000 }, -- Golden Sickle
	{ id = 2848, chance = 1000 }, -- Purple Tome
	{ id = 3356, chance = 9090 }, -- Devil Helmet
	{ id = 3063, chance = 1000 }, -- Gold Ring
	{ id = 3420, chance = 1000 }, -- Demon Shield
	{ id = 3055, chance = 1000 }, -- Platinum Amulet
	{ id = 3414, chance = 9090 }, -- Mastermind Shield
	{ id = 3364, chance = 1000 }, -- Golden Legs
	{ id = 3366, chance = 1000 }, -- Magic Plate Armor
	{ id = 7393, chance = 1000 }, -- Demon Trophy
	{ id = 7382, chance = 1000 }, -- Demonrage Sword
}

monster.attacks = {
	-- {name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520},
	-- {name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false},
	-- {name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	-- {name ="firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	-- {name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -490, length = 8,spread = 03, effect = CONST_ME_PURPLEENERGY, target = false},
	-- {name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -300, range = 1, shootEffect = CONST_ANI_ENERGY, target = false},
	-- {name ="speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000}
	{ name = "melee", interval = 2000, chance = 500, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 30, maxDamage = -120, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -480, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -300, range = 1, shootEffect = CONST_ANI_ENERGY, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -12 },
	{ type = COMBAT_HOLYDAMAGE, percent = -12 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
