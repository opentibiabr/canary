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
monster.corpse = 18293
monster.speed = 180
monster.manaCost = 0

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
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 6,
	summons = {
		{name = "Ghoul", chance = 20, interval = 1000, count = 2},
		{name = "Ghost", chance = 17, interval = 1000, count = 2},
		{name = "Mummy", chance = 15, interval = 1000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You will rise as my servant!", yell = false},
	{text = "Praise to my master Urgith!", yell = false}
}

monster.loot = {
	{id = 10320, chance = 100000}, -- book of necromantic rituals
	{id = 3031, chance = 100000, maxCount = 99}, -- gold coin
	{id = 11475, chance = 100000}, -- necromantic robe
	{id = 5809, chance = 100000}, -- soul stone
	{id = 3311, chance = 52000}, -- clerical mace
	{id = 3324, chance = 47000}, -- skull staff
	{id = 3337, chance = 38000}, -- bone club
	{id = 3114, chance = 19000}, -- skull
	{id = 3732, chance = 14000}, -- green mushroom
	{id = 3070, chance = 14000}, -- moonlight rod
	{id = 3116, chance = 9500}, -- big bone
	{id = 3441, chance = 9500}, -- bone shield
	{id = 3079, chance = 4700}, -- boots of haste
	{id = 3574, chance = 4700}, -- mystic turban
	{id = 237, chance = 4700} -- strong mana potion
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
