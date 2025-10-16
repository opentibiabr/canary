local mType = Game.createMonsterType("Insane Siren")
local monster = {}

monster.description = "an insane siren"
monster.experience = 6000
monster.outfit = {
	lookType = 1136,
	lookHead = 72,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 4,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1735
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Summer.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 30133
monster.speed = 210
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
	{ text = "Dream or nightmare?", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 12 }, -- platinum coin
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 11474, chance = 23000 }, -- miraculum
	{ id = 30005, chance = 23000 }, -- dream essence egg
	{ id = 8093, chance = 5000 }, -- wand of draconia
	{ id = 5922, chance = 5000 }, -- holy orchid
	{ id = 817, chance = 5000 }, -- magma amulet
	{ id = 3071, chance = 5000 }, -- wand of inferno
	{ id = 3320, chance = 5000 }, -- fire axe
	{ id = 826, chance = 5000 }, -- magma coat
	{ id = 29995, chance = 5000 }, -- sun fruit
	{ id = 3075, chance = 5000 }, -- wand of dragonbreath
	{ id = 821, chance = 1000 }, -- magma legs
	{ id = 827, chance = 260 }, -- magma monocle
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2300, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -300, length = 3, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2600, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -300, radius = 1, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2900, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 3200, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, radius = 3, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 3500, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -300, range = 6, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "combat", interval = 3800, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -300, range = 6, radius = 2, effect = CONST_ME_FIREAREA, target = true },
	{ name = "sparks chain", interval = 4100, chance = 17, minDamage = -100, maxDamage = -200, range = 3, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 76,
	mitigation = 2.11,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
