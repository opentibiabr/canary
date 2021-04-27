local mType = Game.createMonsterType("Boogey")
local monster = {}

monster.description = "Boogey"
monster.experience = 475
monster.outfit = {
	lookType = 300,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 930
monster.maxHealth = 930
monster.race = "undead"
monster.corpse = 8955
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 5000,
	chance = 10
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
	{name = "Demon Skeleton", chance = 40, interval = 4000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Since you didn't eat your spinach Bogey comes to get you!", yell = true},
	{text = "Too bad you did not eat your lunch, now I have to punish you!", yell = true},
	{text = "Even if you beat me, I'll hide in your closet until you one day drop your guard!", yell = true},
	{text = "You better had believe in me!", yell = true},
	{text = "I'll take you into the darkness ... forever!", yell = true}
}

monster.loot = {
	{id = 10296, chance = 1000},
	{id = 10302, chance = 1000},
	{id = 10301, chance = 1000},
	{id = 10295, chance = 1000}
}

monster.attacks = {
	{name ="melee", interval = 1200, chance = 100, minDamage = 0, maxDamage = -120},
	{name ="combat", interval = 1500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -30, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 1500, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -12, maxDamage = -20, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 1500, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -20, maxDamage = -30, effect = CONST_ME_MORTAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 80, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 25},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
