local mType = Game.createMonsterType("Skeleton Elite Warrior")
local monster = {}

monster.description = "a skeleton elite warrior"
monster.experience = 4800
monster.outfit = {
	lookType = 298,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1674
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep Desert.",
}

monster.health = 7800
monster.maxHealth = 7800
monster.race = "undead"
monster.corpse = 5972
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canWalkOnEnergy = false,
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

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 7573, chance = 80000 }, -- bone
	{ id = 5944, chance = 80000, maxCount = 5 }, -- soul orb
	{ id = 3723, chance = 80000 }, -- white mushroom
	{ id = 11481, chance = 23000, maxCount = 3 }, -- pelvis bone
	{ id = 10316, chance = 23000 }, -- unholy bone
	{ id = 3318, chance = 23000 }, -- knight axe
	{ id = 24380, chance = 5000 }, -- bone toothpick
	{ id = 7381, chance = 5000 }, -- mammoth whopper
	{ id = 5741, chance = 5000 }, -- skull helmet
	{ id = 3725, chance = 5000 }, -- brown mushroom
	{ id = 3286, chance = 5000 }, -- mace
	{ id = 3264, chance = 5000 }, -- sword
	{ id = 6553, chance = 1000 }, -- ruthless axe
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -700 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -480, range = 1, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -380, maxDamage = -520, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 75,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
