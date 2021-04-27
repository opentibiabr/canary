local mType = Game.createMonsterType("Minishabaal")
local monster = {}

monster.description = "Minishabaal"
monster.experience = 4000
monster.outfit = {
	lookType = 237,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 6364
monster.speed = 700
monster.manaCost = 0
monster.maxSummons = 3

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
	targetDistance = 4,
	runHealth = 350,
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
	{name = "Diabolic Imp", chance = 40, interval = 2000, max = 3}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I had Princess Lumelia as breakfast!", yell = false},
	{text = "Naaa-Nana-Naaa-Naaa!", yell = false},
	{text = "My brother will come and get you for this!", yell = false},
	{text = "Get them Fluffy!", yell = false},
	{text = "He He He!", yell = false},
	{text = "Pftt, Ferumbras such an upstart!", yell = false},
	{text = "My dragon is not that old, it's just second hand!", yell = false},
	{text = "My other dragon is a red one!", yell = false},
	{text = "When I am big I want to become the ruthless eighth!", yell = false},
	{text = "WHERE'S FLUFFY?", yell = false},
	{text = "Muahaha!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 20},
	{id = 2150, chance = 1428, maxCount = 2},
	{id = 2548, chance = 2857},
	{id = 2432, chance = 666},
	{id = 5944, chance = 909},
	{id = 2520, chance = 200},
	{id = 6500, chance = 1000, maxCount = 2},
	{id = 2470, chance = 180},
	{id = 2148, chance = 100000, maxCount = 20},
	{id = 5944, chance = 909},
	{id = 2488, chance = 800},
	{id = 2515, chance = 1333},
	{id = 2136, chance = 909},
	{id = 2542, chance = 500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 95},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -350, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 3000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -120, maxDamage = -500, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 1000, chance = 50, type = COMBAT_HEALING, minDamage = 155, maxDamage = 255, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 12, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000},
	{name ="invisible", interval = 4000, chance = 50, effect = CONST_ME_MAGIC_RED}
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
