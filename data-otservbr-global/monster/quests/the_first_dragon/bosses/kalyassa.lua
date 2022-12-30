local mType = Game.createMonsterType("Kalyassa")
local monster = {}

monster.description = "kalyassa"
monster.experience = 9000
monster.outfit = {
	lookType = 947,
	lookHead = 56,
	lookBody = 113,
	lookLegs = 19,
	lookFeet = 95,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 5984
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	targetDistance = 1,
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{name = "Dragon Lord", chance = 20, interval = 2000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 24941, chance = 100000}, -- horn of kalyassa
	{id = 3583, chance = 75230, maxCount = 9}, -- dragon ham
	{id = 3035, chance = 99080, maxCount = 9}, -- platinum coin
	{id = 24937, chance = 80000, maxCount = 2}, -- dragon blood
	{id = 239, chance = 8260}, -- great health potion
	{id = 238, chance = 9170}, -- great mana potion
	{id = 3392, chance = 25000}, -- royal helmet
	{id = 3386, chance = 25000}, -- dragon scale mail
	{id = 24938, chance = 100000}, -- dragon tongue
	{id = 3450, chance = 17430}, -- power bolt
	{id = 7365, chance = 26610, maxCount = 10}, -- onyx arrow
	{id = 3280, chance = 25000}, -- fire sword
	{id = 3051, chance = 25000}, -- energy ring
	{id = 5948, chance = 25000} -- red dragon leather
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 112, attack = 85},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, radius = 5, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -310, maxDamage = -495, length = 9, spread = 4, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, target = true}
}

monster.defenses = {
	defense = 70,
	armor = 45,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 400, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
