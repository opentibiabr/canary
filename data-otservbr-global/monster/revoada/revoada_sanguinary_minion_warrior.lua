local mType = Game.createMonsterType("Revoada Minion Warrior")
local monster = {}

monster.name = "Sanguinary Minion"
monster.description = "a revoada sanguinary minion"
monster.experience = 1000
monster.outfit = {
	lookType = 1707,
}

monster.health = 160000
monster.maxHealth = 160000
monster.race = "blood"
monster.corpse = 4240
monster.speed = 400
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 15,
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
	canPushCreatures = false,
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
	chance = 10,
	{ text = "I will help you my boss.", yell = false },
	{ text = "Wait for me, for this century battle!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 80, skill = 110, attack = 130 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1800, range = 3, length = 8, spread = 0, effect = CONST_ME_GROUNDSHAKER },
	{ name = "drunk", interval = 1000, chance = 10, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 100,
	armor = 125,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 700, maxDamage = 1200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 8, speedChange = 900, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = -10 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
