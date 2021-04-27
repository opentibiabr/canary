local mType = Game.createMonsterType("Dipthrah")
local monster = {}

monster.description = "Dipthrah"
monster.experience = 2900
monster.outfit = {
	lookType = 87,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 6031
monster.speed = 320
monster.manaCost = 0
monster.maxSummons = 4

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Priestess", chance = 15, interval = 2000, max = 3}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You can't escape death forever", yell = false},
	{text = "Come closer to learn the final lesson", yell = false},
	{text = "Undeath will shatter my shackles.", yell = false},
	{text = "You don't need this magic anymore.", yell = false}
}

monster.loot = {
	{name = "small sapphire", chance = 7000, maxCount = 3},
	{name = "gold coin", chance = 50000, maxCount = 80},
	{name = "gold coin", chance = 50000, maxCount = 80},
	{name = "blue gem", chance = 1500},
	{name = "energy ring", chance = 7000},
	{name = "mind stone", chance = 1500},
	{name = "ankh", chance = 500},
	{name = "ornamented ankh", chance = 100000},
	{name = "skull staff", chance = 500},
	{name = "pharaoh sword", chance = 300},
	{name = "great mana potion", chance = 7000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200, condition = {type = CONDITION_POISON, totalDamage = 65, interval = 4000}},
	{name ="combat", interval = 4000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -800, range = 1, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -500, range = 7, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="speed", interval = 1000, chance = 15, speedChange = -650, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000},
	{name ="drunk", interval = 1000, chance = 12, radius = 7, effect = CONST_ME_LOSEENERGY, target = false},
	{name ="melee", interval = 3000, chance = 34, minDamage = -50, maxDamage = -600}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
