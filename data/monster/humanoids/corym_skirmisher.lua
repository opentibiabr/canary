local mType = Game.createMonsterType("Corym Skirmisher")
local monster = {}

monster.description = "a corym skirmisher"
monster.experience = 260
monster.outfit = {
	lookType = 533,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 101,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 917
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Venore Corym Cave, Tiquanda Corym Cave, Corym Black Market, \z
		Carlin Corym Cave/Dwarf Mines Diggers Depths Mine, Upper Spike."
	}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 19726
monster.speed = 200
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
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
	{text = "Squeak! Squeak!", yell = false},
	{text = "<sniff> <sniff> <sniff>", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50000, maxCount = 45},
	{id = 2696, chance = 20000},
	{name = "bola", chance = 7692},
	{name = "spike shield", chance = 645},
	{name = "ratana", chance = 2702},
	{name = "life preserver", chance = 2941},
	{name = "cheese cutter", chance = 8333},
	{name = "cheesy figurine", chance = 854},
	{name = "earflap", chance = 9090},
	{name = "soft cheese", chance = 14285},
	{name = "rat cheese", chance = 16666},
	{name = "rat god doll", chance = 12},
	{name = "leather harness", chance = 561}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -90, range = 7, shootEffect = CONST_ANI_WHIRLWINDCLUB, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
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
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
