local mType = Game.createMonsterType("Shaburak Prince")
local monster = {}

monster.description = "a shaburak Prince"
monster.experience = 1700
monster.outfit = {
	lookType = 418,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 726
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Demonwar Crypt."
	}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "fire"
monster.corpse = 13969
monster.speed = 250
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
	{text = "GREEN IS MEAN!", yell = true},
	{text = "WE RULE!", yell = true},
	{text = "POWER TO THE SHABURAK!", yell = true},
	{text = "DEATH TO THE ASKARAK!", yell = false},
	{text = "ONLY WE ARE TRUE DEMONS!", yell = false}
}

monster.loot = {
	{name = "small ruby", chance = 12500, maxCount = 5},
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "gold coin", chance = 50000, maxCount = 78},
	{name = "platinum coin", chance = 33333, maxCount = 4},
	{name = "stealth ring", chance = 5000},
	{name = "wand of inferno", chance = 892},
	{name = "steel boots", chance = 89},
	{name = "brown mushroom", chance = 4545},
	{name = "magic sulphur", chance = 534},
	{name = "butcher's axe", chance = 357},
	{name = "bullseye potion", chance = 714},
	{name = "strong health potion", chance = 14285},
	{name = "strong mana potion", chance = 14285},
	{name = "magma coat", chance = 714},
	{name = "demonic finger", chance = 178}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -319},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -40, maxDamage = -90, range = 7, radius = 6, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = false},
	{name ="shaburak wave", interval = 2000, chance = 15, minDamage = -100, maxDamage = -200, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, length = 4, spread = 0, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 15000}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = -30},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
