local mType = Game.createMonsterType("Deadeye Devious")
local monster = {}

monster.description = "Deadeye Devious"
monster.experience = 750
monster.outfit = {
	lookType = 151,
	lookHead = 115,
	lookBody = 76,
	lookLegs = 35,
	lookFeet = 117,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 1450
monster.maxHealth = 1450
monster.race = "blood"
monster.corpse = 20378
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
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
	staticAttackChance = 50,
	targetDistance = 3,
	runHealth = 150,
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
	{text = "Let's kill 'em", yell = false},
	{text = "Arrrgh!", yell = false},
	{text = "You'll never take me alive!", yell = false},
	{text = "You won't get me alive!", yell = false},
	{text = "§%§&§! #*$§$!!", yell = false}
}

monster.loot = {
	{id = 6102, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 140},
	{id = 2229, chance = 85000, maxCount = 2},
	{id = 2463, chance = 78000},
	{id = 2666, chance = 42000, maxCount = 3},
	{id = 2476, chance = 28000},
	{id = 2379, chance = 21000},
	{id = 2145, chance = 14000},
	{id = 2387, chance = 7000},
	{id = 5926, chance = 7000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150},
	{name ="combat", interval = 4000, chance = 60, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -350, shootEffect = CONST_ANI_THROWINGKNIFE, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
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
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
