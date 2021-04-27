local mType = Game.createMonsterType("The Imperor")
local monster = {}

monster.description = "The Imperor"
monster.experience = 8000
monster.outfit = {
	lookType = 237,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "blood"
monster.corpse = 6364
monster.speed = 310
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
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
	targetDistance = 4,
	runHealth = 1500,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Poke! Poke! <chuckle>", yell = false},
	{text = "Let me tickle you with my trident!", yell = false}
}

monster.loot = {
	{id = 6500, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 150},
	{id = 6534, chance = 100000},
	{id = 2548, chance = 53850},
	{id = 2432, chance = 11000},
	{id = 2152, chance = 46150, maxCount = 3},
	{id = 5944, chance = 100000},
	{id = 2488, chance = 30770},
	{id = 2470, chance = 7690},
	{id = 2136, chance = 15380},
	{id = 2542, chance = 7690},
	{id = 2515, chance = 15400},
	{id = 7899, chance = 15380},
	{id = 2150, chance = 30770, maxCount = 4},
	{id = 2147, chance = 7690, maxCount = 4}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 90, attack = 100, condition = {type = CONDITION_POISON, totalDamage = 280, interval = 4000}},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -350, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 2500, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -460, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true},
	{name ="diabolic imp skill reducer", interval = 2000, chance = 10, range = 7, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 275, maxDamage = 840, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="the imperor summon", interval = 2000, chance = 21, target = false},
	{name ="speed", interval = 2000, chance = 12, speedChange = 1496, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="invisible", interval = 2000, chance = 11, effect = CONST_ME_TELEPORT}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
