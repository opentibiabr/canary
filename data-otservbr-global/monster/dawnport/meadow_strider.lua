local mType = Game.createMonsterType("Meadow Strider")
local monster = {}

monster.description = "a meadow strider"
monster.experience = 50
monster.outfit = {
	lookType = 530,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 21450
monster.speed = 68
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	runHealth = 10,
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
	{id = 3003, chance = 4530}, -- rope
	{id = 3031, chance = 100000, maxCount = 10}, -- gold coin
	{id = 3492, chance = 14280, maxCount = 2}, -- worm
	{id = 3578, chance = 25180, maxCount = 2}, -- fish
	{id = 3577, chance = 25250}, -- meat
	{id = 17461, chance = 6060}, -- marsh stalker beak
	{id = 647, chance = 160}, -- seeds
	{id = 17462, chance = 8980}, -- marsh stalker feather
	{id = 3285, chance = 7640}, -- longsword
	{id = 3286, chance = 8310}, -- mace
	{id = 3276, chance = 6660} -- hatchet
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 13},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -10, range = 7, shootEffect = CONST_ANI_SMALLSTONE, effect = CONST_ME_EXPLOSIONAREA, target = false}
}

monster.defenses = {
	defense = 2,
	armor = 1,
	{name ="speed", interval = 2000, chance = 13, speedChange = 192, effect = CONST_ME_HITAREA, target = false, duration = 5000}
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
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
