local mType = Game.createMonsterType("Glooth Battery")
local monster = {}

monster.description = "a glooth battery"
monster.experience = 3000
monster.outfit = {
	lookTypeEx = 20710,
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 21940
monster.speed = 0
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 9066, chance = 80000 }, -- crystal pedestal
	{ id = 21169, chance = 80000 }, -- metal spats
	{ id = 21170, chance = 80000 }, -- gearwheel chain
	{ id = 9016, chance = 80000 }, -- flask of rust remover
	{ id = 8775, chance = 80000 }, -- gear wheel
	{ id = 5880, chance = 80000 }, -- iron ore
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 3554, chance = 80000 }, -- steel boots
	{ id = 21167, chance = 80000 }, -- heat core
	{ id = 21168, chance = 80000 }, -- alloy legs
	{ id = 9654, chance = 80000 }, -- war crystal
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -206, maxDamage = -252, radius = 6, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 133, maxDamage = 454, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 1 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
