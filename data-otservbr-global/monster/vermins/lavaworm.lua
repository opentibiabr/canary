local mType = Game.createMonsterType("Lavaworm")
local monster = {}

monster.description = "a lavaworm"
monster.experience = 6500
monster.outfit = {
	lookType = 1394,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2088
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Grotto of the Lost.",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "fire"
monster.corpse = 36679
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	level = 3,
	color = 205,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 18 }, -- platinum coin
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 36769, chance = 23000 }, -- lavaworm spike roots
	{ id = 3038, chance = 23000 }, -- green gem
	{ id = 36770, chance = 23000 }, -- lavaworm spikes
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3369, chance = 5000 }, -- warrior helmet
	{ id = 8082, chance = 5000 }, -- underworld rod
	{ id = 8094, chance = 5000 }, -- wand of voodoo
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 25698, chance = 5000 }, -- butterfly ring
	{ id = 36771, chance = 5000 }, -- lavaworm jaws
	{ id = 3391, chance = 1000 }, -- crusader helmet
	{ id = 3373, chance = 260 }, -- strange helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2750, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -760, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_FIREDAMAGE, minDamage = -700, maxDamage = -780, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2750, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -700, range = 5, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
