local mType = Game.createMonsterType("The Forgemaster")
local monster = {}

monster.description = "the forgemaster"
monster.experience = 0
monster.outfit = {
	lookType = 247,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 10500
monster.maxHealth = 10500
monster.race = "venom"
monster.corpse = 0
monster.speed = 160
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
	isPreyExclusive = true,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I will not let you win!", yell = false },
}

monster.attacks = {
	{ name = "melee", interval = 1500, chance = 100, minDamage = -100, maxDamage = -539 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -550, range = 5, effect = CONST_ME_BLOCKHIT, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -320, maxDamage = -480, range = 5, effect = CONST_ME_BLOCKHIT, shootEffect = CONST_ANI_SPEAR, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -420, maxDamage = -580, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_BLACKSMOKE, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -830, maxDamage = -970, length = 6, spread = 4, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -140, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -80, maxDamage = -160, radius = 5, effect = CONST_ME_PURPLESMOKE, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 30,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 23 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)