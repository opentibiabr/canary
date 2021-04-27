local mType = Game.createMonsterType("Cliff Strider")
local monster = {}

monster.description = "a cliff strider"
monster.experience = 5700
monster.outfit = {
	lookType = 497,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 889
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3."
	}

monster.health = 9400
monster.maxHealth = 9400
monster.race = "undead"
monster.corpse = 17420
monster.speed = 246
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{text = "Knorrrr", yell = false}
}

monster.loot = {
	{name = "white pearl", chance = 9630, maxCount = 3},
	{name = "black pearl", chance = 9090},
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "gold coin", chance = 100000, maxCount = 95},
	{name = "platinum coin", chance = 100000, maxCount = 10},
	{name = "red gem", chance = 6110},
	{name = "blue gem", chance = 830},
	{name = "giant sword", chance = 620},
	{name = "hammer of wrath", chance = 70},
	{name = "knight legs", chance = 830},
	{name = "crown armor", chance = 310},
	{name = "crusader helmet", chance = 410},
	{name = "steel boots", chance = 100},
	{name = "iron ore", chance = 14490},
	{name = "magic sulphur", chance = 1450},
	{name = "soul orb", chance = 17080},
	{name = "sapphire hammer", chance = 1350},
	{name = "spiked squelcher", chance = 1040},
	{name = "great mana potion", chance = 30950, maxCount = 4},
	{name = "ultimate health potion", chance = 25260, maxCount = 2},
	{name = "crystal of balance", chance = 2690},
	{name = "crystal of power", chance = 720},
	{name = "shiny stone", chance = 11280},
	{name = "wand of defiance", chance = 2000},
	{name = "glacial rod", chance = 1240},
	{name = "blue crystal shard", chance = 6520},
	{name = "blue crystal splinter", chance = 7970, maxCount = 2},
	{name = "cyan crystal fragment", chance = 8070},
	{name = "pulverized ore", chance = 15110},
	{name = "cliff strider claw", chance = 15630},
	{name = "vein of ore", chance = 18000, maxCount = 2},
	{name = "prismatic bolt", chance = 9090, maxCount = 8},
	{name = "crystalline sword", chance = 620},
	{name = "crystal crossbow", chance = 830}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true},
	{name ="cliff strider skill reducer", interval = 2000, chance = 10, target = false},
	{name ="cliff strider electrify", interval = 2000, chance = 15, range = 1, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, length = 6, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -300, radius = 4, effect = CONST_ME_YELLOWENERGY, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 55
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 1},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 1},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
