local mType = Game.createMonsterType("Hollowsnake")
local monster = {}

monster.description = "Hollowsnake"
monster.experience = 85500
monster.outfit = {
	lookType = 1013,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 140000
monster.maxHealth = 140000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 570
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 100,
}

monster.strategiesTarget = {
	nearest = 20,
	health = 10,
	damage = 10,
	random = 70,
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
	staticAttackChance = 95,
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
	chance = 80,
	{ text = "You cant run", yell = false },
	{ text = "Turtle", yell = false },
}

monster.loot = {
    { name = "koliseum token", chance = 9000000, minCount = 25, maxCount = 30},

}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 72, type = COMBAT_FIREDAMAGE, minDamage = -1550, maxDamage = -1700, length = 13, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2600, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -920, range = 16, radius = 14, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1550, chance = 70, type = COMBAT_FIREDAMAGE, minDamage = -490, maxDamage = -720, range = 16, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -600, maxDamage = -850, range = 5, radius = 16, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },

}

monster.defenses = {
	defense = 35,
	armor = 35,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_HEALING, minDamage = 1200, maxDamage = 1450, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
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
