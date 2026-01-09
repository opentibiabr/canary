local mType = Game.createMonsterType("Werecrocodile")
local monster = {}

monster.description = "a werecrocodile"
monster.experience = 4140
monster.outfit = {
	lookType = 1647,
	lookHead = 95,
	lookBody = 117,
	lookLegs = 4,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2388
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Murky Caverns",
}

monster.health = 5280
monster.maxHealth = 5280
monster.race = "blood"
monster.corpse = 43754
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	rewardBoss = false,
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

monster.voices = {}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 13 }, -- Platinum Coin
	{ id = 43729, chance = 11750 }, -- Werecrocodile Tongue
	{ id = 3556, chance = 4730 }, -- Crocodile Boots
	{ id = 3297, chance = 6860 }, -- Serpent Sword
	{ id = 3577, chance = 5600, maxCount = 4 }, -- Meat
	{ id = 22083, chance = 4730 }, -- Moonlight Crystals
	{ id = 3039, chance = 4500 }, -- Red Gem
	{ id = 16121, chance = 3470 }, -- Green Crystal Shard
	{ id = 7454, chance = 2840 }, -- Glorious Axe
	{ id = 43734, chance = 790 }, -- Golden Sun Coin
	{ id = 7428, chance = 790 }, -- Bonebreaker
	{ id = 43916, chance = 320 }, -- Werecrocodile Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -575 },
	{ name = "combat", interval = 2700, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -175, maxDamage = -325, radius = 1, effect = CONST_ME_BIG_SCRATCH, range = 1, target = true },
	{ name = "combat", interval = 3300, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -375, length = 6, spread = 3, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 3700, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -400, radius = 2, range = 4, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 82,
	mitigation = 2.28,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
