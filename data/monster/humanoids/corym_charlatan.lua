local mType = Game.createMonsterType("Corym Charlatan")
local monster = {}

monster.description = "a corym charlatan"
monster.experience = 150
monster.outfit = {
	lookType = 532,
	lookHead = 0,
	lookBody = 97,
	lookLegs = 116,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 916
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Venore Corym Cave, Tiquanda Corym Cave, Corym Black Market, \z
		Carlin Corym Cave/Dwarf Mines Diggers Depths Mine, Upper Spike."
	}

monster.health = 250
monster.maxHealth = 250
monster.race = "blood"
monster.corpse = 19725
monster.speed = 190
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
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
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{text = "Mehehe!", yell = false},
	{text = "Beware! Me hexing you!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50000, maxCount = 35},
	{id = 2696, chance = 10000},
	{name = "bola", chance = 7692},
	{name = "spike shield", chance = 492},
	{name = "ratana", chance = 909},
	{name = "life preserver", chance = 854},
	{name = "cheese cutter", chance = 5882},
	{name = "cheesy figurine", chance = 518},
	{name = "earflap", chance = 7142},
	{name = "soft cheese", chance = 12500},
	{name = "rat cheese", chance = 14285},
	{name = "leather harness", chance = 537}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -105}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
