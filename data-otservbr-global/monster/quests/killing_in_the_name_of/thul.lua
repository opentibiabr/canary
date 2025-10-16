local mType = Game.createMonsterType("Thul")
local monster = {}

monster.description = "Thul"
monster.experience = 2700
monster.outfit = {
	lookType = 46,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2950
monster.maxHealth = 2950
monster.race = "blood"
monster.corpse = 6065
monster.speed = 260
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 40,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Massive Water Elemental", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Gaaahhh!", yell = false },
	{ text = "Boohaa!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 10 }, -- platinum coin
	{ id = 3033, chance = 80000, maxCount = 4 }, -- small amethyst
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 901, chance = 80000 }, -- marlin
	{ id = 7383, chance = 80000 }, -- relic sword
	{ id = 3073, chance = 1000 }, -- wand of cosmic energy
	{ id = 3381, chance = 1000 }, -- crown armor
	{ id = 3391, chance = 1000 }, -- crusader helmet
	{ id = 5741, chance = 1000 }, -- skull helmet
	{ id = 5895, chance = 80000 }, -- fish fin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -285 },
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_ICEDAMAGE, minDamage = -108, maxDamage = -137, radius = 4, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -170, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "poisonfield", interval = 2000, chance = 19, radius = 3, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "speed", interval = 2000, chance = 18, speedChange = -360, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.46,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 25, maxDamage = 75, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
