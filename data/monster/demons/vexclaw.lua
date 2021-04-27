local mType = Game.createMonsterType("Vexclaw")
local monster = {}

monster.description = "a vexclaw"
monster.experience = 6248
monster.outfit = {
	lookType = 854,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1197
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Dungeons of The Ruthless Seven."
	}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "fire"
monster.corpse = 25432
monster.speed = 270
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "Weakness must be culled!", yell = false},
	{text = "Power is miiiiine!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 200},
	{name = "platinum coin", chance = 100000, maxCount = 6},
	{name = "great spirit potion", chance = 26010, maxCount = 5},
	{name = "great mana potion", chance = 25210, maxCount = 5},
	{name = "vexclaw talon", chance = 21500},
	{name = "demonic essence", chance = 20730},
	{name = "ultimate health potion", chance = 19960, maxCount = 5},
	{name = "fire mushroom", chance = 19940, maxCount = 6},
	{name = "golden sickle", chance = 18940},
	{name = "purple tome", chance = 18450},
	{name = "small amethyst", chance = 10090, maxCount = 5},
	{name = "small topaz", chance = 9790, maxCount = 5},
	{name = "small emerald", chance = 9770, maxCount = 5},
	{name = "small ruby", chance = 9590, maxCount = 5},
	{name = "talon", chance = 5400},
	{name = "yellow gem", chance = 5090},
	{name = "wand of voodoo", chance = 4940},
	{name = "red gem", chance = 4730},
	{name = "ice rapier", chance = 4730},
	{name = "fire axe", chance = 3520},
	{name = "might ring", chance = 2250},
	{name = "giant sword", chance = 1880},
	{name = "stealth ring", chance = 1790},
	{name = "energy ring", chance = 1790},
	{name = "rift lance", chance = 1360},
	{name = "ring of healing", chance = 1320},
	{name = "platinum amulet", chance = 940},
	{name = "devil helmet", chance = 520},
	{name = "rift crossbow", chance = 370},
	{name = "magic plate armor", chance = 70},
	{name = "demonrage sword", chance = 30}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 75, attack = 150},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="choking fear drown", interval = 2000, chance = 20, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -400, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -490, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="energy strike", interval = 2000, chance = 10, minDamage = -210, maxDamage = -300, range = 1, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -300, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
