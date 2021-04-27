local mType = Game.createMonsterType("Disgusting Ooze")
local monster = {}

monster.description = "a disgusting ooze"
monster.experience = 3700
monster.outfit = {
	lookType = 238,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3650
monster.maxHealth = 3650
monster.race = "venom"
monster.corpse = 6532
monster.speed = 260
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 85,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.events = {
	"DisgustingOozeDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Blubb", yell = false},
	{text = "Blubb Blubb", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 272},
	{id = 2152, chance = 95660, maxCount = 6},
	{id = 6500, chance = 20340},
	{id = 5944, chance = 20130},
	{id = 9967, chance = 14190},
	{id = 9968, chance = 11550},
	{id = 2151, chance = 5930},
	{id = 2149, chance = 5400, maxCount = 3},
	{id = 2147, chance = 2750, maxCount = 2},
	{id = 2145, chance = 2650, maxCount = 2},
	{id = 6300, chance = 2440},
	{id = 2156, chance = 1590},
	{id = 2154, chance = 1380},
	{id = 2155, chance = 640},
	{id = 2158, chance = 320}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 80, condition = {type = CONDITION_POISON, totalDamage = 300, interval = 4000}},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_LIFEDRAIN, minDamage = -160, maxDamage = -295, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="defiler paralyze 3", interval = 2000, chance = 9, target = false},
	{name ="defiler paralyze 1", interval = 2000, chance = 6, target = false},
	{name ="defiler paralyze 2", interval = 2000, chance = 8, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -300, maxDamage = -500, radius = 8, effect = CONST_ME_HITBYPOISON, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -400, maxDamage = -725, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -170, radius = 3, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 450, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -25},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
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
