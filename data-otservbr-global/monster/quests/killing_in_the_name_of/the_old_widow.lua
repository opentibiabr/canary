local mType = Game.createMonsterType("The Old Widow")
local monster = {}

monster.description = "The Old Widow"
monster.experience = 4200
monster.outfit = {
	lookType = 208,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3200
monster.maxHealth = 3200
monster.race = "blood"
monster.corpse = 5977
monster.speed = 219
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	maxSummons = 2,
	summons = {
		{name = "giant spider", chance = 13, interval = 1000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 99}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 10}, -- platinum coin
	{id = 5879, chance = 100000}, -- spider silk
	{id = 3351, chance = 100000}, -- steel helmet
	{id = 239, chance = 100000, maxCount = 4}, -- great health potion
	{id = 3370, chance = 50000}, -- knight armor
	{id = 3049, chance = 33333}, -- stealth ring
	{id = 3051, chance = 33333}, -- energy ring
	{id = 3053, chance = 33333}, -- time ring
	{id = 12320, chance = 33333}, -- sweet smelling bait
	{id = 3371, chance = 25000}, -- knight legs
	{id = 3055, chance = 25000}, -- platinum amulet
	{id = 5886, chance = 25000}, -- spool of yarn
	{id = 7416, chance = 3225}, -- bloody edge
	{id = 7419, chance = 1639} -- dreaded cleaver
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false},
	{name ="speed", interval = 1000, chance = 20, speedChange = -850, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false, duration = 25000},
	{name ="poisonfield", interval = 1000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, target = true}
}

monster.defenses = {
	defense = 21,
	armor = 17,
	{name ="combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 225, maxDamage = 275, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 8, speedChange = 345, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
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
