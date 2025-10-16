local mType = Game.createMonsterType("Lizard High Guard")
local monster = {}

monster.description = "a lizard high guard"
monster.experience = 1450
monster.outfit = {
	lookType = 337,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 625
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Zzaion, Zao Palace and its antechambers, Muggy Plains, Zao Orc Land (single spawn in fort), \z
		Corruption Hole, Razachai, Temple of Equilibrium, Northern Zao Plantations.",
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 10355
monster.speed = 119
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "Hizzzzzzz!", yell = false },
	{ text = "To armzzzz!", yell = false },
	{ text = "Engage zze aggrezzor!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 227 }, -- gold coin
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 10416, chance = 23000 }, -- high guard shoulderplates
	{ id = 10408, chance = 23000 }, -- spiked iron ball
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 3035, chance = 5000, maxCount = 2 }, -- platinum coin
	{ id = 10328, chance = 5000 }, -- bunch of ripe rice
	{ id = 10415, chance = 5000 }, -- high guard flag
	{ id = 3032, chance = 5000, maxCount = 4 }, -- small emerald
	{ id = 10289, chance = 5000 }, -- red lantern
	{ id = 5876, chance = 1000 }, -- lizard leather
	{ id = 5881, chance = 1000 }, -- lizard scale
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 10387, chance = 1000 }, -- zaoan legs
	{ id = 10386, chance = 1000 }, -- zaoan shoes
	{ id = 10384, chance = 260 }, -- zaoan armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -306 },
}

monster.defenses = {
	defense = 35,
	armor = 40,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 25, maxDamage = 75, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 45 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
