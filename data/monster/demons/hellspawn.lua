local mType = Game.createMonsterType("Hellspawn")
local monster = {}

monster.description = "a hellspawn"
monster.experience = 2550
monster.outfit = {
	lookType = 322,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 519
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Magician Quarter, Vengoth, Deeper Banuta, Formorgar Mines, Chyllfroest, Oramond Dungeon."
	}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "fire"
monster.corpse = 9923
monster.speed = 344
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15
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
	{text = "Your fragile bones are like toothpicks to me.", yell = false},
	{text = "You little weasel will not live to see another day.", yell = false},
	{text = "I'm just a messenger of what's yet to come.", yell = false},
	{text = "HRAAAAAAAAAAAAAAAARRRR!", yell = true},
	{text = "I'm taking you down with me!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 60000, maxCount = 100},
	{name = "gold coin", chance = 60000, maxCount = 100},
	{name = "gold coin", chance = 60000, maxCount = 36},
	{name = "morning star", chance = 10000},
	{name = "warrior helmet", chance = 1886},
	{name = "knight legs", chance = 3030},
	{name = "red mushroom", chance = 7692, maxCount = 2},
	{name = "demonic essence", chance = 9090},
	{name = "assassin star", chance = 9090, maxCount = 2},
	{name = "onyx flail", chance = 103},
	{name = "berserk potion", chance = 934},
	{name = "spiked squelcher", chance = 970},
	{name = "great health potion", chance = 40333},
	{name = "ultimate health potion", chance = 9090},
	{id = 9809, chance = 3125},
	{id = 9810, chance = 3125},
	{id = 9948, chance = 140},
	{name = "black skull", chance = 151},
	{name = "small topaz", chance = 5882, maxCount = 3},
	{name = "hellspawn tail", chance = 20000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -352},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -175, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = false},
	{name ="hellspawn soulfire", interval = 2000, chance = 10, range = 5, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 120, maxDamage = 230, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 270, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
