local mType = Game.createMonsterType("Memory Of A Scarab")
local monster = {}

monster.description = "a memory of a scarab"
monster.experience = 1590
monster.outfit = {
	lookType = 79,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3620
monster.maxHealth = 3620
monster.race = "venom"
monster.corpse = 6021
monster.speed = 109
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
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
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{name = "Larva", chance = 10, interval = 2000, count = 3}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "scarab amulet", chance = 3410},
	{name = "gold coin", chance = 50000, maxCount = 155},
	{name = "small emerald", chance = 4810, maxCount = 3},
	{name = "small amethyst", chance = 5000, maxCount = 4},
	{name = "scarab coin", chance = 7692, maxCount = 2},
	{id = 3046, chance = 11480}, -- magic light wand
	{name = "plate armor", chance = 10300},
	{name = "special fx box", chance = 1500},
	{name = "strong health potion", chance = 660}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130, condition = {type = CONDITION_POISON, totalDamage = 56, interval = 4000}},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -15, maxDamage = -145, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -700, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false, duration = 25000},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 30, minDamage = -70, maxDamage = -150, radius = 5, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="speed", interval = 2000, chance = 15, speedChange = 380, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
