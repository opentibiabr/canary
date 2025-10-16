local mType = Game.createMonsterType("Shaburak Lord")
local monster = {}

monster.description = "a shaburak lord"
monster.experience = 1200
monster.outfit = {
	lookType = 409,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 725
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Demonwar Crypt",
}

monster.health = 2100
monster.maxHealth = 2100
monster.race = "fire"
monster.corpse = 12823
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
	{ text = "ONLY WE ARE TRUE DEMONS!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 178 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 2 }, -- platinum coin
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 3030, chance = 23000, maxCount = 5 }, -- small ruby
	{ id = 3051, chance = 5000 }, -- energy ring
	{ id = 3725, chance = 5000 }, -- brown mushroom
	{ id = 3071, chance = 1000 }, -- wand of inferno
	{ id = 5904, chance = 1000 }, -- magic sulphur
	{ id = 7443, chance = 1000 }, -- bullseye potion
	{ id = 826, chance = 260 }, -- magma coat
	{ id = 3554, chance = 260 }, -- steel boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -251 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -75, range = 7, radius = 6, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "shaburak wave", interval = 2000, chance = 15, minDamage = -80, maxDamage = -170, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -140, maxDamage = -200, length = 4, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -650, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 20,
	armor = 40,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 65 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
