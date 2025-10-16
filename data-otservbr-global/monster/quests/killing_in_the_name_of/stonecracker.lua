local mType = Game.createMonsterType("Stonecracker")
local monster = {}

monster.description = "Stonecracker"
monster.experience = 3500
monster.outfit = {
	lookType = 55,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 5999
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "HUAHAHA!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 78 }, -- gold coin
	{ id = 3577, chance = 80000, maxCount = 3 }, -- meat
	{ id = 3116, chance = 80000 }, -- big bone
	{ id = 3304, chance = 80000 }, -- crowbar
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3265, chance = 80000 }, -- two handed sword
	{ id = 7368, chance = 80000, maxCount = 100 }, -- assassin star
	{ id = 3342, chance = 80000 }, -- war axe
	{ id = 3033, chance = 80000, maxCount = 3 }, -- small amethyst
	{ id = 3058, chance = 80000 }, -- strange symbol
	{ id = 3383, chance = 80000 }, -- dark armor
	{ id = 3554, chance = 80000 }, -- steel boots
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 10310, chance = 80000 }, -- shiny stone
	{ id = 5893, chance = 80000 }, -- perfect behemoth fang
	{ id = 5930, chance = 80000 }, -- behemoth claw
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 7396, chance = 80000 }, -- behemoth trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -564 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -280, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	mitigation = 1.94,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 360, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 500, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
