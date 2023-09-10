local mType = Game.createMonsterType("Corrupt Naga")
local monster = {}

monster.description = "a corrupt naga"
monster.experience = 4380
monster.outfit = {
	lookType = 1538,
	lookHead = 55,
	lookBody = 6,
	lookLegs = 0,
	lookFeet = 78,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 5990
monster.maxHealth = 5990
monster.race = "blood"
monster.corpse = 0
monster.speed = 182
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
	canPushCreatures = true,
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
	{ name = "Platinum Coin", chance = 75420, minCount = 1, maxCount = 8 },
	{ name = "Violet Crystal Shard", chance = 24580, minCount = 1, maxCount = 2 },
	{ name = "Corrupt Naga Scales", chance = 17720 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, minDamage = -300, maxDamage = -600, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "nagadeath", interval = 6000, chance = 39, target = false, minDamage = -1000, maxDamage = -2200 },
	{ name = "nagadeathattack", interval = 3000, chance = 68, target = true, minDamage = -400, maxDamage = -600 },
}

monster.defenses = {
	defense = 110,
	armor = 0,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
