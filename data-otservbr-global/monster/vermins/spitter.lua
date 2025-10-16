local mType = Game.createMonsterType("Spitter")
local monster = {}

monster.description = "a spitter"
monster.experience = 1100
monster.outfit = {
	lookType = 461,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 791
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "The Hive, Hive Outpost.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 13979
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 40,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Spotz!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 190 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 3725, chance = 80000, maxCount = 3 }, -- brown mushroom
	{ id = 14083, chance = 80000 }, -- compound eye
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3033, chance = 80000, maxCount = 2 }, -- small amethyst
	{ id = 14078, chance = 80000 }, -- spitter nose
	{ id = 3053, chance = 5000 }, -- time ring
	{ id = 7449, chance = 1000 }, -- crystal sword
	{ id = 14086, chance = 260 }, -- calopteryx cape
	{ id = 3391, chance = 260 }, -- crusader helmet
	{ id = 14087, chance = 260 }, -- grasshopper legs
	{ id = 3038, chance = 260 }, -- green gem
	{ id = 7440, chance = 260 }, -- mastermind potion
	{ id = 3055, chance = 260 }, -- platinum amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150, condition = { type = CONDITION_POISON, totalDamage = 240, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -160, range = 7, radius = 3, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 20,
	armor = 48,
	mitigation = 1.60,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -11 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
