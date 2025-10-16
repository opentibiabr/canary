local mType = Game.createMonsterType("Manticore")
local monster = {}

monster.description = "a manticore"
monster.experience = 5100
monster.outfit = {
	lookType = 1189,
	lookHead = 116,
	lookBody = 97,
	lookLegs = 113,
	lookFeet = 20,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1816
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh.",
}

monster.health = 6700
monster.maxHealth = 6700
monster.race = "blood"
monster.corpse = 31390
monster.speed = 150
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "I'm spotting my next meal", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 763, chance = 23000, maxCount = 8 }, -- flaming arrow
	{ id = 3032, chance = 23000 }, -- small emerald
	{ id = 16127, chance = 23000 }, -- green crystal fragment
	{ id = 31439, chance = 23000 }, -- manticore tail
	{ id = 31440, chance = 23000 }, -- manticore ear
	{ id = 818, chance = 5000 }, -- magma boots
	{ id = 821, chance = 5000 }, -- magma legs
	{ id = 826, chance = 5000 }, -- magma coat
	{ id = 827, chance = 5000 }, -- magma monocle
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3075, chance = 5000 }, -- wand of dragonbreath
	{ id = 25737, chance = 5000 }, -- rainbow quartz
	{ id = 24962, chance = 5000, maxCount = 3 }, -- prismatic quartz
	{ id = 25759, chance = 5000, maxCount = 2 }, -- royal star
	{ id = 8093, chance = 1000 }, -- wand of draconia
	{ id = 16115, chance = 1000 }, -- wand of everblazing
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -450, length = 8, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -400, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_FIREDAMAGE, minDamage = -450, maxDamage = -550, range = 4, shootEffect = CONST_ANI_BURSTARROW, target = true },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
