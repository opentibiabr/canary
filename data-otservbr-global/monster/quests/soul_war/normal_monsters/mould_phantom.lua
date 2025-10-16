local mType = Game.createMonsterType("Mould Phantom")
local monster = {}

monster.description = "a mould phantom"
monster.experience = 18330
monster.outfit = {
	lookType = 1298,
	lookHead = 106,
	lookBody = 60,
	lookLegs = 131,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1945
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Rotten Wasteland.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 34133
monster.speed = 240
monster.manaCost = 0

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
	{ text = "Everything decomposes.", yell = false },
	{ text = "I love the smell of rotten flesh.", yell = false },
	{ text = "The earth will take you back.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 8094, chance = 5000 }, -- wand of voodoo
	{ id = 14247, chance = 5000 }, -- ornate crossbow
	{ id = 16096, chance = 5000, maxCount = 2 }, -- wand of defiance
	{ id = 34141, chance = 5000 }, -- mould heart
	{ id = 34148, chance = 5000 }, -- mould robe
	{ id = 23529, chance = 1000 }, -- ring of blue plasma
	{ id = 23526, chance = 1000 }, -- collar of blue plasma
	{ id = 16163, chance = 1000 }, -- crystal crossbow
	{ id = 3081, chance = 260 }, -- stone skin amulet
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "poison chain", interval = 2000, chance = 15, minDamage = -1000, maxDamage = -1250, range = 7 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1100, maxDamage = -1350, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -1030, maxDamage = -1350, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -1100, maxDamage = -1300, radius = 4, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "extended holy chain", interval = 2000, chance = 15, minDamage = -400, maxDamage = -700, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
