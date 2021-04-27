local mType = Game.createMonsterType("Hellfire Fighter")
local monster = {}

monster.description = "a hellfire fighter"
monster.experience = 3120
monster.outfit = {
	lookType = 243,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 295
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, Demon Forge, Fury Dungeon."
	}

monster.health = 3800
monster.maxHealth = 3800
monster.race = "fire"
monster.corpse = 6324
monster.speed = 330
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
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
}

monster.loot = {
	{name = "emerald bangle", chance = 2200},
	{id = 2136, chance = 190},
	{name = "small diamond", chance = 1400},
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "gold coin", chance = 40000, maxCount = 100},
	{name = "gold coin", chance = 10000, maxCount = 46},
	{name = "wand of inferno", chance = 9450},
	{name = "burnt scroll", chance = 50000},
	{name = "blank rune", chance = 30000, maxCount = 2},
	{name = "fire sword", chance = 4140},
	{name = "fire axe", chance = 440},
	{name = "soul orb", chance = 12150},
	{name = "demonic essence", chance = 14500},
	{name = "magma legs", chance = 730},
	{name = "magma coat", chance = 470},
	{name = "fiery heart", chance = 9570},
	{name = "piece of hellfire armor", chance = 5060},
	{id = 13757, chance = 670}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -392, maxDamage = -1500, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -330, range = 7, radius = 3, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="hellfire fighter soulfire", interval = 2000, chance = 15, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -25},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
