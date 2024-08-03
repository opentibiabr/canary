local mType = Game.createMonsterType("Memory of an Amazon")
local monster = {}

monster.description = "a memory of an amazon"
monster.experience = 1480
monster.outfit = {
	lookType = 137,
	lookHead = 113,
	lookBody = 120,
	lookLegs = 95,
	lookFeet = 115,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3600
monster.maxHealth = 3600
monster.race = "blood"
monster.corpse = 18042
monster.speed = 86
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ name = "dagger", chance = 80000 },
	{ id = 3114, chance = 80000, maxCount = 2 }, -- skull
	{ name = "gold coin", chance = 40000, maxCount = 20 },
	{ name = "brown bread", chance = 30000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -40, range = 5, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 10,
	armor = 10,
	mitigation = 1.10,
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
