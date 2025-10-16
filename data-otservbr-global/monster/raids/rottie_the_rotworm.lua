local mType = Game.createMonsterType("Rottie the Rotworm")
local monster = {}

monster.description = "Rottie the Rotworm"
monster.experience = 40
monster.outfit = {
	lookType = 26,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 65
monster.maxHealth = 65
monster.race = "blood"
monster.corpse = 5967
monster.speed = 90
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
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
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 27 }, -- gold coin
	{ id = 3492, chance = 80000, maxCount = 5 }, -- worm
	{ id = 3582, chance = 80000, maxCount = 2 }, -- ham
	{ id = 3577, chance = 80000, maxCount = 2 }, -- meat
	{ id = 3286, chance = 80000 }, -- mace
	{ id = 3264, chance = 80000 }, -- sword
	{ id = 3374, chance = 1000 }, -- legion helmet
	{ id = 3430, chance = 1000 }, -- copper shield
	{ id = 3300, chance = 1000 }, -- katana
	{ id = 9692, chance = 80000 }, -- lump of dirt
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 30, attack = 30 },
}

monster.defenses = {
	defense = 11,
	armor = 8,
	mitigation = 0.38,
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
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
