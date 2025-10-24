local mType = Game.createMonsterType("Muglex Clan Scavenger")
local monster = {}

monster.description = "a muglex clan scavenger"
monster.experience = 37
monster.outfit = {
	lookType = 297,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 60
monster.maxHealth = 60
monster.race = "blood"
monster.corpse = 6002
monster.speed = 66
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ id = 3031, chance = 100000, maxCount = 12 }, -- Gold Coin
	{ id = 3267, chance = 30302 }, -- Dagger
	{ id = 1781, chance = 22349, maxCount = 2 }, -- Small Stone
	{ id = 3578, chance = 16292, maxCount = 3 }, -- Fish
	{ id = 3462, chance = 14391 }, -- Small Axe
	{ id = 3337, chance = 12308 }, -- Bone Club
	{ id = 3294, chance = 13068 }, -- Short Sword
	{ id = 3115, chance = 10450 }, -- Bone
	{ id = 3120, chance = 8710 }, -- Mouldy Cheese
	{ id = 3361, chance = 7387 }, -- Leather Armor
	{ id = 3355, chance = 8332 }, -- Leather Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 10 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -22, range = 7, shootEffect = CONST_ANI_SPEAR, target = false },
	{ name = "combat", interval = 2000, chance = 3, type = COMBAT_LIFEDRAIN, minDamage = -20, maxDamage = -30, range = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 4,
	armor = 2,
	{ name = "combat", interval = 2000, chance = 1, type = COMBAT_HEALING, minDamage = 10, maxDamage = 20, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 5, speedChange = 140, effect = CONST_ME_ENERGYHIT, target = false, duration = 4000 },
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
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
