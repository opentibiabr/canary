local mType = Game.createMonsterType("The Horned Fox")
local monster = {}

monster.description = "the Horned Fox"
monster.experience = 300
monster.outfit = {
	lookType = 202,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 265
monster.maxHealth = 265
monster.race = "blood"
monster.corpse = 5983
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 20,
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

monster.summon = {
	maxSummons = 6,
	summons = {
		{name = "Minotaur Archer", chance = 13, interval = 1000, count = 2},
		{name = "Minotaur Guard", chance = 13, interval = 1000, count = 2},
		{name = "Minotaur Mage", chance = 13, interval = 1000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You will never get me!", yell = false},
	{text = "I'll be back!", yell = false},
	{text = "Catch me, if you can!", yell = false},
	{text = "Help me, Boys!", yell = false}
}

monster.loot = {
	{id = 5804, chance = 100000}, -- nose ring
	{id = 3031, chance = 96000, maxCount = 99}, -- gold coin
	{id = 5878, chance = 96000}, -- minotaur leather
	{id = 11472, chance = 92590, maxCount = 2}, -- minotaur horn
	{id = 11482, chance = 85000}, -- piece of warrior armor
	{id = 7363, chance = 48000, maxCount = 14}, -- piercing bolt
	{id = 3359, chance = 25000}, -- brass armor
	{id = 3577, chance = 18000, maxCount = 2}, -- meat
	{id = 3413, chance = 14000}, -- battle shield
	{id = 3396, chance = 5000}, -- dwarven helmet
	{id = 3483, chance = 7410}, -- fishing rod
	{id = 236, chance = 7410}, -- strong health potion
	{id = 3275, chance = 3700} -- double axe
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -20, range = 7, shootEffect = CONST_ANI_BOLT, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 1000, chance = 17, range = 7, shootEffect = CONST_ANI_POISON, target = false}
}

monster.defenses = {
	defense = 16,
	armor = 17,
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 25, maxDamage = 75, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="invisible", interval = 1000, chance = 10, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
