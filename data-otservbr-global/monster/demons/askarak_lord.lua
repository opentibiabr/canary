local mType = Game.createMonsterType("Askarak Lord")
local monster = {}

monster.description = "an askarak lord"
monster.experience = 1200
monster.outfit = {
	lookType = 410,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 728
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

monster.health = 2100
monster.maxHealth = 2100
monster.race = "venom"
monster.corpse = 12821
monster.speed = 120
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
	{ id = 3031, chance = 95913, maxCount = 190 }, -- Gold Coin
	{ id = 3035, chance = 35515, maxCount = 2 }, -- Platinum Coin
	{ id = 3032, chance = 6388, maxCount = 5 }, -- Small Emerald
	{ id = 237, chance = 7670 }, -- Strong Mana Potion
	{ id = 236, chance = 6790 }, -- Strong Health Potion
	{ id = 3725, chance = 4910 }, -- Brown Mushroom
	{ id = 3051, chance = 840 }, -- Energy Ring
	{ id = 5904, chance = 590 }, -- Magic Sulphur
	{ id = 7440, chance = 1010 }, -- Mastermind Potion
	{ id = 8084, chance = 700 }, -- Springsprout Rod
	{ id = 7368, chance = 30, maxCount = 5 }, -- Assassin Star
	{ id = 811, chance = 30 }, -- Terra Mantle
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -186 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -80, range = 7, radius = 6, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "askarak wave", interval = 2000, chance = 15, minDamage = -95, maxDamage = -180, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -130, maxDamage = -180, length = 4, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -650, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 20,
	armor = 40,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 120, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 65 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 65 },
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
