local mType = Game.createMonsterType("Askarak Prince")
local monster = {}

monster.description = "an askarak prince"
monster.experience = 1700
monster.outfit = {
	lookType = 419,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 729
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Demonwar Crypt.",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "venom"
monster.corpse = 12822
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "DEATH TO THE SHABURAK!", yell = true },
	{ text = "GREEN WILL RULE!", yell = true },
	{ text = "ONLY WE ARE TRUE DEMONS!", yell = true },
	{ text = "RED IS MAD!", yell = true },
	{ text = "WE RULE!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 186 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 4 }, -- platinum coin
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 3032, chance = 23000, maxCount = 5 }, -- small emerald
	{ id = 3725, chance = 23000, maxCount = 4 }, -- brown mushroom
	{ id = 3049, chance = 5000 }, -- stealth ring
	{ id = 7440, chance = 5000 }, -- mastermind potion
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 5904, chance = 1000 }, -- magic sulphur
	{ id = 8084, chance = 1000 }, -- springsprout rod
	{ id = 12541, chance = 1000 }, -- demonic finger
	{ id = 3281, chance = 260 }, -- giant sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -353 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -70, maxDamage = -250, range = 7, radius = 6, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "askarak wave", interval = 2000, chance = 15, minDamage = -100, maxDamage = -200, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -200, length = 4, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 30,
	armor = 45,
	mitigation = 1.32,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 70 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
