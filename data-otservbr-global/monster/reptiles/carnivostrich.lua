local mType = Game.createMonsterType("Carnivostrich")
local monster = {}

monster.description = "a carnivostrich"
monster.experience = 7290
monster.outfit = {
	lookType = 1605,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2341
monster.Bestiary = {
	class = "Bird",
	race = BESTY_RACE_BIRD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol"
	}

monster.health = 8250
monster.maxHealth = 8250
monster.race = "blood"
monster.corpse = 42226 
monster.speed = 168
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Yooohhouuu!", yell = false},
	{text = "GRROARR", yell = false},
	{text = "Grrrrrrrr!", yell = false},
	{text = "Yoooohhuuuu!!", yell = false},
}

monster.loot = {
	{name = "platinum coin", chance = 8045, maxCount = 22},
	{name = "small ruby", chance = 1639, maxCount = 8},
	{name = "small emerald", chance = 833, maxCount = 8},
	{name = "strong mana potion", chance = 491, maxCount = 4},
	{name = "carnivostrich feather", chance = 347, maxCount = 4},
	{name = "underworld rod", chance = 242},
	{name = "wand of voodoo", chance = 211},
	{name = "blue gem", chance = 209},
	{name = "spellbook of mind control", chance = 81},
	{name = "boots of haste", chance = 62},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -498},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -386, maxDamage = -480, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -135, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = true},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -350, maxDamage = -495, length = 7, spread = 0, effect = CONST_ME_BLACKSMOKE, target = false},
	{name ="thunderstorm ring", interval = 2000, chance = 20, minDamage = -325, maxDamage = -415},
}

monster.defenses = {
	defense = 50,
	armor = 63,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
