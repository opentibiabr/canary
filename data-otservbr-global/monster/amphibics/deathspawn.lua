local mType = Game.createMonsterType("Deathspawn")
local monster = {}

monster.description = "a deathspawn"
monster.experience = 0
monster.outfit = {
	lookType = 226,
	lookHead = 114,
	lookBody = 98,
	lookLegs = 97,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 225
monster.maxHealth = 225
monster.race = "blood"
monster.corpse = 3105
monster.speed = 51
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -40, effect = CONST_ME_DRAWBLOOD, { type = CONDITION_POISON, totalDamage = 30, interval = 4000 } },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, range = 7, effect = CONST_ANI_DEATH, target = true },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -450, range = 7, effect = CONST_ANI_ENERGY, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 1,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
