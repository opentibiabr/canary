local mType = Game.createMonsterType("Vashresamun")
local monster = {}

monster.description = "Vashresamun"
monster.experience = 2950
monster.outfit = {
	lookType = 90,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "undead"
monster.corpse = 6025
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	{name = "Banshee", chance = 20, interval = 2000, max = 2}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Come my maidens, we have visitors!", yell = false},
	{text = "Are you enjoying my music?", yell = false},
	{text = "If music is the food of death, drop dead.", yell = false},
	{text = "Chakka Chakka!", yell = false},
	{text = "Heheheheee!", yell = false}
}

monster.loot = {
	{id = 2072, chance = 7000},
	{id = 2074, chance = 1500},
	{id = 2124, chance = 1500},
	{name = "ancient tiara", chance = 300},
	{name = "white pearl", chance = 7000},
	{name = "gold coin", chance = 50000, maxCount = 90},
	{name = "gold coin", chance = 50000, maxCount = 80},
	{name = "gold coin", chance = 50000, maxCount = 65},
	{name = "blue note", chance = 100000},
	{name = "crystal mace", chance = 500},
	{name = "blue robe", chance = 2500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200, condition = {type = CONDITION_POISON, totalDamage = 65, interval = 4000}},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -750, radius = 5, effect = CONST_ME_SOUND_PURPLE, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 20,
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 60, maxDamage = 450, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 12, speedChange = 350, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 30000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
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
