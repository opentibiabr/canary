local mType = Game.createMonsterType("Control Tower")
local monster = {}

monster.description = "a control tower"
monster.experience = 3000
monster.outfit = {
	lookTypeEx = 20894,
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 21940
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = true,
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
	{ id = 21168, chance = 80000 }, -- alloy legs
	{ id = 9016, chance = 80000 }, -- flask of rust remover
	{ id = 21170, chance = 80000 }, -- gearwheel chain
	{ id = 3554, chance = 80000 }, -- steel boots
	{ id = 21167, chance = 80000 }, -- heat core
	{ id = 9654, chance = 80000 }, -- war crystal
	{ id = 9066, chance = 80000 }, -- crystal pedestal
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 8775, chance = 80000 }, -- gear wheel
	{ id = 5880, chance = 80000 }, -- iron ore
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 21169, chance = 80000 }, -- metal spats
	{ id = 21171, chance = 80000 }, -- metal bat
	{ id = 7428, chance = 80000 }, -- bonebreaker
}

monster.defenses = {
	defense = 10,
	armor = 10,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 55 },
	{ type = COMBAT_EARTHDAMAGE, percent = 55 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 55 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
