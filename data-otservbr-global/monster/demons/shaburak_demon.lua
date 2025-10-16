local mType = Game.createMonsterType("Shaburak Demon")
local monster = {}

monster.description = "a shaburak demon"
monster.experience = 900
monster.outfit = {
	lookType = 417,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 724
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Demonwar Crypt.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "fire"
monster.corpse = 12658
monster.speed = 115
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
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GREEN IS MEAN!", yell = true },
	{ text = "WE RULE!", yell = true },
	{ text = "POWER TO THE SHABURAK!", yell = true },
	{ text = "DEATH TO THE ASKARAK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 255 }, -- gold coin
	{ id = 7378, chance = 23000, maxCount = 6 }, -- royal spear
	{ id = 236, chance = 5000 }, -- strong health potion
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 3725, chance = 5000 }, -- brown mushroom
	{ id = 3030, chance = 5000, maxCount = 5 }, -- small ruby
	{ id = 7443, chance = 1000 }, -- bullseye potion
	{ id = 3051, chance = 1000 }, -- energy ring
	{ id = 2995, chance = 1000 }, -- piggy bank
	{ id = 3071, chance = 1000 }, -- wand of inferno
	{ id = 821, chance = 260 }, -- magma legs
	{ id = 5904, chance = 260 }, -- magic sulphur
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -113 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -60, range = 7, radius = 6, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "shaburak wave", interval = 2000, chance = 15, minDamage = -70, maxDamage = -140, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -130, maxDamage = -170, length = 4, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -600, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 15,
	armor = 35,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 60 },
	{ type = COMBAT_EARTHDAMAGE, percent = -25 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 60 },
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
