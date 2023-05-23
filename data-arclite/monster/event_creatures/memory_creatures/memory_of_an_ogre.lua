local mType = Game.createMonsterType("Memory Of An Ogre")
local monster = {}

monster.description = "a memory of an ogre"
monster.experience = 1680
monster.outfit = {
	lookType = 857,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3570
monster.maxHealth = 3570
monster.race = "blood"
monster.corpse = 22143
monster.speed = 102
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You so juicy!", yell = false},
	{text = "You stop! You lunch!", yell = false},
	{text = "Smash you face in!!!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 121},
	{name = "strong health potion", chance = 18830, maxCount = 2},
	{name = "onyx chip", chance = 9800},
	{id = 3050, chance = 5070}, -- power ring
	{name = "small ruby", chance = 7430, maxCount = 2},
	{id = 3093, chance = 810}, -- club ring
	{name = "small stone", chance = 13890, maxCount = 3},
	{id = 37531, chance = 5155}, -- candy floss
	{name = "white pearl", chance = 530},
	{name = "opal", chance = 5155},
	{name = "bonebreaker", chance = 400},
	{name = "bottle of champagne", chance = 600}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110, condition = {type = CONDITION_FIRE, totalDamage = 6, interval = 9000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -100, range = 7, shootEffect = CONST_ANI_POISON, target = false},
	{name ="drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_TELEPORT, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
