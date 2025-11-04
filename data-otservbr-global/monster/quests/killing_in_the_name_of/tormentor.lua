local mType = Game.createMonsterType("Tormentor")
local monster = {}

monster.description = "Tormentor"
monster.experience = 3200
monster.outfit = {
	lookType = 245,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 6339
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Take a ride with me.", yell = false },
	{ text = "Pffffrrrrrrrrrrrr.", yell = false },
	{ text = "Close your eyes... I have something for you.", yell = false },
	{ text = "I will make you scream.", yell = false },
}

monster.loot = {
	{ id = 6558, chance = 100000, maxCount = 5 }, -- Flask of Demonic Blood
	{ id = 6299, chance = 100000 }, -- Death Ring
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 10306, chance = 100000 }, -- Essence of a Bad Dream
	{ id = 3582, chance = 100000 }, -- Ham
	{ id = 3371, chance = 71830 }, -- Knight Legs
	{ id = 3342, chance = 15490 }, -- War Axe
	{ id = 6525, chance = 33800 }, -- Skeleton Decoration
	{ id = 5668, chance = 43660 }, -- Mysterious Voodoo Skull
	{ id = 3035, chance = 92960, maxCount = 10 }, -- Platinum Coin
	{ id = 10312, chance = 87320 }, -- Scythe Leg
	{ id = 3079, chance = 12680 }, -- Boots of Haste
	{ id = 7418, chance = 9860 }, -- Nightmare Blade
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -340 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -130, maxDamage = -170, range = 7, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -400, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.23,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 60, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
