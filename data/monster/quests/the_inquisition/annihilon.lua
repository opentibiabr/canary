local mType = Game.createMonsterType("Annihilon")
local monster = {}

monster.description = "Annihilon"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 19,
	lookBody = 104,
	lookLegs = 96,
	lookFeet = 96,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 46500
monster.maxHealth = 46500
monster.race = "fire"
monster.corpse = 6068
monster.speed = 132
monster.manaCost = 0
monster.maxSummons = 0

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
	staticAttackChance = 85,
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
	{text = "Flee as long as you can!", yell = false},
	{text = "Annihilon's might will crush you all!", yell = false},
	{text = "I am coming for you!", yell = false}
}

monster.loot = {
	{name = "emerald bangle", chance = 20000},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "platinum coin", chance = 16666, maxCount = 30},
	{name = "violet gem", chance = 16666},
	{name = "yellow gem", chance = 20000},
	{name = "green gem", chance = 12500},
	{name = "red gem", chance = 20000},
	{name = "blue gem", chance = 20000},
	{name = "halberd", chance = 20000},
	{name = "guardian halberd", chance = 20000},
	{name = "heavy mace", chance = 25000},
	{name = "mastermind shield", chance = 4166},
	{name = "guardian shield", chance = 7692},
	{name = "crown shield", chance = 11111},
	{name = "demon shield", chance = 4166},
	{name = "tower shield", chance = 9090},
	{name = "power bolt", chance = 16666, maxCount = 94},
	{name = "soul orb", chance = 20000, maxCount = 5},
	{name = "demon horn", chance = 12500, maxCount = 2},
	{name = "infernal bolt", chance = 20000, maxCount = 46},
	{name = "viper star", chance = 16666, maxCount = 70},
	{name = "assassin star", chance = 16666, maxCount = 50},
	{name = "diamond sceptre", chance = 7142},
	{name = "onyx flail", chance = 14285},
	{name = "demonbone", chance = 1234},
	{name = "berserk potion", chance = 16666},
	{name = "mastermind potion", chance = 14285},
	{name = "great mana potion", chance = 11111},
	{name = "great health potion", chance = 14285},
	{id = 7632, chance = 33333, maxCount = 2},
	{name = "flaming arrow", chance = 20000, maxCount = 46},
	{name = "great spirit potion", chance = 14285},
	{name = "ultimate health potion", chance = 14285},
	{name = "lavos armor", chance = 1851},
	{name = "paladin armor", chance = 10000},
	{name = "obsidian truncheon", chance = 1234},
	{id = 9808, chance = 1234},
	{id = 9810, chance = 50000},
	{name = "gold ingot", chance = 20000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1707},
	{name ="combat", interval = 1000, chance = 11, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -700, radius = 4, effect = CONST_ME_ICEAREA, target = false},
	{name ="combat", interval = 3000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -255, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -600, radius = 6, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true}
}

monster.defenses = {
	defense = 55,
	armor = 60,
	{name ="combat", interval = 1000, chance = 14, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="speed", interval = 1000, chance = 4, speedChange = 500, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 96},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 95}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
