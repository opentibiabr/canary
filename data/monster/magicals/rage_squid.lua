local mType = Game.createMonsterType("Rage Squid")
local monster = {}

monster.description = "a rage squid"
monster.experience = 14820
monster.outfit = {
	lookType = 1059,
	lookHead = 94,
	lookBody = 78,
	lookLegs = 78,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1668
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library."
	}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "undead"
monster.corpse = 32482
monster.speed = 430
monster.manaCost = 0
monster.maxSummons = 0

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
}

monster.loot = {
	{id = 33317, chance = 10000},
	{name = "great spirit potion", chance = 10000, maxCount = 3},
	{name = "fire mushroom", chance = 10000, maxCount = 6},
	{name = "small amethyst", chance = 90000, maxCount = 5},
	{name = "slime heart", chance = 3000},
	{name = "piece of dead brain", chance = 4900},
	{name = "platinum coin", chance = 100000, maxCount = 6},
	{name = "ultimate health potion", chance = 10000, maxCount = 3},
	{name = "small topaz", chance = 90000, maxCount = 5},
	{name = "small emerald", chance = 90000, maxCount = 5},
	{name = "red gem", chance = 9800, maxCount = 5},
	{name = "orb", chance = 66000, maxCount = 5},
	{name = "purple tome", chance = 6333},
	{name = "great mana potion", chance = 10000, maxCount = 3},
	{name = "demonic essence", chance = 4300},
	{id = 33315, chance = 10000},
	{name = "small ruby", chance = 90000, maxCount = 5},
	{name = "talon", chance = 8990},
	{name = "might ring", chance = 4990},
	{name = "devil helmet", chance = 6990},
	{name = "demonrage sword", chance = 400},
	{id = 7393, chance = 390},
	{name = "giant sword", chance = 250},
	{name = "demon shield", chance = 250},
	{name = "magic plate armor", chance = 150},
	{name = "platinum amulet", chance = 350},
	{name = "wand of everblazing", chance = 300},
	{name = "fire axe", chance = 500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -280, range = 7, shootEffect = CONST_ANI_FLAMMINGARROW, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -380, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -175, maxDamage = -200, length = 5, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -475, radius = 3, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -475, radius = 2, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 78,
	armor = 78
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
