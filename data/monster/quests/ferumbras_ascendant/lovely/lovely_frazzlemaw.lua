local mType = Game.createMonsterType("Lovely Frazzlemaw")
local monster = {}

monster.description = "a lovely frazzlemaw"
monster.experience = 3400
monster.outfit = {
	lookType = 594,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 22567
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
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
	{text = "Mwaaaahnducate youuuuuu *gurgle*, mwaaah!", yell = false},
	{text = "Mmmwahmwahmwahah, mwaaah!", yell = false},
	{text = "MMMWAHMWAHMWAHMWAAAAH!", yell = true}
}

monster.loot = {
	{id = 22396, chance = 490},
	{id = 22532, chance = 18560},
	{id = 2148, chance = 100000, maxCount = 100},
	{id = 7591, chance = 14490, maxCount = 2},
	{id = 7590, chance = 14810, maxCount = 3},
	{id = 2152, chance = 100000, maxCount = 7},
	{id = 2219, chance = 9920},
	{id = 2225, chance = 10210},
	{id = 2226, chance = 10040},
	{id = 2229, chance = 12380},
	{id = 2230, chance = 9510},
	{id = 2231, chance = 5360},
	{id = 2667, chance = 6780, maxCount = 3},
	{id = 2671, chance = 5960, maxCount = 2},
	{id = 5880, chance = 3000},
	{id = 5895, chance = 4650},
	{id = 5925, chance = 5190},
	{id = 5951, chance = 10670},
	{id = 7404, chance = 990},
	{id = 7407, chance = 2110},
	{id = 2377, chance = 3170},
	{id = 7418, chance = 1030},
	{id = 9971, chance = 2330},
	{id = 11306, chance = 1600},
	{id = 18414, chance = 3000},
	{id = 18417, chance = 15640},
	{id = 18420, chance = 5230},
	{id = 18554, chance = 9640},
	{id = 22533, chance = 15990},
	{id = 2240, chance = 9430}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 90, attack = 80},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -400, radius = 3, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -700, length = 5, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = true},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 16, minDamage = -400, maxDamage = -600, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true},
	{name ="frazzlemaw paralyze", interval = 2000, chance = 15, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
