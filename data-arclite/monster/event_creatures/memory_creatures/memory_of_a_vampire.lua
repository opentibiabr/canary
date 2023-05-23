local mType = Game.createMonsterType("Memory Of A Vampire")
local monster = {}

monster.description = "a memory of a vampire"
monster.experience = 1550
monster.outfit = {
	lookType = 68,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3650
monster.maxHealth = 3650
monster.race = "blood"
monster.corpse = 6006
monster.speed = 119
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 30,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "BLOOD!", yell = true},
	{text = "Let me kiss your neck", yell = false},
	{text = "I smell warm blood!", yell = false},
	{text = "I call you, my bats! Come!", yell = false}
}

monster.loot = {
	{name = "emerald bangle", chance = 230},
	{name = "black pearl", chance = 1800},
	{name = "gold coin", chance = 90230, maxCount = 60},
	{name = "bronze amulet", chance = 220},
	{name = "spike sword", chance = 1000},
	{name = "ice rapier", chance = 420},
	{name = "katana", chance = 1560},
	{name = "strange helmet", chance = 420},
	{name = "vampire shield", chance = 230},
	{name = "grave flower", chance = 1910},
	{name = "special fx box", chance = 1500},
	{name = "strong health potion", chance = 1500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -100, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="speed", interval = 2000, chance = 15, speedChange = -400, range = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 60000}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="outfit", interval = 4000, chance = 10, effect = CONST_ME_GROUNDSHAKER, target = false, duration = 5000, outfitMonster = "bat"},
	{name ="speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 15, maxDamage = 25, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 35},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
