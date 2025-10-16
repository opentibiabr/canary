local mType = Game.createMonsterType("Lizard Sentinel")
local monster = {}

monster.description = "a lizard sentinel"
monster.experience = 110
monster.outfit = {
	lookType = 114,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 114
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Chor, Zzaion and Foreigner Quarter.",
}

monster.health = 265
monster.maxHealth = 265
monster.race = "blood"
monster.corpse = 6040
monster.speed = 90
monster.manaCost = 560

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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 10,
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
	{ text = "Tssss!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 80 }, -- gold coin
	{ id = 3277, chance = 80000, maxCount = 3 }, -- spear
	{ id = 3358, chance = 80000 }, -- chain armor
	{ id = 3377, chance = 80000 }, -- scale armor
	{ id = 3347, chance = 5000 }, -- hunting spear
	{ id = 3313, chance = 1000 }, -- obsidian lance
	{ id = 5876, chance = 1000 }, -- lizard leather
	{ id = 5881, chance = 1000 }, -- lizard scale
	{ id = 266, chance = 1000 }, -- health potion
	{ id = 3269, chance = 1000 }, -- halberd
	{ id = 3444, chance = 260 }, -- sentinel shield
	{ id = 3028, chance = 260 }, -- small diamond
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_SPEAR, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 17,
	mitigation = 0.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
