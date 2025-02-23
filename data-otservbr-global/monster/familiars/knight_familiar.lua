local mType = Game.createMonsterType("Knight familiar")
local monster = {}

monster.description = "a knight familiar"
monster.experience = 0
monster.outfit = {
	--lookType = 991,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "undead"
monster.corpse = 0
monster.speed = 154
monster.manaCost = 1000

monster.changeTarget = {
	interval = 4000,
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
	hostile = false,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	familiar = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "sudden death rune", interval = 2000, chance = 17, minDamage = -300, maxDamage = -350, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -250, range = 6, radius = 2, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -180, maxDamage = -250, range = 5, radius = 3, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -180, maxDamage = -250, range = 5, radius = 3, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -250, range = 6, radius = 2, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "ice strike", interval = 2000, chance = 17, minDamage = -300, maxDamage = -350, range = 5, target = true },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 75, type = COMBAT_HEALING, minDamage = 300, maxDamage = 300, effect = CONST_ME_MAGIC_GREEN, target = false },
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
	{ type = "invisible", condition = true },
}

mType:register(monster)
