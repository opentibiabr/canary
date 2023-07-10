local mType = Game.createMonsterType("Sin Devourer")
local monster = {}

monster.description = "a sin devourer"
monster.experience = 500
monster.outfit = {
	lookType = 320,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "undead"
monster.corpse = 0
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 10,
	chance = 8
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{id = 3740, chance = 4830}, -- shadow herb
	{id = 3084, chance = 850}, -- protection amulet
	{id = 3055, chance = 120}, -- platinum amulet
	{id = 3079, chance = 120}, -- boots of haste
	{id = 237, chance = 1600}, -- strong mana potion
	{id = 3031, chance = 89840, maxCount = 110}, -- gold coin
	{id = 7407, chance = 320}, -- haunted blade
	{id = 7427, chance = 120}, -- chaos mace
	{id = 9028, chance = 130}, -- crystal of balance
	{id = 3007, chance = 1030}, -- crystal ring
	{id = 8042, chance = 520} -- spirit cloak
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 30, condition = {type = CONDITION_POISON, totalDamage = 80, interval = 4000}},
	{name ="nightstalker paralyze", interval = 2000, chance = 19, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -360, maxDamage = -470, range = 1, effect = CONST_ME_HOLYAREA, target = true},
	{name ="speed", interval = 2000, chance = 40, speedChange = -600, range = 6, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEAREA, target = true, duration = 20000},
	{name ="silencer skill reducer", interval = 2000, chance = 30, range = 4, effect = CONST_ME_POFF, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 30,
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_HEALING, minDamage = 60, maxDamage = 130, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 10, effect = CONST_ME_YELLOW_RINGS}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = 40},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 40},
	{type = COMBAT_HOLYDAMAGE , percent = 40},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
