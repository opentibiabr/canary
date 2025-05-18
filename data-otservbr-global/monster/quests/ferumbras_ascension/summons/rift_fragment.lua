local mType = Game.createMonsterType("Rift Fragment")
local monster = {}

monster.description = "a rift fragment"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 2122,
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "venom"
monster.corpse = 0
monster.speed = 125
monster.manaCost = 50

monster.changeTarget = {
	interval = 2000,
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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 1400,
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

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 13 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DROWNDAMAGE, minDamage = -260, maxDamage = -320, radius = 6, effect = CONST_ME_BUBBLES, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DROWNDAMAGE, minDamage = -160, maxDamage = -320, range = 6, effect = CONST_ME_BUBBLES, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 40,
	--	mitigation = ???,
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
