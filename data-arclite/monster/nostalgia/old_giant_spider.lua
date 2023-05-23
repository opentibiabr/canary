local mType = Game.createMonsterType("Old Giant Spider")
local monster = {}

monster.name = "Giant Spider"
monster.description = "a giant spider"
monster.experience = 900
monster.outfit = {
	lookType = 910,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "venom"
monster.corpse = 5977
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 70,
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
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 85}, -- gold coin
	{id = 3448, chance = 11900, maxCount = 11}, -- poison arrow
	{id = 3557, chance = 7933}, -- plate legs
	{id = 3357, chance = 10010}, -- plate armor
	{id = 3351, chance = 4945}, -- steel helmet
	{id = 236, chance = 3571}, -- strong health potion
	{id = 3371, chance = 850}, -- knight legs
	{id = 3055, chance = 280}, -- platinum amulet
	{id = 3370, chance = 500} -- knight armor
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = {type = CONDITION_POISON, totalDamage = 160, interval = 4000}},
	{name ="poisonfield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -70, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="speed", interval = 2000, chance = 15, speedChange = 390, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
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
