local mType = Game.createMonsterType("Dark Torturer")
local monster = {}

monster.description = "a dark torturer"
monster.experience = 4650
monster.outfit = {
	lookType = 234,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 285
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Vengoth, Blood Halls, Oramond Dungeon, Roshamuul Prison."
	}

monster.health = 7350
monster.maxHealth = 7350
monster.race = "undead"
monster.corpse = 6328
monster.speed = 370
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
	{text = "You like it, don't you?", yell = false},
	{text = "IahaEhheAie!", yell = false},
	{text = "It's party time!", yell = false},
	{text = "Harrr, Harrr!", yell = false},
	{text = "The torturer is in!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "gold coin", chance = 40000, maxCount = 99},
	{name = "platinum coin", chance = 55000, maxCount = 8},
	{name = "golden legs", chance = 30},
	{id = 2558, chance = 5250},
	{name = "steel boots", chance = 5050},
	{name = "ham", chance = 60000, maxCount = 2},
	{name = "orichalcum pearl", chance = 2760, maxCount = 2},
	{name = "cat's paw", chance = 2222},
	{name = "jewelled backpack", chance = 1192},
	{name = "soul orb", chance = 23000},
	{id = 6300, chance = 2008},
	{name = "demonic essence", chance = 8520},
	{name = "concentrated demonic blood", chance = 33333, maxCount = 3},
	{name = "assassin star", chance = 2222, maxCount = 5},
	{name = "vile axe", chance = 480},
	{name = "butcher's axe", chance = 850},
	{name = "great mana potion", chance = 14830, maxCount = 2},
	{name = "great health potion", chance = 10000, maxCount = 2},
	{name = "gold ingot", chance = 3140}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -781, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false},
	{name ="dark torturer skill reducer", interval = 2000, chance = 5, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = 90},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
