local mType = Game.createMonsterType("Angry Demon")
local monster = {}

monster.description = "an angry demon"
monster.experience = 6000
monster.outfit = {
	lookType = 35,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "fire"
monster.corpse = 5995
monster.speed = 256
monster.manaCost = 0
monster.maxSummons = 1

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	staticAttackChance = 70,
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
	{name = "fire elemental", chance = 10, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Your soul will be mine!", yell = false},
	{text = "MUHAHAHA", yell = false},
	{text = "CHAMEK ATH UTHUL ARAK!", yell = false},
	{text = "I SMELL FEEEEAAAAAR!", yell = false},
	{text = "Your resistance is futile!", yell = false}
}

monster.loot = {
	{name = "purple tome", chance = 1180},
	{name = "gold coin", chance = 60000, maxCount = 100},
	{name = "platinum coin", chance = 60000, maxCount = 6},
	{name = "small emerald", chance = 9690, maxCount = 5},
	{name = "small amethyst", chance = 7250, maxCount = 5},
	{name = "small ruby", chance = 7430, maxCount = 5},
	{name = "small topaz", chance = 7470, maxCount = 5},
	{name = "red gem", chance = 2220},
	{name = "demonic essence", chance = 14630},
	{name = "talon", chance = 3430},
	{name = "might ring", chance = 1890},
	{name = "stealth ring", chance = 2170},
	{name = "platinum amulet", chance = 680},
	{name = "orb", chance = 2854},
	{name = "gold ring", chance = 1050},
	{name = "ring of healing", chance = 1990},
	{name = "giant sword", chance = 1980},
	{name = "ice rapier", chance = 1550},
	{name = "golden sickle", chance = 1440},
	{name = "fire axe", chance = 4030},
	{name = "devil helmet", chance = 1180},
	{name = "golden legs", chance = 440},
	{name = "magic plate armor", chance = 130},
	{name = "mastermind shield", chance = 480},
	{name = "demon shield", chance = 740},
	{name = "fire mushroom", chance = 19660, maxCount = 6},
	{name = "demon horn", chance = 14920},
	{name = "assassin star", chance = 12550, maxCount = 10},
	{name = "demonrage sword", chance = 70},
	{id = 7393, chance = 90},
	{name = "great mana potion", chance = 22220, maxCount = 3},
	{name = "ultimate health potion", chance = 19540, maxCount = 3},
	{name = "great spirit potion", chance = 18510, maxCount = 3}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -490, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -300, range = 1, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -25},
	{type = COMBAT_ENERGYDAMAGE, percent = -50},
	{type = COMBAT_EARTHDAMAGE, percent = -40},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 12},
	{type = COMBAT_HOLYDAMAGE , percent = 12},
	{type = COMBAT_DEATHDAMAGE , percent = -20}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
