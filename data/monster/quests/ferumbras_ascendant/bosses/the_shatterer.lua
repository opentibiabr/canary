local mType = Game.createMonsterType("The Shatterer")
local monster = {}

monster.description = "The Shatterer"
monster.experience = 58000
monster.outfit = {
	lookType = 842,
	lookHead = 77,
	lookBody = 113,
	lookLegs = 21,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 220000
monster.maxHealth = 220000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 320
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 2500,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "STOMP! SHAKE! SHATTERER!!", yell = false}
}

monster.loot = {
	{id = 7590, chance = 23000, maxCount = 10},
	{id = 8472, chance = 46100, maxCount = 10},
	{id = 8473, chance = 46100, maxCount = 10},
	{id = 2147, chance = 12000, maxCount = 12},
	{id = 2152, chance = 8000, maxCount = 10},
	{id = 2148, chance = 30000, maxCount = 200}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -3000},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -200, maxDamage = -1000, range = 7, target = false},
	{name ="combat", interval = 3000, chance = 44, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -2000, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -400, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -800, range = 7, radius = 7, effect = CONST_ME_BIGPLANTS, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 6000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
