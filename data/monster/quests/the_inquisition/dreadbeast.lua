local mType = Game.createMonsterType("Dreadbeast")
local monster = {}

monster.description = "a dreadbeast"
monster.experience = 250
monster.outfit = {
	lookType = 101,
	lookHead = 20,
	lookBody = 30,
	lookLegs = 40,
	lookFeet = 50,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 800
monster.maxHealth = 800
monster.race = "undead"
monster.corpse = 3031
monster.speed = 136
monster.manaCost = 800
monster.maxSummons = 0

monster.changeTarget = {
	interval = 60000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "gold coin", chance = 11690, maxCount = 88},
	{id = 2230, chance = 8230},
	{name = "plate armor", chance = 2810},
	{id = 2229, chance = 2810},
	{id = 2231, chance = 1950},
	{name = "bone club", chance = 1520},
	{name = "bone shield", chance = 1520},
	{name = "health potion", chance = 870},
	{name = "green mushroom", chance = 650},
	{name = "hardened bone", chance = 650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="dreadbeast skill reducer", interval = 3000, chance = 15, range = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_YELLOWENERGY, target = true},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -70, maxDamage = -90, range = 1, shootEffect = CONST_ANI_ICE, effect = CONST_ME_LOSEENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -250, radius = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_PURPLEENERGY, target = true}
}

monster.defenses = {
	defense = 36,
	armor = 34,
	{name ="combat", interval = 5000, chance = 20, type = COMBAT_HEALING, minDamage = 35, maxDamage = 65, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 55},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 75},
	{type = COMBAT_ICEDAMAGE, percent = 40},
	{type = COMBAT_HOLYDAMAGE , percent = -50},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
