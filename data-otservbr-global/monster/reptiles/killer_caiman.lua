local mType = Game.createMonsterType("Killer Caiman")
local monster = {}

monster.description = "a killer caiman"
monster.experience = 900
monster.outfit = {
	lookType = 358,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 627
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Northern Zao Plantations, Souleater Mountains, Muggy Plains, \z
		Killer Caiman Cave in the Zao Steppe, Chyllfroest.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 10221
monster.speed = 93
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 180 }, -- gold coin
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 10279, chance = 80000 }, -- piece of crocodile leather
	{ id = 3032, chance = 23000, maxCount = 5 }, -- small emerald
	{ id = 10328, chance = 5000, maxCount = 2 }, -- bunch of ripe rice
	{ id = 3313, chance = 5000 }, -- obsidian lance
	{ id = 3556, chance = 260 }, -- crocodile boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -180 },
}

monster.defenses = {
	defense = 35,
	armor = 40,
	mitigation = 0.38,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
