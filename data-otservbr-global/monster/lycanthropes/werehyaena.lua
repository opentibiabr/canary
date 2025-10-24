local mType = Game.createMonsterType("Werehyaena")
local monster = {}

monster.description = "a werehyaena"
monster.experience = 2200
monster.outfit = {
	lookType = 1300,
	lookHead = 57,
	lookBody = 77,
	lookLegs = 1,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1963
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Darashia Wyrm Hills only during night, Hyaena Lairs.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 33821
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 30,
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
	{ text = "Snarl!", yell = false },
}

monster.loot = {
	{ id = 239, chance = 49983 }, -- Great Health Potion
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 33943, chance = 12902 }, -- Werehyaena Nose
	{ id = 678, chance = 5630 }, -- Small Enchanted Amethyst
	{ id = 17813, chance = 5479 }, -- Life Preserver
	{ id = 22083, chance = 923 }, -- Moonlight Crystals
	{ id = 3039, chance = 5461 }, -- Red Gem
	{ id = 3292, chance = 4855 }, -- Combat Knife
	{ id = 3037, chance = 5749 }, -- Yellow Gem
	{ id = 3269, chance = 11390 }, -- Halberd
	{ id = 16126, chance = 9759 }, -- Red Crystal Fragment
	{ id = 3274, chance = 15805 }, -- Axe
	{ id = 3577, chance = 18990 }, -- Meat
	{ id = 3291, chance = 17155 }, -- Knife
	{ id = 16127, chance = 4415 }, -- Green Crystal Fragment
	{ id = 17812, chance = 3927 }, -- Ratana
	{ id = 33944, chance = 550 }, -- Werehyaena Talisman
	{ id = 34219, chance = 150 }, -- Werehyaena Trophy
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2 * 1000, minDamage = 0, maxDamage = -300 },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2 * 1000, chance = 17, minDamage = -175, maxDamage = -255, radius = 3, effect = CONST_ME_HITBYPOISON },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2 * 1000, chance = 15, minDamage = -330, maxDamage = -370, target = true, range = 5, radius = 1, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_MORTAREA },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2 * 1000, chance = 13, minDamage = -225, maxDamage = -275, length = 3, spread = 0, effect = CONST_ME_MORTAREA },
}

monster.defenses = {
	{ name = "speed", chance = 15, interval = 2 * 1000, speed = 200, duration = 5 * 1000, effect = CONST_ME_MAGIC_BLUE },
	defense = 0,
	armor = 36,
	mitigation = 0.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
