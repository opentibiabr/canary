local mType = Game.createMonsterType("Plaguesmith")
local monster = {}

monster.description = "a plaguesmith"
monster.experience = 3555
monster.outfit = {
	lookType = 247,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 314
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Edron Demon Forge (The Vats, The Foundry), \z
		Magician Quarter, Alchemist Quarter, Roshamuul Prison."
	}

monster.health = 8250
monster.maxHealth = 8250
monster.race = "venom"
monster.corpse = 6516
monster.speed = 320
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 500,
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
	{text = "You are looking a bit feverish!", yell = false},
	{text = "You don't look that good!", yell = false},
	{text = "Hachoo!", yell = false},
	{text = "Cough Cough", yell = false}
}

monster.loot = {
	{name = "emerald bangle", chance = 341},
	{name = "silver brooch", chance = 2000},
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "gold coin", chance = 40000, maxCount = 100},
	{name = "gold coin", chance = 50000, maxCount = 65},
	{name = "small amethyst", chance = 5000, maxCount = 3},
	{name = "platinum coin", chance = 7142, maxCount = 2},
	{name = "axe ring", chance = 4347},
	{name = "club ring", chance = 4761},
	{name = "piece of iron", chance = 20000},
	{name = "mouldy cheese", chance = 50000},
	{id = 33528, chance = 60000},
	{name = "two handed sword", chance = 20000},
	{name = "war hammer", chance = 2127},
	{name = "morning star", chance = 29000},
	{name = "battle hammer", chance = 20000},
	{name = "hammer of wrath", chance = 952},
	{name = "knight legs", chance = 6250},
	{name = "steel shield", chance = 20000},
	{name = "steel boots", chance = 1123},
	{name = "piece of royal steel", chance = 1234},
	{name = "piece of hell steel", chance = 1010},
	{name = "piece of draconian steel", chance = 1030},
	{name = "soul orb", chance = 11111},
	{name = "demonic essence", chance = 9033},
	{name = "onyx arrow", chance = 7692, maxCount = 4},
	{name = "great health potion", chance = 10000},
	{id = 9810, chance = 540}
}

monster.attacks = {
	{name ="melee", interval = 1500, chance = 100, minDamage = 0, maxDamage = -539, condition = {type = CONDITION_POISON, totalDamage = 200, interval = 4000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -114, radius = 4, effect = CONST_ME_POISONAREA, target = false},
	{name ="plaguesmith wave", interval = 2000, chance = 10, minDamage = -100, maxDamage = -350, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -800, radius = 4, effect = CONST_ME_POISONAREA, target = false, duration = 30000}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 1}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
