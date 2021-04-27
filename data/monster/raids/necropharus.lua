local mType = Game.createMonsterType("Necropharus")
local monster = {}

monster.description = "Necropharus"
monster.experience = 1050
monster.outfit = {
	lookType = 209,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 750
monster.maxHealth = 750
monster.race = "blood"
monster.corpse = 20574
monster.speed = 240
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 100,
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
	{name = "Ghoul", chance = 20, interval = 1000},
	{name = "Ghost", chance = 17, interval = 1000},
	{name = "Mummy", chance = 15, interval = 1000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You will rise as my servant!", yell = false},
	{text = "Praise to my master Urgith!", yell = false}
}

monster.loot = {
	{id = 11237, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 99},
	{id = 12431, chance = 100000},
	{id = 5809, chance = 100000},
	{id = 2423, chance = 52000},
	{id = 2436, chance = 47000},
	{id = 2449, chance = 38000},
	{id = 2229, chance = 19000},
	{id = 2796, chance = 14000},
	{id = 2186, chance = 14000},
	{id = 2231, chance = 9500},
	{id = 2541, chance = 9500},
	{id = 2195, chance = 4700},
	{id = 2663, chance = 4700},
	{id = 7589, chance = 4700}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -80, condition = {type = CONDITION_POISON, totalDamage = 8, interval = 4000}},
	{name ="combat", interval = 3000, chance = 70, type = COMBAT_PHYSICALDAMAGE, minDamage = -60, maxDamage = -217, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -120, range = 1, target = false},
	{name ="combat", interval = 1000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -140, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 1000, chance = 17, type = COMBAT_ENERGYDAMAGE, minDamage = -50, maxDamage = -140, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 0, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
