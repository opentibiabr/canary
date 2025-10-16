local mType = Game.createMonsterType("Paladin's Apparition")
local monster = {}

monster.description = "a paladin's apparition"
monster.experience = 28600
monster.outfit = {
	lookType = 129,
	lookHead = 57,
	lookBody = 42,
	lookLegs = 114,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1948
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Mirrored Nightmare.",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 111
monster.speed = 235
monster.manaCost = 0

monster.events = {
	"MirroredNightmareBossAccess",
}

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I could be your evil twin!", yell = false },
	{ text = "I'll take your place when you are gone.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 3369, chance = 23000 }, -- warrior helmet
	{ id = 7642, chance = 23000 }, -- great spirit potion
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 829, chance = 5000 }, -- glacier mask
	{ id = 3575, chance = 5000 }, -- wood cape
	{ id = 5741, chance = 5000 }, -- skull helmet
	{ id = 23526, chance = 5000 }, -- collar of blue plasma
	{ id = 815, chance = 5000 }, -- glacier amulet
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 23529, chance = 1000 }, -- ring of blue plasma
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 8027, chance = 260 }, -- composite hornbow
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -850 },
	{ name = "combat", interval = 4000, chance = 26, type = COMBAT_ICEDAMAGE, minDamage = -840, maxDamage = -1000, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true },
	{ name = "ice chain", interval = 5000, chance = 20, minDamage = -1050, maxDamage = -1300, range = 7 },
	{ name = "combat", interval = 9500, chance = 52, type = COMBAT_HOLYDAMAGE, minDamage = -1050, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 3000, chance = 22, type = COMBAT_HOLYDAMAGE, minDamage = -1200, maxDamage = -1400, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 4000, chance = 23, type = COMBAT_PHYSICALDAMAGE, minDamage = -900, maxDamage = -1350, radius = 4, shootEffect = CONST_ANI_EXPLOSION, range = 7, effect = CONST_ME_EXPLOSIONHIT, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -11 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
